<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>QnA 게시판</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f7f7fb; margin: 0; }
        .container { max-width: 900px; margin: 40px auto; background: #fff; border-radius: 14px; box-shadow: 0 6px 32px rgba(20,30,50,0.09); padding: 38px; }
        h2 { margin-bottom: 24px; }
        .btn-group { float: right; margin-bottom: 18px; }
        .modern-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            border: none;
            padding: 10px 28px;
            border-radius: 999px;
            font-size: 16px;
            font-weight: 500;
            background: linear-gradient(90deg, #6366f1 15%, #6d9cf6 100%);
            color: #fff;
            box-shadow: 0 2px 8px rgba(100,120,230,0.10);
            cursor: pointer;
            text-decoration: none;
            margin-left: 8px;
            transition: transform .1s, box-shadow .1s, background .2s;
        }
        .modern-btn:hover {
            transform: translateY(-2px) scale(1.03);
            background: linear-gradient(90deg, #3c47b5 10%, #93b4fa 100%);
            box-shadow: 0 4px 16px rgba(100,120,230,0.13);
        }
        table { width: 100%; border-collapse: collapse; margin-bottom: 24px; }
        th, td { border-bottom: 1px solid #e4e4e4; padding: 13px 8px; text-align: center; }
        th { background: #f0f2f7; color: #34395e; }
        td.title { text-align: left; }
        .secret-icon { color: #d32f2f; margin-right: 5px; }
        .pagination { margin: 32px 0 0 0; text-align: center; }
        .pagination a, .pagination span {
            display: inline-block; min-width: 36px; height: 36px; line-height: 36px;
            margin: 0 3px; text-align: center; border-radius: 6px;
            text-decoration: none; color: #34495e;
        }
        .pagination .active { background: #2663eb; color: #fff; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h2>QnA 게시판</h2>
    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/" class="modern-btn">
            <i class="fas fa-home"></i> 홈
        </a>
        <a href="${pageContext.request.contextPath}/qna/add" class="modern-btn">
            <i class="fas fa-pen"></i> 글쓰기
        </a>
    </div>
    <table>
        <thead>
            <tr>
                <th>No</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>조회수</th>
            </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty list}">
                <c:forEach var="qna" items="${list}">
                    <tr>
                        <td>${qna.qnaNum}</td>
                        <td class="title">
                            <a href="${pageContext.request.contextPath}/qna/detail?qnaNum=${qna.qnaNum}">
                                <c:if test="${qna.isSecret == 1}">
                                    <span class="secret-icon"><i class="fas fa-lock"></i></span>
                                </c:if>
                                <c:out value="${qna.qnaTitle}"/>
                            </a>
                        </td>
                        <td>${qna.username}</td>
                        <td>
                            <fmt:formatDate value="${qna.qnaDate}" pattern="yyyy-MM-dd HH:mm"/>
                        </td>
                        <td>${qna.qnaHits}</td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5">등록된 게시글이 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
    <!-- 페이지네이션 예시 -->
    <c:if test="${not empty pager}">
        <div class="pagination">
            <c:if test="${pager.startPage > 1}">
                <a href="?curPage=${pager.startPage - 1}">&laquo;</a>
            </c:if>
            <c:forEach var="i" begin="${pager.startPage}" end="${pager.lastPage}">
                <c:choose>
                    <c:when test="${pager.curPage == i}">
                        <span class="active">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="?curPage=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${pager.lastPage < pager.totalPage}">
                <a href="?curPage=${pager.lastPage + 1}">&raquo;</a>
            </c:if>
        </div>
    </c:if>
</div>
</body>
</html>
