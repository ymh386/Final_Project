<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시글 목록</title>
  <style>
    /* 간단 스타일 */
    .search-form { margin-bottom: 1em; }
    .search-form select,
    .search-form input[type="text"],
    .search-form button { padding: 4px 8px; }
    table { width:100%; border-collapse: collapse; }
    th, td { border:1px solid #ccc; padding:8px; }
    .pagination a { margin:0 4px; text-decoration:none; }
  </style>
</head>
<body>

  <h2>게시글 목록</h2>

  <!-- 검색 폼 -->
  <form class="search-form" action="<c:url value='/board/list'/>" method="get">
    <select name="searchField">
      <option value="BOARD_TITLE"
        <c:if test="${pager.searchField=='BOARD_TITLE'}">selected</c:if>>
        제목
      </option>
      <option value="BOARD_CONTENTS"
        <c:if test="${pager.searchField=='BOARD_CONTENTS'}">selected</c:if>>
        내용
      </option>
    </select>
    <input type="text" name="searchWord"
           value="${fn:escapeXml(pager.searchWord)}"
           placeholder="검색어를 입력하세요" />
    <button type="submit">검색</button>
  </form>

  <table>
    <thead>
      <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="b" items="${boards}">
        <tr>
          <td>${b.boardNum}</td>
          <td>
            <a href="<c:url value='/board/detail'>
                       <c:param name='boardNum' value='${b.boardNum}'/>
                     </c:url>">
              <c:out value="${b.boardTitle}"/>
            </a>
          </td>
          <td><c:out value="${b.userName}"/></td>
          <td><fmt:formatDate value="${b.boardDate}" pattern="yyyy-MM-dd"/></td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <!-- 페이지네이션 -->
  <div class="pagination">
    <c:if test="${pager.prev}">
      <a href="<c:url value='/board/list'>
                  <c:param name='curPage' value='${pager.startPage - 1}'/>
                  <c:param name='searchField' value='${pager.searchField}'/>
                  <c:param name='searchWord'  value='${pager.searchWord}'/>
                </c:url>">&laquo; 이전</a>
    </c:if>

    <c:forEach begin="${pager.startPage}" end="${pager.lastPage}" var="p">
      <c:choose>
        <c:when test="${p == pager.curPage}">
          <strong>${p}</strong>
        </c:when>
        <c:otherwise>
          <a href="<c:url value='/board/list'>
                      <c:param name='curPage' value='${p}'/>
                      <c:param name='searchField' value='${pager.searchField}'/>
                      <c:param name='searchWord'  value='${pager.searchWord}'/>
                    </c:url>">${p}</a>
        </c:otherwise>
      </c:choose>
    </c:forEach>

    <c:if test="${pager.next}">
      <a href="<c:url value='/board/list'>
                  <c:param name='curPage' value='${pager.lastPage + 1}'/>
                  <c:param name='searchField' value='${pager.searchField}'/>
                  <c:param name='searchWord'  value='${pager.searchWord}'/>
                </c:url>">다음 &raquo;</a>
    </c:if>
  </div>

</body>
</html>
