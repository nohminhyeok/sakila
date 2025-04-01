<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 변경</title>
    <style>
        /* 기본 폰트 및 여백 설정 */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-top: 50px;
            font-size: 32px;
        }

        /* 폼 컨테이너 스타일 */
        form {
            width: 60%;
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        table {
            width: 100%;
            margin-bottom: 20px;
            border-collapse: collapse;
        }

        th {
            padding: 12px;
            background-color: #f2f2f2;
            text-align: left;
            font-size: 18px;
        }

        td {
            padding: 12px;
            font-size: 16px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 8px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #5c9df7;
            outline: none;
        }

        button {
            width: 100%;
            padding: 12px;
            font-size: 18px;
            background-color: #5c9df7;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #4a87d0;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            form {
                width: 90%;
            }

            h1 {
                font-size: 28px;
            }

            table {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <h1>사용자 변경</h1>
    <form action="/sakila/updatePasswordAction.jsp">
        <table>
            <tr>
                <th>기존 아이디</th>
                <td><input type="text" name="preId"></td>
            </tr>
            <tr>
                <th>기존 비밀번호</th>
                <td><input type="password" name="prePw"></td>
            </tr>
            <tr>
                <th>변경할 아이디</th>
                <td><input type="text" name="newId"></td>
            </tr>
            <tr>
                <th>변경할 비밀번호</th>
                <td><input type="password" name="newPw"></td>
            </tr>
        </table>
        <button type="submit">변경하기</button>
    </form>
</body>
</html>