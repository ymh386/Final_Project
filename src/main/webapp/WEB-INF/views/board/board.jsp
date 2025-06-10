<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec"     uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>게시판</title>
    <link rel="stylesheet" href="/resources/css/style.css" />
</head>
<body>
    <div class="container">
        <h1>게시판 목록</h1>
        <a href="addBoard" class="btn btn-primary">글쓰기</a>
        <table class="board-table">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회수</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="board" items="${list}">
                    <tr>
                        <td><c:out value="${board.boardNum}"/></td>
                        <td>
                            <a href="detailBoard?boardNum=${board.boardNum}">
                                <c:out value="${board.boardTitle}"/>
                            </a>
                        </td>
                        <td><c:out value="${board.userName}"/></td>
                        <td><fmt:formatDate value="${board.boardDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td><c:out value="${board.boardHits}"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- 페이징 영역 -->
        <div class="pagination">
            <c:if test="${pager.prev}">
                <a href="?page=${pager.startPage - 1}">&laquo; 이전</a>
            </c:if>
            <c:forEach var="i" begin="${pager.startPage}" end="${pager.endPage}">
                <c:choose>
                    <c:when test="${i == pager.curPage}">
                        <span class="current">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${pager.next}">
                <a href="?page=${pager.endPage + 1}">다음 &raquo;</a>
            </c:if>
        </div>
    </div>
</body>
</html>
