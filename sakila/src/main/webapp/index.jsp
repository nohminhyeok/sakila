<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 로그인 된 상태인지 아닌지 확인
    Integer staffId = (Integer)(session.getAttribute("loginStaff"));

    if(staffId == null) { // 로그인 상태가 아니면
        response.sendRedirect("/sakila/loginForm.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 인덱스 페이지</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        header {
            background-color: #4caf50;
            color: white;
            padding: 20px;
            font-size: 24px;
            border-bottom: 2px solid #ddd;
        }

        .greeting {
            margin: 20px 0;
            font-size: 20px;
            color: #333;
        }

        .button-container {
            margin: 20px 0;
        }

        button {
            padding: 12px 20px;
            font-size: 16px;
            color: white;
            background-color: #4caf50;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 10px;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #45a049;
        }

        a {
            text-decoration: none;
        }

        hr {
            border: 1px solid #ddd;
            width: 80%;
            margin: 30px auto;
        }

        h1 {
            color: #333;
            font-size: 32px;
        }

        ol {
            text-align: left;
            margin: 20px auto;
            display: inline-block;
            font-size: 18px;
            line-height: 1.8;
        }

        li {
            margin: 10px 0;
        }

        li a {
            text-decoration: none;
            color: #4caf50;
        }

        li a:hover {
            color: #45a049;
        }
    </style>
</head>
<body>

<header>
    <%= staffId %>님, 너무 반갑고ㅋ
</header>

<div class="greeting">
    <p>안녕하세요, 원하는 작업을 선택 하던지 말던지</p>
</div>

<div class="button-container">
    <a href="/sakila/logout.jsp">
        <button type="submit">로그아웃</button>
    </a>
    <a href="/sakila/updatePasswordForm.jsp">
        <button type="submit">비밀번호 변경</button>
    </a>
</div>

<hr>

<h1>메인 메뉴</h1>

<ol>
    <li><a href="/sakila/d0325/rentalList.jsp">대여목록</a></li>
    <li><a href="/sakila/d0326/filmList.jsp">필름목록</a></li>
    <li><a href="/sakila/d0326/actorList.jsp">액터목록</a></li>
    <li><a href="/sakila/d0327/inventoryList.jsp">영화대여</a></li>
</ol>

</body>
</html>