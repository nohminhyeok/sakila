<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	if(staffId == null) { // 로그인 상태가 아니면
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}

	int preId = Integer.parseInt(request.getParameter("preId"));
	int newId = Integer.parseInt(request.getParameter("newId"));
	String prePw = request.getParameter("prePw");
	String newPw = request.getParameter("newPw");
	
	Connection conn = null;
	PreparedStatement stmt1 = null;

	String sql1 =" UPDATE staff"
				+" SET staff_id = ? , PASSWORD = ?"	
				+" WHERE staff_id = ? AND PASSWORD = ?";

	
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setInt(1, newId);
	stmt1.setString(2, newPw);
	stmt1.setInt(3, preId);
	stmt1.setString(4, prePw);
	
	// SQL 실행 (업데이트된 행 수 반환)
	int rowsUpdated = stmt1.executeUpdate(); 

	// 업데이트된 행이 있으면 비밀번호 변경 성공
	if (rowsUpdated > 0) {
		session.invalidate();
		out.println("<h1>비밀번호 변경에 성공했습니다. 다시 로그인 해주세요.</h1>");
		out.println("<h2>잠시후 로그인 페이지로 넘어갑니다.</h2>");
		
		// 일정 시간 후에 로그인 페이지로 리디렉션
		out.println("<script>");
		out.println("setTimeout(function() { window.location.href = '/sakila/loginForm.jsp'; }, 6000);");
		out.println("</script>");
%>
		<a href="/sakila/loginForm.jsp"><button type="submit">로그인 페이지 바로가기</button></a>
<%
	} else {
		out.println("비밀번호 변경에 실패했습니다. 기존 비밀번호를 확인해주세요.");
%>
	<button type="submit"><a href="/sakila/updatePasswordFrom.jsp">돌아가기</a></button>
<%
	}
%>		
