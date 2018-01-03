<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="/WEB-INF/template/header.jsp"%>

<html>
<head>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/tajikistan/scripts/jquery/jquery.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/tajikistan/scripts/jquery/flot/jquery.flot.js"></script>
</head>
<body>
<h3><spring:message code="mergePatient.mergePatient.success" /></h3>
<span><c:out value=" ${en} "/> Encounter(s), 
<c:out value=" ${id} "/> Identifier(s) <spring:message code="mergePatient.mergePatient.and" /> <c:out value=" ${pr} "/> Program(s) <spring:message code="mergePatient.mergePatient.merged" /></span> 
<table>
<tbody>
<tr>
<td><a href=""></a></td>
<td><a href="/openmrs/module/mergePatient/search.form"><spring:message code="mergePatient.mergePatient.searchPage" /></a></td>
</tr>
</tbody>
</table>
</body>
</html>

<%@ include file="/WEB-INF/template/footer.jsp"%>