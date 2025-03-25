<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
   String storeId = request.getParameter("storeId");
   String searchWord = request.getParameter("searchWord");
   System.out.println("storeId : " + storeId);
   System.out.println("searchWord1 : " + searchWord);
   
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
   int startRow = (currentPage-1) * rowPerPage;
   
   Class.forName("com.mysql.cj.jdbc.Driver");
   System.out.println("드라이버 로딩 성공!");
   
   Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
   System.out.println(conn);
   
   PreparedStatement stmt1 = null;
   PreparedStatement stmt2 = null;
   
   String sql1 = "SELECT"
                + " f.title title, i.inventory_id inventoryId, r.rental_id rentalId"
                + " , r.rental_date rentalDate, r.return_date returnDate, c.first_name firstName"
                + " , c.last_name lastName, c.customer_id customerId, s.store_id storeId"
                + " FROM film f "  // 공백 추가
                + " INNER JOIN inventory i ON f.film_id = i.film_id"
                + " INNER JOIN rental r ON i.inventory_id = r.inventory_id"
                + " INNER JOIN customer c ON r.customer_id = c.customer_id"
                + " INNER JOIN store s ON i.store_id = s.store_id"
                + " WHERE 1=1"; // 기본 조건 추가

   String sql2 = "SELECT count(*) as cnt FROM film f "
                + " INNER JOIN inventory i ON f.film_id = i.film_id"
                + " INNER JOIN rental r ON i.inventory_id = r.inventory_id"
                + " INNER JOIN customer c ON r.customer_id = c.customer_id"
                + " INNER JOIN store s ON i.store_id = s.store_id"
                + " WHERE 1=1"; // 기본 조건 추가

   // storeId가 선택되었을 경우 추가
   if (!storeId.equals("0")) {
       sql1 += " AND s.store_id = ?";
       sql2 += " AND s.store_id = ?";
   }

   // searchWord가 있을 경우 추가
   if (!searchWord.isEmpty()) {
       sql1 += " AND f.title LIKE ?";
       sql2 += " AND f.title LIKE ?";
   }

   sql1 += " ORDER BY r.rental_date ASC LIMIT ?, ?";

   stmt1 = conn.prepareStatement(sql1);
   stmt2 = conn.prepareStatement(sql2);

   int paramIndex = 1;
   
   // storeId 조건이 있을 경우 바인딩
   if (!storeId.equals("0")) {
       stmt1.setString(paramIndex, storeId);
       stmt2.setString(paramIndex, storeId);
       paramIndex++;
   }

   // searchWord 조건이 있을 경우 바인딩
   if (!searchWord.isEmpty()) {
       stmt1.setString(paramIndex, "%" + searchWord + "%");
       stmt2.setString(paramIndex, "%" + searchWord + "%");
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
<title>Rental List</title>
</head>
<body>
   <h1>Rental List</h1>
   <form action="/sakila/d0325/rentalList.jsp">
      Store :
      <select name="storeId">
         <option value="0">전체</option>
         <option value="1" <%= storeId.equals("1") ? "selected" : "" %>>1지점</option>
         <option value="2" <%= storeId.equals("2") ? "selected" : "" %>>2지점</option>
      </select>
      <button type="submit">검색</button>   
   </form>
   
   <table border="1">
      <tr>
         <th>rental Id</th>
         <th>film Title</th>
         <th>inventory Id</th>
         <th>name(customer Id)</th>
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
         <td><%=m.get("firstName")%> <%=m.get("lastName")%> (<%=m.get("customerId")%>)</td>
         <td><%=m.get("rentalDate")%></td>
         <td><%=m.get("returnDate")%></td>
      </tr>      
      <%
         }
      %>            
   </table>
   <form action="/sakila/d0325/rentalList.jsp">
      filmTitle SearchWord : 
      <input type="text" name="searchWord" value="<%=searchWord%>">
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