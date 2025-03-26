<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	String searchWord = request.getParameter("searchWord");
	System.out.println("searchWord : "+ searchWord);
	
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
   
	
	String sql1 = " SELECT DISTINCT"
				+ " f.title, f.film_id"
				+ " FROM film f" 
				+ " INNER JOIN film_actor fa ON f.film_id = fa.film_id"
				+ " INNER JOIN actor a ON fa.actor_id = a.actor_id";
	String sql2 = " SELECT count(*) as cnt from film f"
				+ " INNER JOIN film_actor fa ON f.film_id = fa.film_id"
				+ " INNER JOIN actor a ON fa.actor_id = a.actor_id"
				+ " WHERE 1=1";
	
	
	if (!searchWord.isEmpty()){
		sql1 += " and f.title like ?";
		sql2 += " and f.title like ?";
	}
	
	
	sql1 += " order by f.title asc limit ?, ?";
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
		m.put("f.title", rs1.getObject("f.title"));
		m.put("f.film_id", rs1.getObject("f.film_id"));
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
	<h1>Film List</h1>
	<table border="1">
		<tr>
			<th>영화 목록</th>		
		</tr>
	<%
		for(HashMap<String, Object> m : list) {
	%>
		<tr>
			<td>
				<a href="/sakila/d0326/filmOne.jsp?filmId=<%=m.get("f.film_id")%>">
					<%=m.get("f.title")%>
				</a>
			</td>
		</tr>
	<%
		}
	%>			
	</table>   
		<form action="/sakila/d0326/filmList.jsp">
			영화 검색 : <br>
			<input type="text" name="searchWord" value="<%=searchWord%>">
			<button type="submit">검색</button>
		</form>
	<%
		if(currentPage > 1 ) {
	%>
		<a href="/sakila/d0326/filmList.jsp?currentPage=1&searchWord=<%=searchWord%>">처음</a>
	<%
		}
	%>
		<a href="/sakila/d0326/filmList.jsp?currentPage=<%=currentPage-1%>&searchWord=<%=searchWord%>">이전</a>   
		<%=currentPage%>
		<a href="/sakila/d0326/filmList.jsp?currentPage=<%=currentPage+1%>&searchWord=<%=searchWord%>">다음</a>   
	<%
		if(currentPage < lastPage) {
	%>
		<a href="/sakila/d0326/filmList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>">마지막</a>   
	<%
		}
	%>  
</body>
</html>