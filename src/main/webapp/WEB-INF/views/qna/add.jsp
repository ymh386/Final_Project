<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Q&A 글쓰기</title>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f9fafc;
        margin: 0;
        padding: 20px;
        color: #333;
    }
    .container {
        max-width: 700px;
        margin: 40px auto;
        background: #fff;
        padding: 30px 40px;
        border-radius: 8px;
        box-shadow: 0 4px 14px rgb(0 0 0 / 0.1);
    }

    h2 {
        font-weight: 700;
        color: #1a202c;
        margin-bottom: 24px;
        font-size: 2rem;
        text-align: center;
    }

    form label {
        display: block;
        margin-bottom: 12px;
        font-weight: 600;
        color: #2d3748;
    }

    input[type="text"],
    input[type="password"],
    textarea {
        width: 100%;
        padding: 12px 14px;
        border: 1px solid #cbd5e0;
        border-radius: 6px;
        font-size: 1rem;
        font-family: inherit;
        background: #f7fafc;
        transition: border-color 0.2s ease;
        box-sizing: border-box;
    }

    input[type="text"]:focus,
    input[type="password"]:focus,
    textarea:focus {
        outline: none;
        border-color: #3182ce;
        background: #fff;
    }

    textarea {
        resize: vertical;
        min-height: 140px;
    }

    .checkbox-label {
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 600;
        margin-top: 16px;
        margin-bottom: 24px;
        color: #2d3748;
    }

    .btn-row {
        display: flex;
        justify-content: flex-end;
        gap: 16px;
    }

    button, .cancel-btn {
        padding: 12px 30px;
        border-radius: 6px;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        border: none;
        box-shadow: 0 2px 8px rgb(50 100 230 / 0.4);
        transition: background-color 0.3s ease;
        user-select: none;
        text-decoration: none;
        color: white;
    }

    button {
        background-color: #2b6cb0;
    }

    button:hover {
        background-color: #2c5282;
    }

    .cancel-btn {
        background-color: #718096;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }

    .cancel-btn:hover {
        background-color: #4a5568;
    }
</style>
</head>
<body>
<div class="container">
    <h2>글쓰기</h2>
    <form action="${pageContext.request.contextPath}/qna/add" method="post">
        <label for="boardTitle">제목</label>
        <input type="text" id="boardTitle" name="boardTitle" required />

        <label for="boardContents">내용</label>
        <textarea id="boardContents" name="boardContents" required></textarea>

        <label class="checkbox-label">
            <input type="checkbox" name="isSecret" value="true" />
            비밀글 설정
        </label>

        <label for="secretPassword">비밀번호 (비밀글일 경우 필수)</label>
        <input type="password" id="secretPassword" name="secretPassword" />

        <div class="btn-row">
            <button type="submit">등록</button>
            <a href="${pageContext.request.contextPath}/qna/list" class="cancel-btn">취소</a>
        </div>
    </form>
</div>
</body>
</html>
