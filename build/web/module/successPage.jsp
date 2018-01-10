<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>

<html>
<head>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/tajikistan/scripts/jquery/jquery.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/tajikistan/scripts/jquery/flot/jquery.flot.js"></script>
<style type="text/css">
td{
 padding-top: 10px;
 padding-top: 10px;
}
</style>
</head>
<body>
<h3><spring:message code="mergePatient.mergePatient.success" /></h3>
<span><c:out value=" ${en} "/> Encounter(s), 
<c:out value=" ${id} "/> Identifier(s) <spring:message code="mergePatient.mergePatient.and" /> <c:out value=" ${pr} "/> Program(s) <spring:message code="mergePatient.mergePatient.merged" /></span> 
<table>
<tbody>
<tr>
<td>Merged Patient:</td><td> <a href="/openmrs/patientDashboard.form?patientId=${pid}"><c:out value=" ${pname} "/> (<c:out value="${identifier}"/>)</a></td>
</tr>
<tr>
<td><spring:message code="mergePatient.mergePatient.PatientEncounter" /> (s): </td>
</tr>
<c:forEach var = "encounter" items="${encounters}">
	<tr>
		<td></td>
		<td> <a href="/openmrs/admin/encounters/encounter.form?encounterId=${encounter.id}">${encounter.encounterType.name} (${encounter.id})</a></td>
	</tr>
</c:forEach>
	
</tbody>
</table>
<a id='foot' href="/openmrs/module/mergePatient/search.form"><spring:message code="mergePatient.mergePatient.searchPage" /></a>
</body>
</html>

<%@ include file="/WEB-INF/template/footer.jsp"%>