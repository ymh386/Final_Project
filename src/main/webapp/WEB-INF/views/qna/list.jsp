<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Q&A 게시판</title>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f9fafc;
        margin: 0;
        padding: 20px;
        color: #333;
    }
    .header {
        max-width: 900px;
        margin: 0 auto 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    h2 {
        color: #1a202c;
        font-weight: 700;
        font-size: 2rem;
        margin: 0;
    }
    .btn-group {
        display: flex;
        gap: 10px;
    }
    .btn-home, .btn-write {
        background-color: #2b6cb0;
        color: white;
        font-weight: 600;
        padding: 8px 20px;
        border-radius: 6px;
        text-decoration: none;
        box-shadow: 0 2px 8px rgba(43,108,176,0.4);
        transition: background-color 0.3s ease;
        cursor: pointer;
        display: inline-block;
    }
    .btn-home {
        background-color: #718096;
        box-shadow: 0 2px 8px rgba(113,128,150,0.4);
    }
    .btn-home:hover {
        background-color: #4a5568;
    }
    .btn-write:hover {
        background-color: #1d4f9c;
    }
    ul.qna-list {
        list-style: none;
        padding: 0;
        margin: 0 auto;
        max-width: 900px;
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgb(0 0 0 / 0.1);
        padding: 20px 30px;
    }
    li.qna-item {
        border-bottom: 1px solid #e2e8f0;
        padding: 16px 0;
        cursor: default;
        position: relative;
    }
    .qna-main {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: 600;
        font-size: 1rem;
    }
    .qna-title {
        color: #2b6cb0;
        text-decoration: none;
    }
    .qna-title:hover {
        text-decoration: underline;
    }
    .qna-secret {
        color: #e53e3e;
        margin-left: 8px;
    }
    .qna-info {
        font-size: 0.85rem;
        color: #718096;
        margin-top: 6px;
    }
    .btn-reply {
        font-size: 0.85rem;
        cursor: pointer;
        color: #4a5568;
        background: none;
        border: none;
        padding: 2px 6px;
        border-radius: 4px;
        transition: background-color 0.2s;
    }
    .btn-reply:hover {
        background-color: #e2e8f0;
    }
    form.reply-form {
        margin-top: 12px;
        padding: 12px 16px;
        border-radius: 6px;
        background-color: #f7fafc;
        border: 1px solid #cbd5e0;
        max-width: 600px;
        font-size: 0.9rem;
    }
    form.reply-form textarea {
        width: 100%;
        height: 50px;
        border-radius: 4px;
        border: 1px solid #ccc;
        padding: 6px 8px;
        font-size: 14px;
        resize: vertical;
        margin-bottom: 6px;
    }
    form.reply-form input[type="password"] {
        width: 100%;
        border-radius: 4px;
        border: 1px solid #ccc;
        padding: 6px 8px;
        font-size: 14px;
        margin-bottom: 6px;
    }
    form.reply-form label {
        font-weight: 600;
        display: block;
        margin-bottom: 4px;
    }
    form.reply-form button {
        background-color: #2b6cb0;
        color: white;
        border: none;
        padding: 6px 16px;
        font-weight: 600;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.2s;
        float: right;
    }
    form.reply-form button:hover {
        background-color: #1d4f9c;
    }
</style>

<script>
function toggleReplyForm(id) {
    var form = document.getElementById('reply-form-' + id);
    if (form.style.display === 'block') {
        form.style.display = 'none';
    } else {
        // 모든 답글폼 닫기
        document.querySelectorAll('form.reply-form').forEach(f => f.style.display = 'none');
        form.style.display = 'block';
    }
}
</script>

</head>
<body>

<div class="header">
    <h2>Q&A 게시판</h2>
    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/" class="btn-home">홈</a>
        <a href="${pageContext.request.contextPath}/qna/add" class="btn-write">글쓰기</a>
    </div>
</div>

<ul class="qna-list">
    <c:forEach var="qna" items="${list}">
        <li class="qna-item" style="margin-left: ${qna.boardDepth * 30}px;">
            <div class="qna-main">
                <a href="${pageContext.request.contextPath}/qna/detail/${qna.boardNum}" class="qna-title">
                    <c:out value="${qna.boardTitle}" />
                </a>
                <c:if test="${qna.isSecret}">
                    <span class="qna-secret">🔒</span>
                </c:if>

                <button class="btn-reply" type="button" onclick="toggleReplyForm(${qna.boardNum})">답글쓰기</button>
            </div>
            <div class="qna-info">
                작성자: ${qna.userName} | 작성일: ${qna.boardDate}
            </div>

            <!-- 답글 폼 (숨김 상태로 초기화) -->
<form class="reply-form" id="reply-form-${qna.boardNum}" method="post" action="${pageContext.request.contextPath}/qna/reply" style="display:none;">
    <!-- 부모 글 번호를 boardRef에 넣기 -->
    <input type="hidden" name="boardRef" value="${qna.boardNum}" />
    <input type="hidden" name="boardStep" value="${qna.boardStep}" />
    <input type="hidden" name="boardDepth" value="${qna.boardDepth}" />

    <label for="reply-content-${qna.boardNum}">답글 내용</label>
    <textarea id="reply-content-${qna.boardNum}" name="boardContents" placeholder="답글 내용을 입력하세요" required></textarea>

    <label>
        <input type="checkbox" name="isSecret" value="true" />
        비밀글 설정
    </label>

    <label for="reply-password-${qna.boardNum}">비밀번호 (비밀글일 경우 필수)</label>
    <input type="password" id="reply-password-${qna.boardNum}" name="secretPassword" />

    <button type="submit">등록</button>
</form>

        </li>
    </c:forEach>
</ul>

</body>
</html>