<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 로그인 된 상태인지 아닌지 확인
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	if(staffId != null) { // 로그인 상태면
		response.sendRedirect("/sakila/index.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>Staff Login</h1>
	<form action="/sakila/loginAction.jsp">
		<table border="1">
			<tr>
				<th>Staff ID</th>
				<th><input type="number" name="staffId"></th>
			</tr>
			<tr>
				<th>password</th>
				<th><input type="password" name="password"></th>
			</tr>
		</table>
		<button type="submit">로그인</button>	
	</form>
</body>
</html>