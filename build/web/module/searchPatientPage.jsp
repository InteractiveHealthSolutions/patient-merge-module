<%@ include file="/WEB-INF/template/include.jsp"%>

<%@ include file="/WEB-INF/template/header.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>

<head>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/tajikistan/scripts/jquery/jquery.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/moduleResources/tajikistan/scripts/jquery/flot/jquery.flot.js"></script>
<meta http-equiv=“Content-Type” content=“text/html; charset=utf-8” />
</head>
<body>
<form method="post">
<Table>
<tr>
<td><spring:message code="mergePatient.mergePatient.patientName" />: </td>
<td><input name="patientName" id="patientName" type="text" placeholder="Name of Patient" Required></td>
</tr>
<tr>
<td><spring:message code="mergePatient.mergePatient.patientDOB" />: </td>
<td><input name="DOB" id="DOB" type="Date"></td>
</tr>
<tr>
<td><spring:message code="mergePatient.mergePatient.patientGender" />: </td>
<td>
	<select id="gender" name="gender">
  <option value=""></option>
  <option value="M"><spring:message code="mergePatient.mergePatient.male" /></option>
  <option value="F"><spring:message code="mergePatient.mergePatient.female" /></option>
	</select>
</td>
</tr>
<tr>
<td></td>
<td></td>
<td><input id="submit" type="submit" value='<spring:message code="mergePatient.mergePatient.searchBtn" />'></td>
</tr>
</Table>
</form> 
</body>
</html>

<%@ include file="/WEB-INF/template/footer.jsp"%>