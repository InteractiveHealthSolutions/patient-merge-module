<%@ include file="/WEB-INF/template/include.jsp"%>

<%@ include file="/WEB-INF/template/header.jsp"%>

<html>
<head>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/tajikistan/scripts/jquery/jquery.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/tajikistan/scripts/jquery/flot/jquery.flot.js"></script>

  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <link rel="stylesheet" href="https://cdn.datatables.net/1.10.15/css/jquery.dataTables.min.css">
  <script src="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>
<script type="text/javascript">


$(document).ready(function(){
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
			      // Check/uncheck all checkboxes in the table
			      var rows = table.rows({ 'search': 'applied' }).nodes();
			      $('input[type="checkbox"]', rows).prop('checked', this.checked);
			   });

			   // Handle click on checkbox to set state of "Select all" control
			   $('#duplicateTable tbody').on('change', 'input[type="checkbox"]', function(){
			      // If checkbox is not checked
			      if(!this.checked){
			         var el = $('#selectAll').get(0);
			         // If "Select all" control is checked and has 'indeterminate' property
			         if(el && el.checked && ('indeterminate' in el)){
			            // Set visual state of "Select all" control 
			            // as 'indeterminate'
			            el.indeterminate = true;
			         }
			      }
			   });
			   $('#swap').click(function(){
				 	window.location.replace("/openmrs/module/mergePatient/action.form?patientA="+${patientBId}+"&patientB="+${patientAId});
			   });
});	
</script>

<style type="text/css">

#primaryDiv, #duplicateDiv {
   float: left;
   width: 40%; 
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
</style>

</head>
<body>
<form action="" method="post" name="duplication" id="duplication">
<div id="btnDiv" name="btnDiv" style="float: right; margin-left: 5px;"><input type="submit" value='<spring:message code="@MODULE_ID@.mergePatient.mergeBtn" />'></div>
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
			</tr>
		</thead>
		<tbody>
			<c:forEach var="identifier" items="${patientAIdentifier}" varStatus="loop">
				<tr>
					<td><c:out value="${identifier.id}" /></td>
					<td>Identifier</td>
					<td><c:out value="${identifier.name}" /></td>
				</tr>
			</c:forEach>
			<c:forEach var="encounter" items="${patientAEncounter}" varStatus="loop">
				<tr>
					<td><c:out value="${encounter.id}" /></td>
					<td>Encounter</td>
					<td><a href='/openmrs/admin/encounters/encounter.form?encounterId=<c:out value="${encounter.id}"/>'><c:out value="${encounter.name}" /></a></td>
				</tr>
			</c:forEach>
			<c:forEach var="program" items="${patientAProgram}" varStatus="loop">
				<tr>
					<td><c:out value="${program.id}" /></td>
					<td>Program</td>			
					<td><c:out value="${program.name}" /></td>
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
						</tr>
					</c:forEach>
					<c:forEach var="program" items="${patientBProgram}"
						varStatus="loop">
						<tr>
							<td><input type="checkbox"
								name='pg_<c:out value="${program.id}"  />'
								value='<c:out value="${program.id}"  />'
								id='<c:out value="${program.id}"  />'></td>
							<td><c:out value="${program.id}" /></td>
							<td>Program</td>
							<td><c:out value="${program.name}" /></td>
						</tr>
					</c:forEach>
				</tbody>
			</Table>
		</div>
</form>
</body>
</html>

<%@ include file="/WEB-INF/template/footer.jsp"%>