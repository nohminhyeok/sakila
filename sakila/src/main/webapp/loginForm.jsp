<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 로그인 된 상태인지 아닌지 확인
    Integer staffId = (Integer)(session.getAttribute("loginStaff"));
    
    if(staffId != null) { // 로그인 상태면
        response.sendRedirect("/sakila/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden; /* 페이지 내에서 요소가 벗어나지 않게 */
        }

        .login-container {
            position: absolute; /* 로그인 박스를 절대 위치로 설정 */
            top: 20px;
            left: 20px;
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: center;
            animation: moveLogin 15.0s ease-in-out infinite; /* 애니메이션 추가 */
        }

        h1 {
            font-size: 28px;
            margin-bottom: 20px;
            color: #333;
        }

        table {
            width: 100%;
            margin-bottom: 20px;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            font-size: 16px;
            color: #333;
        }

        input[type="number"], input[type="password"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-top: 5px;
            box-sizing: border-box;
        }

        input[type="number"]:focus, input[type="password"]:focus {
            border-color: #4caf50;
            outline: none;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #4caf50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 20px;
        }

        button:hover {
            background-color: #45a049;
        }

        .footer {
            font-size: 14px;
            margin-top: 10px;
        }

        /* 로그인 박스가 순간이동하는 애니메이션 */
        @keyframes moveLogin {
            0% {
                top: 20px;
                left: 20px;
            }
            20% {
                top: 10%;
                left: 80%;
            }
            40% {
                top: 80%;
                left: 50%;
            }
            60% {
                top: 50%;
                left: 10%;
            }
            80% {
                top: 70%;
                left: 70%;
            }
            100% {
                top: 20px;
                left: 20px;
            }
        }
    </style>
</head>
<body>

<div class="login-container">
    <h1>Staff Login</h1>
    <form action="/sakila/loginAction.jsp" method="post">
        <table>
            <tr>
                <th>Staff ID</th>
                <td><input type="number" name="staffId" required></td>
            </tr>
            <tr>
                <th>Password</th>
                <td><input type="password" name="password" required></td>
            </tr>
        </table>
        <button type="submit">로그인</button>    
    </form>
    <div class="footer">
        <h2>아이디나 비밀번호를 잊으셨나요?</h2>
        <h2>멍청하시넹ㅋ</h2>
    </div>
</div>

</body>
</html>