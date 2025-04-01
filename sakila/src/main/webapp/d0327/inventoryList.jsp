<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	if(staffId == null) { // 로그인 상태 아니면
	    response.sendRedirect("/sakila/index.jsp");
	    return;
	}

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
	
	String sql1 = "SELECT t1.inventory_id, t1.title, t1.store_id, t2.isRental "
	            + "FROM (SELECT i.inventory_id, f.title, i.store_id "
	            + "FROM inventory i "
	            + "INNER JOIN film f ON i.film_id = f.film_id) t1 "
	            + "LEFT OUTER JOIN (SELECT inventory_id, rental_date, "
	            + "CASE WHEN return_date IS null THEN '불가' "
	            + "ELSE '가능' END AS isRental "
	            + "FROM rental WHERE (inventory_id, rental_date) IN ("
	            + "SELECT inventory_id, MAX(rental_date) "
	            + "FROM rental GROUP BY inventory_id)) t2 "
	            + "ON t1.inventory_id = t2.inventory_id";

	String sql2 = "SELECT count(*) as cnt "
	            + "FROM (SELECT i.inventory_id, f.title, i.store_id "
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
	System.out.println("totalCnt " + totalCnt);
	
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
		m.put("t1.store_id", rs1.getObject("t1.store_id"));
		list.add(m);
		
	    if(m.get("t2.isRental") == null){
	        m.put("t2.isRental", "가능");
	    }
	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>재고 목록</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        color: #333;
        margin: 0;
        padding: 20px;
    }

    h1 {
        text-align: center;
        color: #4CAF50;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    th, td {
        padding: 10px;
        text-align: center;
        border: 1px solid #ddd;
    }

    th {
        background-color: #4CAF50;
        color: white;
    }

    tr:nth-child(even) {
        background-color: #f2f2f2;
    }

    button {
        padding: 10px 20px;
        background-color: #4CAF50;
        color: white;
        border: none;
        cursor: pointer;
    }

    button:hover {
        background-color: #45a049;
    }

    form {
        text-align: center;
        margin-top: 20px;
    }

    input[type="text"] {
        padding: 5px;
        font-size: 16px;
    }

    .pagination {
        text-align: center;
        margin-top: 20px;
    }

    .pagination a {
        text-decoration: none;
        color: #4CAF50;
        margin: 0 10px;
        font-size: 16px;
    }

    .pagination a:hover {
        color: #45a049;
    }
</style>
</head>
<body>
	<h1>영화 재고 목록</h1>
	<table>
		<tr>
			<th>재고 번호</th>
			<th>영화 제목</th>
			<th>지점</th>
			<th>대여 유무</th>
			<th>대여하기</th>
		</tr>
	<%
		for(HashMap<String, Object> m : list) {
	%>
		<tr>
			<td><%=m.get("t1.inventory_id") %></td>
			<td><%=m.get("t1.title") %></td>
			<td><%=m.get("t1.store_id") %></td>
			<td><%=m.get("t2.isRental") %></td>
			<td>
				<% 
					if(m.get("t2.isRental") == null){
				%>
					<a href="/sakila/d0327/insertRentalForm.jsp?inventoryId=<%=m.get("t1.inventory_id") %>"><button type="button">대여하기</button></a>
				<%
					} else if(m.get("t2.isRental").equals("가능")) {
				%>
					<a href="/sakila/d0327/insertRentalForm.jsp?inventoryId=<%=m.get("t1.inventory_id") %>"><button type="button">대여하기</button></a>
				<%
					} else if(m.get("t2.isRental") != null || m.get("t2.isRental").equals("불가")) {
				%>							
					<button type="button" style="background-color:olive">반납하기</button>
				<%
					}
				%>	
			</td>
		</tr>
		<%
			}
		%>
	</table>

	<form action="/sakila/d0327/inventoryList.jsp">
		영화 검색 : <br>
		<input type="text" name="searchWord" value="<%=searchWord%>">
		<button type="submit">검색</button>
	</form>

	<div class="pagination">
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
		} System.out.println("lastPage" + lastPage);
	%>  
	</div>
</body>
</html>