<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	String actorId = request.getParameter("actorId");
	System.out.println("actorId : " + actorId);

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
				+ " WHERE fa.actor_id = ?"			
				+ " LIMIT ?, ?";
	String sql2 = " SELECT count(*) as cnt from film f"
				+ " INNER JOIN film_actor fa ON f.film_id = fa.film_id"
				+ " INNER JOIN actor a ON fa.actor_id = a.actor_id"
				+ " WHERE fa.actor_id = ?";
	
	
	stmt1 = conn.prepareStatement(sql1);
	stmt2 = conn.prepareStatement(sql2);
	
    stmt1.setString(1, actorId);
    stmt1.setInt(2, startRow);
    stmt1.setInt(3, rowPerPage);

    stmt2.setString(1, actorId);
    
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
	<h1>출연 배우</h1>
		<table border="1">
			<tr>
				<th>배우 이름</th>
				<th>참여 영화</th>
			</tr>
		<%
			for(HashMap<String, Object> m : list) {
		%>
			<tr>
				<td><%=m.get("actor_name")%></td>			
				<td>
					<a href="/sakila/d0326/filmOne.jsp"><%=m.get("f.title")%></a>
				</td>			
			</tr>
		<%
			}
		%>			
		</table>
		<%
		if(currentPage > 1 ) {
		%>
			<a href="/sakila/d0326/actorOne.jsp?currentPage=1&actorId=<%=actorId%>">처음</a>
		<%
			}
		%>
			<a href="/sakila/d0326/actorOne.jsp?currentPage=<%=currentPage-1%>&actorId=<%=actorId%>">이전</a>   
			<%=currentPage%>
			<a href="/sakila/d0326/actorOne.jsp?currentPage=<%=currentPage+1%>&actorId=<%=actorId%>">다음</a>   
		<%
			if(currentPage < lastPage) {
		%>
			<a href="/sakila/d0326/actorOne.jsp?currentPage=<%=lastPage%>&actorId=<%=actorId%>">마지막</a>   
		<%
			}
		%> 
</body>
</html>