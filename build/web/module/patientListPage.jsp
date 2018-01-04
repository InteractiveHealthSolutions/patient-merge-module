<%@ include file="/WEB-INF/template/include.jsp"%>

<%@ include file="/WEB-INF/template/header.jsp"%>

<html>
<head>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/tajikistan/scripts/jquery/jquery.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/tajikistan/scripts/jquery/flot/jquery.flot.js"></script>
<meta http-equiv=“Content-Type” content=“text/html; charset=utf-8” />
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <link rel="stylesheet" href="https://cdn.datatables.net/1.10.15/css/jquery.dataTables.min.css">
  <script src="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>
<script type="text/javascript">


$(document).ready(function(){
			$('#main').DataTable({
				"language": {
					 	"search": "_INPUT_",
					 	"searchPlaceholder": "Search..."
					 		},
				"paging" : true,
 				"lengthChange" : false,
 				"searching" : true,
 				"ordering" : true,
 				"info" : false,
 				"autoWidth" : true,
 				"sDom" : 'lfrtip',
			});
			
			$("#Searchform").submit( function() {
				if(jQuery("#primaryPatient").val() != jQuery("#duplicatePatient").val())
			        return true;
			    else
	        	 {
    	    	   	alert("<spring:message code="mergePatient.mergePatient.invalidateSelections" />");
	   		      	return false   	 
	        	 }
		     });
		//jugar	below
		var data="${patientList}";
		if(data.length<=2)
		{
			$("#dropDownTable").hide();
		}
	});
		
		
</script>

<style type="text/css">
 #main,  #main th,  #main td {
 border: 1px solid black;
 
 border-collapse: collapse;
}
</style>

</head>
<body>
	<form action="" method="post" id="Searchform">
		<Table id="dropDownTable">
			<tr>
				<td><spring:message
						code="mergePatient.mergePatient.primaryPatient" />:</td>
				<td><select name="primaryPatient" id="primaryPatient">
						<c:forEach var="patient" items="${patientList}" varStatus="loop">
							<option value='<c:out value="${patient.pid}" />'><c:out
									value="${patient.identifier}" /></option>
						</c:forEach>
				</select></td>
				<td>&nbsp</td>
				<td><spring:message code="mergePatient.mergePatient.duplicatePatient" />:</td>
				<td><select name="duplicatePatient" id="duplicatePatient">
						<c:forEach var="patient" items="${patientList}" varStatus="loop">
							<option value='<c:out value="${patient.pid}" />'><c:out
									value="${patient.identifier}" /></option>
						</c:forEach>
				</select></td>
				<td><input name="searchButton" id="searchPatient" type="submit"
					value='<spring:message code="mergePatient.mergePatient.searchBtn" />'></td>
			</tr>
		</Table>
	</form>
	<Table id="main" name="main">
		<thead>
			<tr>
				<th><spring:message code="mergePatient.mergePatient.patientIdentifier" /></th>
				<th><spring:message code="mergePatient.mergePatient.patientName" /></th>
				<th><spring:message code="mergePatient.mergePatient.patientDOB" /></th>
				<th><spring:message
						code="mergePatient.mergePatient.patientGender" /></th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="patient" items="${patientList}" varStatus="loop">
				<tr>
					<td><c:out value="${patient.identifier}" /></td>
					<td><c:out value="${patient.name}" /></td>
					<td><c:out value="${patient.DOB}" /></td>
					<td><c:out value="${patient.gender}" /></td>
				</tr>
			</c:forEach>
		</tbody>
	</Table>
</body>
</html>

<%@ include file="/WEB-INF/template/footer.jsp"%>