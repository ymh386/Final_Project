<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"    %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <title>게시판 목록</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Helvetica Neue', Arial, sans-serif; background: #f5f7fa; color: #333; }
    a { text-decoration: none; color: inherit; }
    .container { width: 90%; max-width: 900px; margin: 40px auto; }
    header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
    header h1 { font-size: 2.2rem; color: #2c3e50; }
    .btn { padding: 10px 20px; border-radius: 6px; font-size: 0.95rem; font-weight: 500; cursor: pointer; transition: all 0.2s ease; }
    .btn-home {
      background: #bdc3c7;
      color: #2c3e50;
    }
    .btn-write {
      background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
      color: #fff;
      box-shadow: 0 4px 8px rgba(37,117,252,0.3);
    }
    .btn-home:hover { background: #aab2b8; }
    .btn-write:hover {
      background: linear-gradient(135deg, #5a09b8 0%, #1f65e0 100%);
      box-shadow: 0 6px 12px rgba(31,101,224,0.4);
      transform: translateY(-2px);
    }
    .search-form { display: flex; gap: 10px; margin-bottom: 32px; }
    .search-form select,
    .search-form input {
      flex: 1;
      padding: 12px;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 0.95rem;
    }
    .search-form button {
      padding: 12px 24px;
      background: #3498db;
      color: #fff;
      border: none;
      border-radius: 4px;
      font-size: 0.95rem;
      font-weight: 500;
      transition: background 0.2s ease;
    }
    .search-form button:hover { background: #2980b9; }
    .list { list-style:none; padding: 0; }
    .list-item {
      display: flex; justify-content: space-between; align-items: center;
      background: #fff; padding: 18px; margin-bottom: 14px;
      border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.05);
      transition: box-shadow 0.2s ease;
    }
    .list-item:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
    .list-item a { font-size: 1rem; color: #34495e; font-weight: 500; }
    .info { display: flex; gap: 16px; color: #7f8c8d; font-size: 0.9rem; }
    .secret-lock { color: #eb5757; margin-right: 6px; font-size: 1.08em; vertical-align: middle; }
    .no-data { text-align: center; padding: 60px 0; color: #95a5a6; font-size: 1rem; }
    .pagination { text-align:center; margin-top: 36px; }
    .pagination a, .pagination strong {
      display: inline-block; margin:0 6px; padding:10px 14px; border-radius:4px;
      font-size:0.9rem; transition: background 0.2s ease;
    }
    .pagination a { color:#3498db; }
    .pagination a:hover { background:#ecf6fc; }
    .pagination strong { background:#3498db; color:#fff; }
  </style>
</head>
<body>
  <div class="container">
    <!-- Header -->
    <header>
      <h1>게시판</h1>
      <div>
        <a href="<c:url value='/'/>" class="btn btn-home">홈</a>
        <a href="<c:url value='/board/add'/>" class="btn btn-write">글쓰기</a>
      </div>
    </header>

    <!-- Search -->
    <form class="search-form" action="<c:url value='/board/list'/>" method="get">
      <select name="searchField">
        <option value="BOARD_TITLE"  ${pager.searchField=='BOARD_TITLE'  ? 'selected':''}>제목</option>
        <option value="BOARD_CONTENTS"${pager.searchField=='BOARD_CONTENTS'? 'selected':''}>내용</option>
      </select>
      <input type="text" name="searchWord"
             value="<c:out value='${pager.searchWord}'/>"
             placeholder="검색어를 입력하세요" />
      <button type="submit">검색</button>
    </form>

    <!-- Posts List -->
    <ul class="list">
      <c:forEach var="b" items="${boards}">
        <li class="list-item">
          <a href="<c:url value='/board/detail?boardNum=${b.boardNum}'/>">
            <c:choose>
              <c:when test="${b.isSecret}">
                <span class="secret-lock">&#128274;</span>
                비밀글 입니다.
              </c:when>
              <c:otherwise>
                <c:out value="${b.boardTitle}"/>
              </c:otherwise>
            </c:choose>
          </a>
          <div class="info">
            <span>작성자: <c:out value="${b.userName}"/></span>
            <span>작성일: <fmt:formatDate value="${b.boardDate}" pattern="yyyy-MM-dd"/></span>
            <span>조회수: <c:out value="${b.boardHits}"/></span>
          </div>
        </li>
      </c:forEach>

      <c:if test="${empty boards}">
        <div class="no-data">등록된 게시글이 없습니다.</div>
      </c:if>
    </ul>

    <!-- Pagination -->
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