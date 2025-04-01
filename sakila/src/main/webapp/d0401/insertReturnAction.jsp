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

    // 대여 테이블에서 반납일 설정
    String rentalUpdateSql = "UPDATE rental SET return_date = NOW() WHERE customer_id = ? AND inventory_id = ? AND return_date IS NULL";

    // 재고 테이블의 last_update를 현재 시간으로 업데이트 (영화가 반납되었으므로, '재고 있음'으로 상태 변경)
    String inventoryUpdateSql = "UPDATE inventory SET last_update = NOW() WHERE inventory_id = ?";

    // 데이터베이스 연결
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");

    // 대여 테이블 업데이트 (반납일 설정)
    stmt = conn.prepareStatement(rentalUpdateSql);
    stmt.setInt(1, customerId);
    stmt.setInt(2, inventoryId);
    rowsAffected = stmt.executeUpdate();

    // 재고 테이블 업데이트 (영화 상태 변경)
    if (rowsAffected > 0) {
        stmt = conn.prepareStatement(inventoryUpdateSql);
        stmt.setInt(1, inventoryId);
        stmt.executeUpdate();
    }

    // 자원 해제
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
%>

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>영화 반납 결과</title>
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
            <h1>영화 반납 완료되었습니다.</h1>
            <h2>잠시 후 대여 사이트로 이동합니다.</h2>
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
            <h1>반납 실패</h1>
            <p>해당 대여 정보가 존재하지 않거나 이미 반납된 영화입니다.</p>
        </div>
<%
    }
%>

    <button><a href="/sakila/d0327/inventoryList.jsp">영화 목록으로 이동하기</a></button>
</body>
</html>