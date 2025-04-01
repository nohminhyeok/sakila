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
    int storeId = Integer.parseInt(request.getParameter("storeId"));

    Connection conn = null;
    PreparedStatement stmt = null;
    int rowsAffected = 0;

    // rental 테이블에 삽입할 INSERT 문
    String sql = "INSERT INTO rental (customer_id, inventory_id, staff_id, rental_date) "
               + "VALUES (?, ?, ?, NOW())";

    // 데이터베이스 연결 및 SQL 실행
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");

    // rental 테이블에 대여 기록 삽입
    stmt = conn.prepareStatement(sql);
    stmt.setInt(1, customerId);
    stmt.setInt(2, inventoryId);
    stmt.setInt(3, staffId);

    // 실행
    rowsAffected = stmt.executeUpdate();
  
%>

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>대여 결과</title>
   <style>
       /* 전체 스타일 */
       body {
           font-family: Arial, sans-serif;
           background-color: #f4f4f4;
           color: #333;
           text-align: center;
           padding: 50px 0;
       }

       /* 제목 스타일 */
       h1 {
           color: #388e3c; /* 녹색 */
           font-size: 36px;
       }

       /* 결과 메시지 스타일 */
       h2 {
           font-size: 20px;
           color: #666;
       }

       /* 성공/실패 메시지 스타일 */
       .success-message {
           background-color: #e8f5e9; /* 연한 녹색 */
           border: 2px solid #388e3c;
           padding: 20px;
           margin: 20px auto;
           width: 50%;
           border-radius: 10px;
       }

       .error-message {
           background-color: #ffebee; /* 연한 빨간색 */
           border: 2px solid #d32f2f;
           padding: 20px;
           margin: 20px auto;
           width: 50%;
           border-radius: 10px;
       }

       /* 버튼 스타일 */
       button {
           background-color: #388e3c;
           color: white;
           border: none;
           padding: 10px 20px;
           font-size: 16px;
           border-radius: 5px;
           cursor: pointer;
           text-align: center;
       }

       button a {
           color: white;
           text-decoration: none;
       }

       button:hover {
           background-color: #2c6e2d;
       }
   </style>
</head>
<body>
<%
    if (rowsAffected > 0) {
%>
        <div class="success-message">
            <h1>영화 대여 완료하였습니다.</h1>
            <h2>잠시 후 대여사이트로 이동합니다.</h2>
            <script>
                setTimeout(function() {
                    window.location.href = '/sakila/d0327/inventoryList.jsp';
                }, 5000); // 5초 후 이동
            </script>
        </div>
<%
    } else {
%>  
        <div class="error-message">
            <h1>대여 실패</h1>
            <p>다시 시도해 주세요.</p>
        </div>
<%
    }
%>

    <button><a href="/sakila/d0327/inventoryList.jsp">영화 대여로 바로 이동하기</a></button>
</body>
</html>