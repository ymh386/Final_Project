<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Q&A 글 수정</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            color: #333;
        }
        h2 {
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
        }
        form {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-bottom: 15px;
            font-weight: 600;
        }
        input[type="text"], input[type="password"], textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
            resize: vertical;
            transition: border-color 0.2s;
        }
        input[type="text"]:focus, input[type="password"]:focus, textarea:focus {
            outline: none;
            border-color: #2663eb;
        }
        .checkbox-label {
            display: flex;
            align-items: center;
            font-weight: 600;
            gap: 8px;
        }
        input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        .buttons {
            margin-top: 25px;
            display: flex;
            gap: 12px;
        }
        button, a.button-link {
            background-color: #2663eb;
            color: white;
            padding: 10px 25px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: background-color 0.2s;
        }
        button:hover, a.button-link:hover {
            background-color: #1d51bc;
        }
        a.button-link {
            line-height: 1.6;
            display: inline-block;
        }
    </style>
</head>
<body>

<h2>글 수정</h2>
<form action="${pageContext.request.contextPath}/qna/update" method="post">
    <input type="hidden" name="boardNum" value="${qna.boardNum}" />

    <label>제목:
        <input type="text" name="boardTitle" value="${qna.boardTitle}" required />
    </label>

    <label>내용:
        <textarea name="boardContents" rows="10" required>${qna.boardContents}</textarea>
    </label>

    <label class="checkbox-label">
        <input type="checkbox" name="isSecret" value="true" <c:if test="${qna.isSecret}">checked</c:if> />
        비밀글 설정
    </label>

    <label>비밀번호 (비밀글일 경우 필수):
        <input type="password" name="secretPassword" value="${qna.secretPassword}" />
    </label>

    <div class="buttons">
        <button type="submit">수정</button>
        <a href="${pageContext.request.contextPath}/qna/detail/${qna.boardNum}" class="button-link">취소</a>
    </div>
</form>

</body>
</html>
