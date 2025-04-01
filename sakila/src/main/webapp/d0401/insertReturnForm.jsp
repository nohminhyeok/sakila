<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
    Integer staffId = (Integer)session.getAttribute("loginStaff");
    Integer customerId = null;
    
    if(request.getParameter("customerId") != null){
        // 이름검색 후 이 페이지가 다시 요청되면 customerId 값을 받아 온다.
        customerId = Integer.parseInt(request.getParameter("customerId"));
    }

    // 반납 처리 시 필요한 정보 가져오기
    String sql = "SELECT i.inventory_id AS inventoryId, i.film_id AS filmId, f.title, i.store_id AS storeId "
               + "FROM inventory i INNER JOIN film f ON i.film_id = f.film_id "
               + "WHERE inventory_id = ?";
    
    // DB 연결
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    // 데이터베이스 연결 및 SQL 실행
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
    stmt = conn.prepareStatement(sql);
    stmt.setInt(1, inventoryId);
    rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 반납</title>
<style>
    /* 전체적인 스타일 설정 */
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f8f8;
        color: #333;
        margin: 0;
        padding: 0;
    }

    h1 {
        text-align: center;
        color: #388e3c; /* 녹색 */
        margin-top: 50px;
    }

    /* 버튼 스타일 */
    button {
        background-color: #388e3c; /* 녹색 */
        color: white;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        cursor: pointer;
        border-radius: 5px;
        margin-top: 20px;
    }

    button:hover {
        background-color: #2c6b28; /* 더 진한 녹색 */
    }

    /* 테이블 스타일 */
    table {
        width: 80%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    table td, table th {
        padding: 12px 15px;
        border: 1px solid #ddd;
        text-align: left;
    }

    table th {
        background-color: #388e3c; /* 녹색 */
        color: white;
    }

    table tr:nth-child(even) {
        background-color: #f2f2f2;
    }

    table tr:hover {
        background-color: #e1f5e1; /* 연한 녹색 */
    }

    /* 폼 입력 스타일 */
    input[type="text"] {
        width: 100%;
        padding: 8px;
        margin: 10px 0;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
    }

    input[type="text"]:read-only {
        background-color: #e9e9e9;
    }

    /* 폼 섹션 스타일 */
    form {
        margin: 20px;
        padding: 20px;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    form h2 {
        color: #388e3c;
        margin-bottom: 20px;
    }

</style>
</head>
<body>
    <h1>영화 반납</h1>
	<%
        if(rs.next()) {
	%>
		<form action="/sakila/d0401/searchCustomIdListReturn.jsp" method="post">
			<input type="hidden" name="inventoryId" value="<%=inventoryId%>">
			<input type="text" name="searchName" placeholder="이름으로 customerId 검색하기">
			<button type="submit">이름으로 customerId 검색하기</button>
		</form>
    <form action="/sakila/d0401/insertReturnAction.jsp" method="post">
        <table>
            <tr>
                <td>customerId</td>
                <td>
                    <input type="text" name="customerId" value="<%=customerId %>" readonly>
                </td>
            </tr>
            <tr>
                <td>inventoryId</td>
                <td><input type="text" name="inventoryId" value="<%=rs.getInt("inventoryId")%>" readonly></td>
            </tr>
            <tr>
                <td>filmId</td>
                <td><input type="text" name="filmId" value="<%=rs.getInt("filmId")%>" readonly>
                    <%=rs.getString("title")%>
                </td>
            </tr>
            <tr>
                <td>storeId</td>
                <td><input type="text" name="storeId" value="<%=rs.getInt("storeId")%>" readonly></td>
            </tr>
            <tr>
                <td>staffId</td>
                <td><input type="text" name="staffId" value="<%=staffId%>" readonly></td>
            </tr>
        </table>
        <button type="submit">반납하기</button>
    </form>
    <%
        }
    %>  
</body>
</html>