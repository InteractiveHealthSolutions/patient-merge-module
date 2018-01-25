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
		 var programA=${patientAProgramjson};
		 var allProgram=getAllPrograms();
		 $("#dialog").hide();
		 console.log(allProgram);
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
				 	window.location.replace("/openmrs/module/mergePatient/action.form?patientA="+${patientBId}+"&patientB="+${patientAId});
			   });
			   $( "#submitbtn" ).click(function( event ) {
				   if(confirm('<spring:message code="mergePatient.mergePatient.confirmSubmit" />')==true)
					{  
					   var selected = [];
					   var patientProgram=[]
					   $('#duplicateTable input[type=checkbox]').each(function() {
					       selected.push($(this).attr('name'));
					   });
					   var program=getPrograms(selected);
					   
					   if(programA.length==1 && program.length>0)
					   {	alert("Add Program for this patient first.")
					   }
					   else if(programA.length>1 && program.length>0)
					   {	
						   for(var i=0;i<program.length;i++)
						   {
							for(var j=0;j<programA.length-1;j++)
							{
							if(program[i]!=null)
							{ 
								if(program[i][0].name==programA[j].name)
								{
									if(program[i][0].found==undefined)
										program[i][0].found=[];
									program[i][0].found.push(programA[j].id);
								}
							}
						   }
						   }
					   		var bool=false,q=0;
						   for(q=0;q<allProgram.length;q++)
						   { 
							    bool=false; 
						   for(var i=0;i<program.length;i++)
						   { 
							   if(program[i]!=null)
								{
									if(program[i][0].found.length>1)
									{ 
										for(var j=0;j<programA.length-1;j++)
										{
											console.log(allProgram[q].name)
										 	 
										 if(program[i][0].name==programA[j].name && programA[j].name==allProgram[q].name)
										{	
											 bool=true;
											 break;
										} 
							   			else
								   			console.log(program[i]); 
						   				 }  
						   			}
						   		} 
							   if(bool==true)
								   break;
						   }
						   if(bool==true)
						   {
							console.log(bool +" "+ allProgram[q].name);
							$( "#dialog" ).dialog();
							$( "#programDiv select").remove();
							$( "#programDiv snap").remove();
							$( "#programDiv" ).append("<snap>"+allProgram[q].name+"</snap><select id='"+allProgram[q].id+"'></select>");
							for(var i=0;i<programA.length-1;i++)
							{
								if(allProgram[q].name==programA[i].name)
								{	
									$( "#"+allProgram[q].id ).append("<option value='"+programA[i].id+"' id='"+programA[i].id+"'>"+programA[i].name+"-"+formatDate(programA[i].date)+"</option>");
								}
							}
						  }
						}
						  if(q==allProgram.length && bool==false) 
						  document.getElementById("duplication").submit();
					   }
					   else if(program.length==0)
					   {
							alert("here we are 2")
							document.getElementById("duplication").submit();
					   }
					}
				   //$("#duplication").submit();
				 });
			   $("#programSelect").click(function(){
				   for(var q=0;q<allProgram.length;q++)
				   { 
				   var input = $("<input>").attr("type", "hidden").attr("name", allProgram[q].id).val($("#"+allProgram[q].id).val());
					$('#duplication').append($(input)); 
				   }document.getElementById("duplication").submit();
			   });
			   
});	

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
<div id="btnDiv" name="btnDiv" style="float: right; margin-left: 5px;"><input type="button" id="submitbtn" value='<spring:message code="mergePatient.mergePatient.mergeBtn" />'></div>
<div id="swapDiv" name="swapDiv" style="float: right;  margin-left: 5px;"><input type="button" value='<spring:message code="mergePatient.mergePatient.swapBtn" />' id="swap"></div>
<div id="primaryDiv">
	<h2><spring:message code="mergePatient.mergePatient.primaryPatient" /></h2>
	<h3><c:out value="${patientAName}" />(<c:out value="${patientAIdentifier[0].id}" />)</h3>
	<Table id="primaryTable" name="primary">
		<thead>
			<tr>
				<th>Id</th>
				<th><spring:message code="mergePatient.mergePatient.dataType" /></th>
				<th><spring:message code="mergePatient.mergePatient.data" /></th>
				<th><spring:message code="mergePatient.mergePatient.dateCreated" /></th>
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
					<td><a href='/openmrs/admin/encounters/encounter.form?encounterId=<c:out value="${encounter.id}"/>'><c:out value="${encounter.name}" /></a></td>
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
			<h2><spring:message code="mergePatient.mergePatient.duplicatePatient" /></h2>
			<h3><c:out value="${patientBName}" />(<c:out value="${patientBIdentifier[0].id}" />)</h3>
			<Table id="duplicateTable" name="duplicate">
				<thead>
					<tr>
						<th><input type="checkbox" id="selectAll" name="selectAll"></th>
						<th>Id</th>
						<th><spring:message code="mergePatient.mergePatient.dataType" /></th>
						<th><spring:message code="mergePatient.mergePatient.data" /></th>
						<th><spring:message code="mergePatient.mergePatient.dateCreated" /></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="identifier" items="${patientBIdentifier}"
						varStatus="loop">
						<tr>
							<td><input type="checkbox"
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
							<td><input type="checkbox"
								name='en_<c:out value="${encounter.id}"  />'
								value='<c:out value="${encounter.id}"  />'
								id='<c:out value="${encounter.id}"  />'></td>
							<td><c:out value="${encounter.id}" /></td>
							<td>Encounter</td>
							<td><a href='/openmrs/admin/encounters/encounter.form?encounterId=<c:out value="${encounter.id}"/>'>
								<c:out value="${encounter.name}" /></a></td>
								<td><c:out value="${encounter.date}" /></td>
						</tr>
					</c:forEach>
					<%-- <c:forEach var="program" items="${patientBProgram}"
						varStatus="loop">
						<tr>
							<td><input type="checkbox"
								name='pg_<c:out value="${program.id}"  />'
								value='<c:out value="${program.id}"  />'
								id='<c:out value="${program.id}"  />'></td>
							<td><c:out value="${program.id}" /></td>
							<td>Program</td>
							<td><c:out value="${program.name}" /></td>
							<td><c:out value="${program.date}" /></td>
						</tr>
					</c:forEach> --%>
				</tbody>
			</Table>
		</div>
</form>
<div id="dialog" title="Select Program">
	<div id="programDiv"></div>
  <button id="programSelect">Done</button>
</div>
</body>
</html>

<%@ include file="/WEB-INF/template/footer.jsp"%>