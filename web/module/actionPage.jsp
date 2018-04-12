<%@ include file="/WEB-INF/template/include.jsp"%>

<%@ include file="/WEB-INF/template/header.jsp"%>

<html>
<head>

  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <link rel="stylesheet" href="https://cdn.datatables.net/1.10.15/css/jquery.dataTables.min.css">
  <script src="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src='<%= request.getContextPath() %>/dwr/interface/ObsProgramDWR.js'></script>
<script type="text/javascript">


$(document).ready(function(){ 
		var url=window.location.href;
		var patientAProgram=[];
		var count1=0,count2=0,count3=0;
		var submitBool=false;
		 if(url.includes("openmrstjk"))
		 	url="/openmrstjk";
		 else
			 url="/openmrs";
		 var programA=${patientAProgramjson};
		 var allProgram=getAllPrograms();
		 $("#dialog1").hide();
		 $("#dialog2").hide();
		 $("#dialog3").hide();
		 
			$('#primaryTable').DataTable({
					 			    "paging" : true,
					 				"lengthChange" : false,
					 				"searching" : false,
					 				"ordering" : true,
					 				"info" : false,
					 				"autoWidth" : true,
					 				"sDom" : 'lfrtip',
			});
			var table = $('#duplicateTable').DataTable({
			        		    	"paging" : true,
					 				"lengthChange" : false,
					 				"searching" : false,
					 				"ordering" : true,
					 				"info" : false,
					 				"autoWidth" : true,
					 				"sDom" : 'lfrtip',
			});
			
			 $('#selectAll').on('click', function(){
			      var rows = table.rows({ 'search': 'applied' }).nodes();
			      $('input[type="checkbox"]', rows).prop('checked', this.checked);
			   });

			   $('#duplicateTable tbody').on('change', 'input[type="checkbox"]', function(){
			      if(!this.checked){
			         var el = $('#selectAll').get(0);
			         if(el && el.checked && ('indeterminate' in el)){
			            el.indeterminate = true;
			         }
			      }
			   });
			   $('#swap').click(function(){
				 	window.location.replace(url+"/module/mergePatient/action.form?patientA="+${patientBId}+"&patientB="+${patientAId});
			   });
			   
			   $( "#submitbtn" ).click(function( event ) {
				   
				   if(confirm('<spring:message code="@MODULE_ID@.mergePatient.confirmSubmit" />')==true)
					{  
					   var i = 1,index=[];
					   $('.it').each(function() {
					       if (this.checked) {
					           index.push(i);
					       }
					       i++;
					   });
					   var selected = [];
					   var selectedVal = [];
					   var patientProgram=[]
					   $('#duplicateTable input[type=checkbox]').each(function() {
					       selected.push($(this).attr('name'));
					       selectedVal.push($(this).attr('value'));
					   });
					   var program=getPrograms(selected);
					  
					   if(programA.length==1 && program.length>0)
					   {
						   alert('<spring:message code="@MODULE_ID@.mergePatient.addProgramException" />')
					   }
					   else if(programA.length>1 && program.length>0)
					   {	
						   for(var i=0;i<index.length;i++)
								{
								   for(var j=0;j<programA.length-1;j++)
									{
									if(selectedVal[index[i]]!=undefined && (selectedVal[index[i]].toString()=="Specimen Collection" ||
										selectedVal[index[i]].toString()=="Transfer In" || selectedVal[index[i]].toString()=="Transfer Out"))
						    	 	 {
						    			$( "#programDiv1 select").remove();
										$( "#programDiv1 snap").remove();
										$( "#programDiv1" ).append("<snap>Select any one program: </snap><select id='program1'></select>");
										count1=0;
										for(var k=0;k<programA.length-1;k++)
										{
											if(programA[k].name=="MDR-TB PROGRAM" || programA[k].name=="DOTS Program")
											{
												count1++;
												$( "#program1").append("<option value='"+programA[k].id+"' id='"+programA[k].id+"'>"
														+programA[k].name+"-"+formatDate(programA[k].date)+"</option>");
												$( "#program1").append("<input type='hidden' value='"+selectedVal[index[i]]+"' id='pr_"+programA[k].id+"'>");
												
											}
										}
										if(count1>1)
										{
											$( "#dialog1" ).dialog();
											submitBool=false;
										}
										else if(count1==0)
										{
											alert('<spring:message code="@MODULE_ID@.mergePatient.addProgramException" />');
											submitBool=false;
										}
						    	 	}
						    		else if(selectedVal[index[i]]!=undefined &&  (selectedVal[index[i]].toString()=="TB03" ||
						    			selectedVal[index[i]].toString()=="Form 89"))
						    		{
						    			$( "#programDiv2 select").remove();
										$( "#programDiv2 snap").remove();
										$( "#programDiv2" ).append("<snap>Select any one program: </snap><select id='program2'></select>");
										count2=0;
										for(var k=0;k<programA.length-1;k++)
										{
											if(programA[k].name=="DOTS Program")
											{
												count2++;	
												$( "#program2").append("<option value='"+programA[k].id+"' id='"+programA[k].id+"'>"
													+programA[k].name+"-"+formatDate(programA[k].date)+"</option>");
												$( "#program2").append("<input type='hidden' value='"+selectedVal[index[i]]+"' id='pr_"+programA[k].id+"'>");
											}
										}
										if(count2>1)
										{
											$( "#dialog2" ).dialog();
											submitBool=false;
										}
										else if(count2==0)
										{
											alert('<spring:message code="@MODULE_ID@.mergePatient.addProgramException" />')
											submitBool=false;
										}
						    		}
									else if(selectedVal[index[i]]!=undefined && selectedVal[index[i]].toString()!="Lab Result")
						    		{
										$( "#programDiv3 select").remove();
										$( "#programDiv3 snap").remove();
										$( "#programDiv3" ).append("<snap>Select any one program: </snap><select id='program3'></select>");
										count3=0;
										for(var k=0;k<programA.length-1;k++)
										{
											if(programA[k].name=="MDR-TB PROGRAM")
											{	
												count3++;
												$( "#program3").append("<option value='"+programA[k].id+"' id='"+programA[k].id+"'>"
													+programA[k].name+"-"+formatDate(programA[k].date)+"</option>");
												$( "#program3").append("<input type='hidden' value='"+selectedVal[index[i]]+"' id='pr_"+programA[k].id+"'>");
												
											}
										}
										if(count3>1)
										{
											$( "#dialog3" ).dialog();
											submitBool=false;
										}
										else if(count3==0)
										{
											alert('<spring:message code="@MODULE_ID@.mergePatient.addProgramException" />')
											submitBool=false;
										}
										
						    		}
								   }
								}
						  if(count1<=1 && count2<=1 && count3<=1)
					      {
							  	if(inputInjection()==true)
							 	document.getElementById("duplication").submit();
						  }
					   }
					   else if(program.length==0)
					   {
						   document.getElementById("duplication").submit();
					   }
					}
				 });
			   
			   $("#programSelect1").click(function(){
				   
				   if(inputInjection()==true)
				   document.getElementById("duplication").submit();
			   });
			   
			   $("#programSelect2").click(function(){
				   
				   if(inputInjection()==true)
				   document.getElementById("duplication").submit();
			   });
			   
			   $("#programSelect3").click(function(){
				   
				   if(inputInjection()==true)
				   document.getElementById("duplication").submit();
			   });
			   
});	

