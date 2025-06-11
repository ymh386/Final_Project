<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"    %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시판</title>
  <link rel="stylesheet" href="<c:url value='/resources/css/style.css'/>" />
  <style>
    .container { max-width: 1000px; margin: 0 auto; padding: 20px; }
    .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    .search-form select,
    .search-form input,
    .search-form button { padding: 6px; margin-right: 4px; }
    .btn-primary, .btn-home { display: inline-block; padding: 6px 12px; color: #fff; text-decoration: none; border-radius: 4px; }
    .btn-primary { background: #007bff; }
    .btn-home    { background: #28a745; margin-right: 8px; }
    table { width:100%; border-collapse: collapse; }
    th, td { border:1px solid #ccc; padding:8px; }
    .pagination a, .pagination strong { margin:0 4px; }
  </style>
</head>
<body>
  <div class="container">
    <h1>게시판</h1>

    <!-- 툴바: 홈, 글쓰기, 검색 -->
    <div class="toolbar">
      <div>
        <a href="<c:url value='/'/>" class="btn-home">홈으로</a>
        <a href="<c:url value='/board/add'/>" class="btn-primary">글쓰기</a>
      </div>
      <form class="search-form" action="<c:url value='/board/index'/>" method="get">
        <select name="searchField">
          <option value="BOARD_TITLE"  ${pager.searchField=='BOARD_TITLE'  ? 'selected' : ''}>제목</option>
          <option value="BOARD_CONTENTS"${pager.searchField=='BOARD_CONTENTS'? 'selected' : ''}>내용</option>
        </select>
        <input type="text" name="searchWord"
               value="<c:out value='${pager.searchWord}'/>"
               placeholder="검색어 입력" />
        <button type="submit">검색</button>
      </form>
    </div>

    <!-- 게시글 목록 테이블 -->
    <table>
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
        <c:forEach var="b" items="${boards}">
          <tr>
            <td><c:out value="${b.boardNum}"/></td>
            <td>
              <a href="<c:url value='/board/detail?boardNum=${b.boardNum}'/>">
                <c:out value="${b.boardTitle}"/>
              </a>
            </td>
            <td><c:out value="${b.userName}"/></td>
            <td><fmt:formatDate value="${b.boardDate}" pattern="yyyy-MM-dd HH:mm"/></td>
            <td><c:out value="${b.boardHits}"/></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>

    <!-- 페이징 -->
    <div class="pagination">
      <c:if test="${pager.prev}">
        <a href="<c:url value='/board/list'>
                    <c:param name='curPage'     value='${pager.startPage - 1}'/>
                    <c:param name='searchField' value='${pager.searchField}'/>
                    <c:param name='searchWord'  value='${pager.searchWord}'/>
                  </c:url>">&laquo; 이전</a>
      </c:if>

      <c:forEach var="i" begin="${pager.startPage}" end="${pager.lastPage}">
        <c:choose>
          <c:when test="${i == pager.curPage}">
            <strong>${i}</strong>
          </c:when>
          <c:otherwise>
            <a href="<c:url value='/board/list'>
                        <c:param name='curPage'     value='${i}'/>
                        <c:param name='searchField' value='${pager.searchField}'/>
                        <c:param name='searchWord'  value='${pager.searchWord}'/>
                      </c:url>">${i}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <c:if test="${pager.next}">
        <a href="<c:url value='/board/list'>
                    <c:param name='curPage'     value='${pager.lastPage + 1}'/>
                    <c:param name='searchField' value='${pager.searchField}'/>
                    <c:param name='searchWord'  value='${pager.searchWord}'/>
                  </c:url>">다음 &raquo;</a>
      </c:if>
    </div>
  </div>
</body>
</html>
