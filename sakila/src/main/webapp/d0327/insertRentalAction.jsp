<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	if(staffId == null) { // 로그인 상태 아니면
	    response.sendRedirect("/sakila/index.jsp");
	    return;
	}
	
	int customerId = Integer.parseInt(request.getParameter("customerId"));
	int inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	int filmId = Integer.parseInt(request.getParameter("filmId"));
	int storeId = Integer.parseInt(request.getParameter("storeId"));
	
	Connection conn = null;
	PreparedStatement stmt = null;
    int rowsAffected = 0;
    
    
	String sql = " UPDATE rental r INNER JOIN inventory i ON r.inventory_id = i.inventory_id"
				+" SET r.customer_id = ?, r.inventory_id = ?, r.staff_id = ?"
				+" , i.film_id = ?, i.store_id = ?"
				+" WHERE r.inventory_id = ? ";
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	stmt = conn.prepareStatement(sql);
    stmt.setObject(1, customerId);
    stmt.setObject(2, inventoryId);
    stmt.setObject(3, staffId);
    stmt.setObject(4, filmId);
    stmt.setObject(5, storeId);
    stmt.setObject(6, inventoryId);

	
	System.out.println(stmt);
	
	rowsAffected = stmt.executeUpdate();
  
    // 결과 처리 (업데이트된 행의 수)
    if (rowsAffected > 0) {
        out.println("대여 완료");
        response.sendRedirect("/sakila/d0327/inventoryList.jsp");
    } else {
        out.println("대여 실패");
    }
%>
<html>
<head>

   </head>
   <body>
           <h1>영화 대여 완료하였습니다.</h1>
           <h2>잠시 후 대여사이트로 이동합니다.</h2>
       <script>
        setTimeout(function() {
            window.location.href = '/sakila/d0327/inventoryList.jsp';
        }, 5000);
    </script>

    <button><a href="/sakila/d0327/inventoryList.jsp">영화 대여로 바로 이동하기</a></button>
</body>
</html>