function inputInjection()
{
	
		var data="${patientAEncounter}"
		data = data.replace("[","").replace("]","").replace("}","").split(",");
		for(var i=0;i<data.length;i+=3)
		{
			if(data[i+1].indexOf(" program=")!=-1)
			{
				if(data[i+1].replace(" program=","")==jQuery("#program1").val() && jQuery("#pr_"+jQuery("#program1").val()).val()==data[i+2].replace(" name=",""))
				{
					alert("Add new Program, Program Id: "+jQuery("#program1").val()+" already have a Encounter");
					$( "#programDiv1 select").remove();
					$( "#programDiv1 snap").remove();
					$( "#programDiv1 input").remove();
					$( "#dialog1").dialog('close');
					return false;
				}
				else if(data[i+1].replace(" program=","")==jQuery("#program2").val() && jQuery("#pr_"+jQuery("#program2").val()).val()==data[i+2].replace(" name=",""))
				{
					alert("Add new Program, Program Id: "+jQuery("#program2").val()+" already have a Encounter");
					$( "#programDiv2 select").remove();
					$( "#programDiv2 snap").remove();
					$( "#programDiv2 input").remove();
					$( "#dialog2").dialog('close');
					return false;
				}
				else if(data[i+1].replace(" program=","")==jQuery("#program3").val() && jQuery("#pr_"+jQuery("#program3").val()).val()==data[i+2].replace(" name=",""))
				{
					alert("Add new Program, Program Id: "+jQuery("#program3").val()+" already have a Encounter");
					$( "#programDiv3 select").remove();
					$( "#programDiv3 snap").remove();
					$( "#programDiv3 input").remove();
					$( "#dialog3").dialog('close');
					return false;
				}
				i++;
			}
		
		}
	   var input = jQuery("<input>").attr("type", "hidden").attr("name", "programByName1").val(jQuery("#program1").val());
		 jQuery('#duplication').append(jQuery(input));

	   	 input = jQuery("<input>").attr("type", "hidden").attr("name", "programByName2").val(jQuery("#program2").val());
	   	jQuery('#duplication').append(jQuery(input));

	   	 input = jQuery("<input>").attr("type", "hidden").attr("name", "programByName3").val(jQuery("#program3").val());
	   	jQuery('#duplication').append(jQuery(input));
	   	return true;
}

