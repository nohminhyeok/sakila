<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	String searchWord = request.getParameter("searchWord");
	
	if (searchWord == null) {
  		searchWord = "";
	}

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
	
	String sql1 = " SELECT "
				+ " a.actor_id, concat(a.first_name,' ',a.last_name) as actor_name"
				+ " FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id "
			    + " GROUP BY a.actor_id, a.first_name, a.last_name ";
	String sql2 = " SELECT count(distinct a.actor_id) as cnt from actor a "
	            + " INNER JOIN film_actor fa ON a.actor_id = fa.actor_id ";
	
	if (!searchWord.isEmpty()){
		sql1 += " and concat(a.first_name,' ',a.last_name) like ?";
		sql2 += " and concat(a.first_name,' ',a.last_name) like ?";
	}
	
	sql1 += " order by a.actor_id asc limit ?, ?";
	stmt1 = conn.prepareStatement(sql1);
	stmt2 = conn.prepareStatement(sql2);

	int paramIndex = 1;
	
	if(!searchWord.isEmpty()){
		stmt1.setObject(paramIndex, "%" + searchWord + "%");
		stmt2.setObject(paramIndex, "%" + searchWord + "%");
		paramIndex++;
	}

	stmt1.setInt(paramIndex, startRow);
	stmt1.setInt(paramIndex + 1, rowPerPage);
	
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
		m.put("a.actor_id", rs1.getObject("a.actor_id"));
		m.put("actor_name", rs1.getObject("actor_name"));
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
	<h1>배우 상세정보</h1>
		<table border="1">
			<tr>
				<th>배우 번호</th>
				<th>배우 이름</th>
			</tr>
		<%
			for(HashMap<String, Object> m : list) {
		%>
			<tr>
				<td><%=m.get("a.actor_id") %></td>
				<td><%=m.get("actor_name") %></td>
			</tr>
		<%
			}		
		%>
		</table>
		<form action="/sakila/d0326/filmList.jsp">
			배우 검색 : <br>
			<input type="text" name="searchWord" value="<%=searchWord%>">
			<button type="submit">검색</button>
		</form>
			<%
		if(currentPage > 1 ) {
	%>
		<a href="/sakila/d0326/actorList.jsp?currentPage=1">처음</a>
	<%
		}
	%>
		<a href="/sakila/d0326/actorList.jsp?currentPage=<%=currentPage-1%>">이전</a>   
		<%=currentPage%>
		<a href="/sakila/d0326/actorList.jsp?currentPage=<%=currentPage+1%>">다음</a>   
	<%
		if(currentPage < lastPage) {
	%>
		<a href="/sakila/d0326/actorList.jsp?currentPage=<%=lastPage%>">마지막</a>   
	<%
		}
	%> 
</body>
</html>