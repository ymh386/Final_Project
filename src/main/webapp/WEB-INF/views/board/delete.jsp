<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 삭제</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f7f7fb; margin: 0; }
        .container { max-width: 400px; margin: 100px auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 14px rgba(0,0,0,.09); padding: 38px 30px 32px 30px; text-align: center;}
        h2 { color: #c62828; margin-bottom: 18px; }
        p { margin-bottom: 36px; color: #222; font-size: 16px; }
        .button-row { text-align: center; }
        button, .cancel-btn {
            background: #d32f2f; color: #fff; border: none;
            border-radius: 5px; padding: 10px 38px; font-size: 15px;
            margin: 0 8px; cursor: pointer; font-weight: 500; box-shadow: 0 1px 3px rgba(211,47,47,0.10);
            transition: background 0.16s;
        }
        button:hover { background: #9b2020; }
        .cancel-btn { background: #aeb3c1; color: #fff; text-decoration: none; }
        .cancel-btn:hover { background: #7b7f8a; }
    </style>
</head>
<body>
<div class="container">
    <h2>게시글 삭제</h2>
    <p>정말 이 게시글을<br> <b style="color:#c62828;">삭제</b> 하시겠습니까?</p>
    <form action="${pageContext.request.contextPath}/board/delete" method="post" style="display:inline;">
        <input type="hidden" name="boardNum" value="${param.boardNum}" />
        <div class="button-row">
            <button type="submit">삭제</button>
            <a href="${pageContext.request.contextPath}/board/detail?boardNum=${param.boardNum}" class="cancel-btn">취소</a>
        </div>
    </form>
</div>
</body>
</html>