function formatDate(date) {
	  date=new Date(date);
	  var day = date.getDate();
	  var monthIndex = date.getMonth()+1;
	  var year = date.getFullYear();
	  if(monthIndex<10)
		  monthIndex= '0' + monthIndex;
	  if(day<10)
		  day ='0'+ day;
	  return day + '/' + monthIndex + '/' + year;
	  
	}


function getPrograms(selected)
{
	var program=[];
	for(var i=0;i<selected.length;i++)
	{ 
	   var str=selected[i];
	   if(str.indexOf( 'en_' )!= -1)
	   {
		   str = str.replace("en_", '');
		   ObsProgramDWR.getProgramByEncounter(str,{
			   callback:function(data) {
				   program.push(data);
				},
			   async:false
			 } );
	   }
	}
	return program;
}

function getAllPrograms()
{
	var program=[];
		   ObsProgramDWR.getAllPrograms({
			   callback:function(data) {
				   program = data;
				},
			   async:false
			 } );
	return program;
}

function getEncounterByPatient(id)
{
	var encounter=[];
		   ObsProgramDWR.getEncounterByPatient(id,{
			   callback:function(data) {
				   encounter = data;
				},
			   async:false
			 } );
	return encounter;
}
function onEncounterClick(data)
{
	var url=window.location.href;
	 if(url.includes("openmrstjk"))
	 	url="/openmrstjk";
	 else
		 url="/openmrs";
	 
	url=url+"/admin/encounters/encounter.form?encounterId="+data;
	window.location.replace(url);

}
</script>

<style type="text/css">

#primaryDiv, #duplicateDiv {
   float: left;
   width: 45%; 
}
 #duplicateDiv {
   margin-left: 5%;
}

 primaryDiv>table,  primaryDiv>table th,  primaryDiv>table td {
 border: 1px solid black;
 border-collapse: collapse;
}

 duplicateDiv>table,  primaryDiv>table th,  primaryDiv>table td {
 border: 1px solid black;
 border-collapse: collapse;
}

#footer{
 display: -webkit-box !important;
}

.footer{
 display: -webkit-box !important;
}

footer{
 display: -webkit-box !important;
}
</style>

