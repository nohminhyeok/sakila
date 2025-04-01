<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	int customerId = Integer.parseInt(request.getParameter("customerId"));
	int active = Integer.parseInt(request.getParameter("active"));

    
	Connection conn = null;
	PreparedStatement stmt = null;
	String sql = "UPDATE customer"
				+" SET ACTIVE = ?"
				+" WHERE customer_id = ?";
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	stmt = conn.prepareStatement(sql);
	if(active == 0){
		active = 1;
	} else if (active == 1){
		active = 0;
	}
	
	stmt.setInt(1, active);
	stmt.setInt(2, customerId);
		
    stmt.executeUpdate();
    	
    // 리다이렉트 후 return 문을 삭제
    response.sendRedirect("/sakila/d0327/inventoryList.jsp");
%>	