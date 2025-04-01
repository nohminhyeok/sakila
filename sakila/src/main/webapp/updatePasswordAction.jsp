<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Integer staffId = (Integer)(session.getAttribute("loginStaff"));
    
    if(staffId == null) { // 로그인 상태가 아니면
        response.sendRedirect("/sakila/loginForm.jsp");
        return;
    }

    int preId = Integer.parseInt(request.getParameter("preId"));
    int newId = Integer.parseInt(request.getParameter("newId"));
    String prePw = request.getParameter("prePw");
    String newPw = request.getParameter("newPw");
    
    Connection conn = null;
    PreparedStatement stmt1 = null;

    String sql1 = " UPDATE staff"
                 + " SET staff_id = ? , PASSWORD = ?"    
                 + " WHERE staff_id = ? AND PASSWORD = ?";

    
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
    stmt1 = conn.prepareStatement(sql1);
    stmt1.setInt(1, newId);
    stmt1.setString(2, newPw);
    stmt1.setInt(3, preId);
    stmt1.setString(4, prePw);
    
    // SQL 실행 (업데이트된 행 수 반환)
    int rowsUpdated = stmt1.executeUpdate(); 

    // 업데이트된 행이 있으면 비밀번호 변경 성공
    if (rowsUpdated > 0) {
        session.invalidate();
%>
    <html>
    <head>
        <style>
            body {
                font-family: 'Arial', sans-serif;
                background-color: #f4f4f9;
                text-align: center;
                padding: 50px;
            }

            .message {
                padding: 20px;
                margin: 20px;
                border-radius: 8px;
                color: #fff;
                font-size: 20px;
                text-align: center;
                max-width: 600px;
                margin: 0 auto;
            }

            .success {
                background-color: #4caf50;
                border: 1px solid #45a049;
            }

            .warning {
                background-color: #f44336;
                border: 1px solid #e53935;
            }

            button {
                padding: 12px 24px;
                font-size: 18px;
                background-color: #5c9df7;
                color: #fff;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s;
                margin-top: 20px;
            }

            button:hover {
                background-color: #4a87d0;
            }

            a {
                color: #fff;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="message success">
            <h1>비밀번호 변경에 성공했습니다.</h1>
            <h2>다시 로그인 해주면 아리가또네~</h2>
            <h3>잠시 후 로그인 페이지로 넘어간..ㄷ..ㅏ...</h3>
        </div>

        <script>
            setTimeout(function() {
                window.location.href = '/sakila/loginForm.jsp';
            }, 5000);
        </script>

        <button><a href="/sakila/loginForm.jsp">로그인 페이지로 카무이!</a></button>
    </body>
    </html>
<%
    } else {
%>
    <html>
    <head>
        <style>
            body {
                font-family: 'Arial', sans-serif;
                background-color: #f4f4f9;
                text-align: center;
                padding: 50px;
            }

            .message {
                padding: 20px;
                margin: 20px;
                border-radius: 8px;
                color: #fff;
                font-size: 20px;
                text-align: center;
                max-width: 600px;
                margin: 0 auto;
            }

            .warning {
                background-color: #f44336;
                border: 1px solid #e53935;
            }

            button {
                padding: 12px 24px;
                font-size: 18px;
                background-color: #5c9df7;
                color: #fff;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s;
                margin-top: 20px;
            }

            button:hover {
                background-color: #4a87d0;
            }

            a {
                color: #fff;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="message warning">
            <h1>비밀번호 변경에 실패했습니다.</h1>
            <h2>기존 비밀번호를 확인해주세요.</h2>
        </div>

        <button><a href="/sakila/updatePasswordFrom.jsp">돌아가기</a></button>
    </body>
    </html>
<%
    }
%>