<%-- 404.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>페이지를 찾을 수 없습니다</title>
    <style>
        .error-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            text-align: center;
        }
        .error-code {
            font-size: 72px;
            font-weight: bold;
            color: #6c757d;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }
        .error-description {
            font-size: 16px;
            color: #6c757d;
            margin-bottom: 30px;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 3px;
            display: inline-block;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">404</div>
        <div class="error-message">페이지를 찾을 수 없습니다</div>
        <div class="error-description">
            요청하신 페이지가 존재하지 않거나 이동되었습니다.<br>
            URL을 다시 확인해주세요.
        </div>
        <a href="/" class="btn">홈으로 돌아가기</a>
    </div>
</body>
</html>