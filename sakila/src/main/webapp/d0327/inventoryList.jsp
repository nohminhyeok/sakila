<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	String searchWord = request.getParameter("searchWord");
	System.out.println("searchWord : " + searchWord);
	
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
	
    String sql1 = "SELECT t1.inventory_id, t1.title, t2.isRental "
				+ "FROM (SELECT i.inventory_id, f.title "
				+ "FROM inventory i "
				+ "INNER JOIN film f ON i.film_id = f.film_id) t1 "
				+ "LEFT OUTER JOIN (SELECT inventory_id, rental_date, "
				+ "CASE WHEN return_date IS NULL THEN '불가' "
				+ "ELSE '가능' END AS isRental "
				+ "FROM rental WHERE (inventory_id, rental_date) IN ("
				+ "SELECT inventory_id, MAX(rental_date) "
				+ "FROM rental GROUP BY inventory_id)) t2 "
				+ "ON t1.inventory_id = t2.inventory_id";

	String sql2 = "SELECT count(distinct t1.title) as cnt "
	            + "FROM (SELECT i.inventory_id, f.title "
	            + "FROM inventory i "
	            + "INNER JOIN film f ON i.film_id = f.film_id) t1 "
	            + "LEFT OUTER JOIN (SELECT inventory_id, rental_date, "
	            + "CASE WHEN return_date IS NULL THEN '불가' "
	            + "ELSE '가능' END AS isRental "
	            + "FROM rental WHERE (inventory_id, rental_date) IN ("
	            + "SELECT inventory_id, MAX(rental_date) "
	            + "FROM rental GROUP BY inventory_id)) t2 "
	            + "ON t1.inventory_id = t2.inventory_id";

	if (!searchWord.isEmpty()) {
		sql1 += " WHERE t1.title LIKE ?";
		sql2 += " AND t1.title LIKE ?";
	}

	sql1 += " ORDER BY t1.inventory_id ASC LIMIT ?, ?";
	
	stmt1 = conn.prepareStatement(sql1);
	stmt2 = conn.prepareStatement(sql2);
	
	int paramIndex = 1;
	
	if(!searchWord.isEmpty()){
		stmt1.setObject(paramIndex, "%"+searchWord+"%");
		stmt2.setObject(paramIndex, "%"+searchWord+"%");
		paramIndex++;
	}
	
	stmt1.setObject(paramIndex, startRow);
	stmt1.setObject(paramIndex+1, rowPerPage);

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
		m.put("t1.inventory_id", rs1.getObject("t1.inventory_id"));
		m.put("t1.title", rs1.getObject("t1.title"));
		m.put("t2.isRental", rs1.getObject("t2.isRental"));
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
	<h1>Inventory List</h1>
	<table border="1">
		<tr>
			<th>Inventory_id</th>
			<th>제목</th>
			<th>대여 유무</th>
			<th>대여하기</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list) {
		%>
			<tr>
				<td><%=m.get("t1.inventory_id")%></td>
				<td><%=m.get("t1.title")%></td>
				<td><%=m.get("t2.isRental")%></td>
				<td>
					<% 
						if(m.get("t2.isRental") == null || m.get("t2.isRental").equals("불가")){
					%>
						
					<%
						} else {
							
					%>	
					<button type="submit">대여하기</button></td>
					<%
						}
					%>							
			</tr>
		<%
			}
		%>				
	</table>
	<form action="/sakila/d0327/inventoryList.jsp">
		<input type="text" name="searchWord" value="<%=searchWord%>">
		<button type="submit">영화검색</button>
	</form>
	<%
		if(currentPage > 1 ) {
	%>
		<a href="/sakila/d0327/inventoryList.jsp?currentPage=1&searchWord=<%=searchWord%>">처음</a>
	<%
		}
	%>
		<a href="/sakila/d0327/inventoryList.jsp?currentPage=<%=currentPage-1%>&searchWord=<%=searchWord%>">이전</a>   
		<%=currentPage%>
		<a href="/sakila/d0327/inventoryList.jsp?currentPage=<%=currentPage+1%>&searchWord=<%=searchWord%>">다음</a>   
	<%
		if(currentPage < lastPage) {
	%>
		<a href="/sakila/d0327/inventoryList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>">마지막</a>   
	<%
		}
	%> 
</body>
</html>