<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>공지사항 삭제</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f9fafc;
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            color: #333;
        }
        h2 {
            color: #e53e3e;
            font-weight: 700;
            margin-bottom: 20px;
            text-align: center;
        }
        .message {
            background-color: #ffe6e6;
            border: 1px solid #e53e3e;
            padding: 15px;
            border-radius: 6px;
            color: #b00000;
            font-weight: 600;
            margin-bottom: 30px;
            text-align: center;
        }
        .buttons {
            text-align: center;
        }
        button, a.button-link {
            background-color: #e53e3e;
            color: white;
            border: none;
            padding: 10px 25px;
            font-weight: 600;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            margin: 0 10px;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
        }
        button:hover, a.button-link:hover {
            background-color: #b22222;
        }
        a.button-link {
            background-color: #718096;
        }
        a.button-link:hover {
            background-color: #4a5568;
        }
    </style>
</head>
<body>

<h2>공지사항 삭제 확인</h2>

<c:if test="${not empty errorMsg}">
    <div class="message">${errorMsg}</div>
</c:if>

<p>정말로 이 공지사항을 삭제하시겠습니까?</p>

<form action="${pageContext.request.contextPath}/notice/delete/${notice.noticeId}" method="post" onsubmit="return confirm('삭제하시겠습니까?');" style="text-align: center; margin-top: 30px;">
    <button type="submit">삭제하기</button>
    <a href="${pageContext.request.contextPath}/notice/detail/${notice.noticeId}" class="button-link">취소</a>
</form>

</body>
</html>
