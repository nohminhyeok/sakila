<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	if(staffId == null) { // 로그인 상태가 아니면
		response.sendRedirect("/sakila/loginForm.jsp");
		return;
	}
	
	String filmId = request.getParameter("filmId");
	System.out.println("filmId : "+ filmId);

	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
	   currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int startRow = (currentPage-1) * rowPerPage;
	
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println(conn);
	
	
	PreparedStatement stmt1 = null;
	PreparedStatement stmt2 = null;
	
	
	String sql1 = " SELECT"
				+ " f.title, f.film_id, fa.actor_id, concat(a.first_name,' ',a.last_name) as actor_name "
				+ " FROM film f" 
				+ " INNER JOIN film_actor fa ON f.film_id = fa.film_id"
				+ " INNER JOIN actor a ON fa.actor_id = a.actor_id"
				+ " where f.film_id = ?"
				+ " limit ?, ?";	
	String sql2 = " SELECT count(*) as cnt from film f"
				+ " INNER JOIN film_actor fa ON f.film_id = fa.film_id"
				+ " INNER JOIN actor a ON fa.actor_id = a.actor_id"
				+ " WHERE f.film_id = ?";

	
		
	stmt1 = conn.prepareStatement(sql1);
	stmt2 = conn.prepareStatement(sql2);
	
	stmt1.setString(1, filmId);
	stmt1.setInt(2, startRow);
	stmt1.setInt(3, rowPerPage);
	stmt2.setString(1, filmId);
		
	ResultSet rs1 = stmt1.executeQuery();
	ResultSet rs2 = stmt2.executeQuery();
	
	rs2.next();
	int totalCnt = rs2.getInt("cnt");
	
	int lastPage = totalCnt / rowPerPage;
	if(totalCnt % rowPerPage != 0) {
	   lastPage = lastPage + 1;
	}
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs1.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("f.title", rs1.getObject("f.title"));
		m.put("actor_name", rs1.getObject("actor_name"));
		m.put("fa.actor_id", rs1.getObject("fa.actor_id"));
		list.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>영화 출연진</h1>
	<table border="1">
		<tr>
			<th>영화 이름</th>
			<th>출연 배우</th>
		</tr>	
	<%
		for(HashMap<String, Object> m : list) {
	%>	
		<tr>
			<td><%=m.get("f.title")%></td>
			<td>
				<a href="/sakila/d0326/actorOne.jsp?actorId=<%=m.get("fa.actor_id")%>">
					<%=m.get("actor_name")%>
				</a>
			</td>
		</tr>
	<%
		}
	%>
	</table>
	<%
		if(currentPage > 1 ) {
	%>
		<a href="/sakila/d0326/filmOne.jsp?currentPage=1&filmId=<%=filmId%>">처음</a>
	<%
		}
	%>
		<a href="/sakila/d0326/filmOne.jsp?currentPage=<%=currentPage-1%>&filmId=<%=filmId%>">이전</a>   
		<%=currentPage%>
		<a href="/sakila/d0326/filmOne.jsp?currentPage=<%=currentPage+1%>&filmId=<%=filmId%>">다음</a>   
	<%
		if(currentPage < lastPage) {
	%>
		<a href="/sakila/d0326/filmOne.jsp?currentPage=<%=lastPage%>&filmId=<%=filmId%>">마지막</a>   
	<%
		}
	%> 
</body>
</html>