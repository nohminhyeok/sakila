<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>사용자 변경</h1>
	<form action="/sakila/updatePasswordAction.jsp">
		<table border="1">
			<tr>
				<th>기존 아이디</th>
				<th><input type="text" name="preId"></th>
			</tr>
			<tr>
				<th>기존 비밀번호</th>
				<th><input type="password" name="prePw"></th>
			</tr>
			<tr>
				<th>변경할 아이디</th>
				<th><input type="text" name="newId"></th>
			</tr>
			<tr>
				<th>변경할 비밀번호</th>
				<th><input type="password" name="newPw"></th>
			</tr>
		</table>
		<button type="submit">변경하기</button>
	</form>
</body>
</html>