<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	String storeId = request.getParameter("storeId");
	String searchWord = request.getParameter("searchWord");
	System.out.println("storeId : " + storeId);
	System.out.println("searchWord : " + searchWord);
	
    if (storeId == null) {
        storeId = "0";
    }
    
    if (searchWord == null) {
        searchWord = "";
    }
    
    
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	int startRow = (currentPage-1)*rowPerPage;
	
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println(conn);
	
	PreparedStatement stmt1 = null;
	PreparedStatement stmt2 = null; 
	
	
    if(storeId.equals("0") && searchWord.isEmpty()){
		String sql1 = "SELECT"
	    			+ " f.title title, i.inventory_id inventoryId, r.rental_id rentalId"
	    			+ " , r.rental_date rentalDate, r.return_date returnDate, c.first_name firstName"
	    			+ " , c.last_name lastName, c.customer_id customerId, s.store_id storeId"					
	    			+ " FROM film f "
					+ " INNER JOIN inventory i ON f.film_id = i.film_id"
					+ " INNER JOIN rental r ON i.inventory_id = r.inventory_id"
					+ " INNER JOIN customer c ON r.customer_id = c.customer_id"
					+ " INNER JOIN store s ON i.store_id = s.store_id"
					+ " order by r.rental_date asc"
					+ " limit ?, ?";
		
    	String sql2 = "SELECT count(*) as cnt from film f"
	   				+ " INNER JOIN inventory i ON f.film_id = i.film_id"
	   				+ " INNER JOIN rental r ON i.inventory_id = r.inventory_id"
	   				+ " INNER JOIN customer c ON r.customer_id = c.customer_id"
	   				+ " INNER JOIN store s ON i.store_id = s.store_id";
		
	    stmt1 = conn.prepareStatement(sql1);
	    stmt2 = conn.prepareStatement(sql2);
		stmt1.setObject(1, startRow);
		stmt1.setObject(2, rowPerPage);
	
    } else if(storeId.equals("0") || storeId.equals("1") || storeId.equals("2")){
    	String sql1 = "SELECT"
	    			+ " f.title title, i.inventory_id inventoryId, r.rental_id rentalId"
	    			+ " , r.rental_date rentalDate, r.return_date returnDate, c.first_name firstName"
	    			+ " , c.last_name lastName, c.customer_id customerId, s.store_id storeId"
	    	    	+ " FROM film f "
	    			+ " INNER JOIN inventory i ON f.film_id = i.film_id"
					+ " INNER JOIN rental r ON i.inventory_id = r.inventory_id"
					+ " INNER JOIN customer c ON r.customer_id = c.customer_id"
					+ " INNER JOIN store s ON i.store_id = s.store_id"
					+ " where s.store_id = ?"
					+ " order by r.rental_date asc"
					+ " limit ?, ?";
    	
    	String sql2 = "SELECT count(*) as cnt from film f"
   					+ " INNER JOIN inventory i ON f.film_id = i.film_id"
	   				+ " INNER JOIN rental r ON i.inventory_id = r.inventory_id"
	   				+ " INNER JOIN customer c ON r.customer_id = c.customer_id"
	   				+ " INNER JOIN store s ON i.store_id = s.store_id"
	    			+ " where s.store_id = ?";
		
	    stmt1 = conn.prepareStatement(sql1);
	    stmt2 = conn.prepareStatement(sql2);
	    
	    stmt1.setObject(1, storeId);
	    stmt1.setObject(2, startRow);
	    stmt1.setObject(3, rowPerPage);
	    
		stmt2.setObject(1, storeId);
   
    } else if(searchWord != "") {
    	String sql1 = "SELECT"
	    			+ "f.title title, i.inventory_id inventoryId, r.rental_id rentalId"
	    			+ ", r.rental_date rentalDate, r.return_date returnDate, c.first_name firstName"
	    			+ ", c.last_name lastName, c.customer_id customerId, s.store_id storeId"
					+ "FROM film f"
					+ "INNER JOIN inventory i ON f.film_id = i.film_id"
					+ "INNER JOIN rental r ON i.inventory_id = r.inventory_id"
					+ "INNER JOIN customer c ON r.customer_id = c.customer_id"
					+ "INNER JOIN store s ON i.store_id = s.store_id"
					+ "where f.title like ?"
					+ "order by r.rental_date asc"
					+ "limit ?, ?";
    	
    	String sql2 = "SELECT count(*) as cnt from film f"
	   				+ "INNER JOIN inventory i ON f.film_id = i.film_id"
	   				+ "INNER JOIN rental r ON i.inventory_id = r.inventory_id"
	   				+ "INNER JOIN customer c ON r.customer_id = c.customer_id"
	   				+ "INNER JOIN store s ON i.store_id = s.store_id"
	    			+ "where f.title like ?";
    	
   	    stmt1 = conn.prepareStatement(sql1);
   	    stmt2 = conn.prepareStatement(sql2);
   	    
   	    stmt1.setObject(1, "%"+searchWord+"%");
   	    System.out.println("searchWord : " + searchWord);
   		stmt1.setObject(2, startRow);
   		stmt1.setObject(3, rowPerPage);
   		
   	    stmt2.setObject(1, "%"+searchWord+"%");
    }
    
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
		m.put("rentalId", rs1.getObject("rentalId"));
		m.put("title", rs1.getObject("title"));
		m.put("inventoryId", rs1.getObject("inventoryId"));
		m.put("firstName", rs1.getObject("firstName"));
		m.put("lastName", rs1.getObject("lastName"));
		m.put("customerId", rs1.getObject("customerId"));
		m.put("rentalDate", rs1.getObject("rentalDate"));
		m.put("returnDate", rs1.getObject("returnDate"));
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
	<h1>Rental List</h1>
	<form action="/sakila/d0325/rentalList.jsp">
		Store :
		<select name="storeId">
			<option value="0">전체</option>
			<option value="1">1지점</option>
			<option value="2">2지점</option>
		</select>
		<button type="submit">검색</button>	
	</form>
	
	<table border="1">
		<tr>
			<th>rental Id</th>
			<th>film Title</th>
			<th>inventory Id</th>
			<th>name(customer Id)</th> <!--  name = first_name + last_name -->
			<th>rental Date</th>
			<th>return Date</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list) {
		%>
		<tr>
			<td><%=m.get("rentalId")%></td>
			<td><%=m.get("title")%></td>
			<td><%=m.get("inventoryId")%></td>
			<td><%=m.get("firstName")%>
				<%=m.get("lastName")%>
				(<%=m.get("customerId")%>)
			</td>
			<td><%=m.get("rentalDate")%></td>
			<td><%=m.get("returnDate")%></td>
		</tr>		
		<%
			}
		%>				
	</table>
	<form action="/sakila/d0325/rentalList.jsp">
		filmTitle Search Word : 
		<input type="text" name="searchWord">
		<button type="submit">검색</button>
	</form>
	<%
		if(currentPage > 1) {
	%>
		<a href="/sakila/d0325/rentalList.jsp?currentPage=1&searchWord=<%=searchWord%>&storeId=<%=storeId%>">처음</a>	
	<%
		}
	%>			
		<a href="/sakila/d0325/rentalList.jsp?currentPage=<%=currentPage-1%>&searchWord=<%=searchWord%>&storeId=<%=storeId%>">이전</a>	
		<%=currentPage%>
		<a href="/sakila/d0325/rentalList.jsp?currentPage=<%=currentPage+1%>&searchWord=<%=searchWord%>&storeId=<%=storeId%>">다음</a>	
	<%
		if(currentPage < lastPage) {
	%>
		<a href="/sakila/d0325/rentalList.jsp?currentPage=<%=lastPage%>&searchWord=<%=searchWord%>&storeId=<%=storeId%>">마지막</a>	
	<%
		}
	%>			
</body>
</html>