<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
    Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
    String searchName = request.getParameter("searchName");

    // DB 연결
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String sql = "SELECT customer_id customerId, first_name firstName, last_name lastName, email, active " +
                 "FROM customer WHERE concat(first_name, last_name) LIKE ?";
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, "%" + searchName + "%");
    rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객 목록</title>
<style>
    /* 기본 body 스타일 */
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f8f8; /* 연한 회색 배경 */
        margin: 0;
        padding: 0;
    }

    /* 제목 스타일 */
    h1 {
        text-align: center;
        color: #388e3c; /* 녹색 */
        margin-top: 50px;
        font-size: 30px;
    }

    /* 테이블 스타일 */
    table {
        width: 80%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: white;
        border: 1px solid #ddd;
    }

    th, td {
        padding: 12px;
        text-align: center;
        border: 1px solid #ddd;
    }

    th {
        background-color: #388e3c; /* 녹색 */
        color: white;
        font-weight: bold;
    }

    td a {
        color: #388e3c; /* 녹색 링크 */
        text-decoration: none;
        font-weight: bold;
    }

    td a:hover {
        text-decoration: underline;
    }
</style>
</head>
<body>
    <h1>고객 목록</h1>
    <table>
        <tr>
            <th>customerId</th>
            <th>firstName</th>
            <th>lastName</th>
            <th>email</th>
            <th>active</th>
            <th>선택</th>
        </tr>
        <%
            while(rs.next()){
        %>
        <tr>
            <td><%=rs.getInt("customerId")%></td>
            <td><%=rs.getString("firstName")%></td>
            <td><%=rs.getString("lastName")%></td>
            <td><%=rs.getString("email")%></td>
            <td><%=rs.getInt("active")%></td>
            <td>
                <%
                    if(rs.getInt("active") == 0) {
                %>
                        <a href='/sakila/d0327/updateCustomerAction.jsp?active=<%=rs.getInt("active")%>&customerId=<%=rs.getInt("customerId")%>'>
                            휴면상태 해지
                        </a>
                <%        
                    } else {
                %>
                        <a href='/sakila/d0327/insertRentalForm.jsp?customerId=<%=rs.getInt("customerId")%>&inventoryId=<%=inventoryId%>'>선택하기</a>
                <%        
                    }
                %>
            </td>
        </tr>			
        <%		
            }
        %>
    </table>

</body>
</html>