<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>공지사항 상세</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; margin: 20px; }
        .container { max-width: 700px; margin: auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h1 { margin-bottom: 20px; }
        .meta { color: #555; font-size: 0.9em; margin-bottom: 20px; }
        .content { white-space: pre-wrap; line-height: 1.6; }
        .actions { margin-top: 30px; }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-right: 10px;
            border-radius: 6px;
            font-weight: bold;
            text-decoration: none;
            color: white;
            background-color: #3498db;
            transition: background-color 0.3s;
            cursor: pointer;
            border: none;
        }
        .btn:hover { background-color: #2980b9; }
        .btn-delete { background-color: #e74c3c; }
        .btn-delete:hover { background-color: #c0392b; }
    </style>
</head>
<body>
<div class="container">
    <h1><c:out value="${detail.boardTitle}" /></h1>
    <div class="meta">
        작성자: <c:out value="${detail.userName}" /> |
        작성일: <fmt:formatDate value="${detail.boardDate}" pattern="yyyy-MM-dd HH:mm:ss" /> |
        조회수: <c:out value="${detail.boardHits}" />
    </div>
    <div class="content">
        <c:out value="${detail.boardContents}" />
    </div>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/notice/list" class="btn">목록</a>

        <sec:authorize access="hasRole('ROLE_ADMIN')">
            <a href="${pageContext.request.contextPath}/notice/update?boardNum=${detail.boardNum}" class="btn">수정</a>

            <form action="${pageContext.request.contextPath}/notice/delete" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                <input type="hidden" name="boardNum" value="${detail.boardNum}" />
                <button type="submit" class="btn btn-delete">삭제</button>
            </form>
        </sec:authorize>
    </div>
</div>
</body>
</html>