</head>
<body>
<form action="" method="post" name="duplication" id="duplication">
<div id="btnDiv" name="btnDiv" style="float: right; margin-left: 5px;"><input type="button" id="submitbtn" value='<spring:message code="@MODULE_ID@.mergePatient.mergeBtn" />'></div>
<div id="swapDiv" name="swapDiv" style="float: right;  margin-left: 5px;"><input type="button" value='<spring:message code="@MODULE_ID@.mergePatient.swapBtn" />' id="swap"></div>
<div id="primaryDiv">
	<h2><spring:message code="@MODULE_ID@.mergePatient.primaryPatient" /></h2>
	<h3><c:out value="${patientAName}" />(<c:out value="${patientAIdentifier[0].id}" />)</h3>
	<Table id="primaryTable" name="primary">
		<thead>
			<tr>
				<th>Id</th>
				<th><spring:message code="@MODULE_ID@.mergePatient.dataType" /></th>
				<th><spring:message code="@MODULE_ID@.mergePatient.data" /></th>
				<th><spring:message code="@MODULE_ID@.mergePatient.dateCreated" /></th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="identifier" items="${patientAIdentifier}" varStatus="loop">
				<tr>
					<td><c:out value="${identifier.id}" /></td>
					<td>Identifier</td>
					<td><c:out value="${identifier.name}" /></td>
					<td><c:out value="${identifier.date}" /></td>
				</tr>
			</c:forEach>
			<c:forEach var="encounter" items="${patientAEncounter}" varStatus="loop">
				<tr>
					<td><c:out value="${encounter.id}" /></td>
					<td>Encounter</td>
					<td><a onclick="onEncounterClick(${encounter.id})"><c:out value="${encounter.name}" /></a></td>
					<td><c:out value="${encounter.date}" /></td>
				</tr>
			</c:forEach>
			<c:forEach var="program" items="${patientAProgram}" varStatus="loop">
				<tr>
					<td><c:out value="${program.id}" /></td>
					<td>Program</td>			
					<td><c:out value="${program.name}" /></td>
					<td><c:out value="${program.date}" /></td>
				</tr>
			</c:forEach>
		</tbody>
	</Table>
</div>
<div id="duplicateDiv">
			<h2><spring:message code="@MODULE_ID@.mergePatient.duplicatePatient" /></h2>
			<h3><c:out value="${patientBName}" />(<c:out value="${patientBIdentifier[0].id}" />)</h3>
			<Table id="duplicateTable" name="duplicate">
				<thead>
					<tr>
						<th><input type="checkbox" id="selectAll" name="selectAll"></th>
						<th>Id</th>
						<th><spring:message code="@MODULE_ID@.mergePatient.dataType" /></th>
						<th><spring:message code="@MODULE_ID@.mergePatient.data" /></th>
						<th><spring:message code="@MODULE_ID@.mergePatient.dateCreated" /></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="identifier" items="${patientBIdentifier}"
						varStatus="loop">
						<tr>
							<td><input type="checkbox" class="it"
								name='id_<c:out value="${identifier.id}"  />'
								id='<c:out value="${identifier.id}"  />'></td>
							<td><c:out value="${identifier.id}" /></td>
							<td>Identifier</td>
							<td><c:out value="${identifier.name}" /></td>
							<td><c:out value="${identifier.date}" /></td>
						</tr>
					</c:forEach>
					<c:forEach var="encounter" items="${patientBEncounter}"
						varStatus="loop">
						<tr>
							<td><input type="checkbox" class="it"
								name='en_<c:out value="${encounter.id}"  />'
								value='<c:out value="${encounter.name}"  />'
								id='<c:out value="${encounter.id}"  />'></td>
							<td><c:out value="${encounter.id}" /></td>
							<td>Encounter</td>
							<td><a onclick="onEncounterClick(${encounter.id})"><c:out value="${encounter.name}" /></a></td>
							<td><c:out value="${encounter.date}" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</Table>
		</div>
</form>

<div id="dialog1" title="Select Program">
	<div id="programDiv1"></div>
  <button id="programSelect1">Done</button>
</div>
<div id="dialog2" title="Select Program">
	<div id="programDiv2"></div>
  <button id="programSelect2">Done</button>
</div>
<div id="dialog3" title="Select Program">
	<div id="programDiv3"></div>
  <button id="programSelect3">Done</button>
</div>
</body>
</html>

<%@ include file="/WEB-INF/template/footer.jsp"%>