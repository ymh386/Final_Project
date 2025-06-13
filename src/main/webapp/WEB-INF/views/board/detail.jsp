<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"    %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"     %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시글 상세</title>
  <style>
    body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f0f2f5; margin: 0; padding: 20px; }
    .container { max-width: 800px; margin: auto; background: #fff; padding: 24px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    h2 { margin-top: 0; }
    .meta { color: #777; margin-bottom: 12px; font-size: 0.9em; }
    .content { white-space: pre-wrap; line-height: 1.6; margin: 16px 0; }
    .files a { display: inline-block; margin-right: 12px; color: #0066cc; text-decoration: none; }
    .files a:hover { text-decoration: underline; }
    .heart-btn { font-size: 1.4em; border: none; background: none; cursor: pointer; vertical-align: middle; }
    .comments { margin-top: 32px; }
    .comment-header { display: flex; justify-content: space-between; align-items: center; }
    .comment-list { list-style: none; padding: 0; }
    .comment-item { background: #fafafa; padding: 12px; border-radius: 6px; margin-bottom: 12px; position: relative; }
    .comment-meta { color: #555; font-size: 0.85em; margin-bottom: 6px; }
    .comment-actions { position: absolute; top: 12px; right: 12px; }
    .comment-actions form { display: inline; }
    .comment-actions button { background: none; border: none; color: #888; cursor: pointer; font-size: 0.9em; margin-left: 8px; }
    #commentForm textarea { width: 100%; height: 80px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
    #commentForm button { margin-top: 8px; padding: 8px 16px; background: #0066cc; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
    #commentForm button:hover { background: #005bb5; }
    .actions { margin-top: 24px; }
    .actions a { margin-right: 12px; color: #0066cc; text-decoration: none; }
    .actions a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <div class="container">
    <h2><c:out value="${detail.boardTitle}"/></h2>
    <div class="meta">
      작성자: <c:out value="${detail.userName}"/>
      &nbsp;|&nbsp;
      작성일: <fmt:formatDate value="${detail.boardDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
      &nbsp;|&nbsp;
      조회수: <span id="viewCount">${detail.boardHits}</span>
    </div>

    <!-- 좋아요 -->
    <div class="meta">
      <c:choose>
        <c:when test="${isLiked}">
          <form action="<c:url value='/board/removeInteraction'/>" method="post" style="display:inline">
            <input type="hidden" name="boardNum" value="${detail.boardNum}"/>
            <button type="submit" class="heart-btn">💕</button>
          </form>
        </c:when>
        <c:otherwise>
          <form action="<c:url value='/board/addInteraction'/>" method="post" style="display:inline">
            <input type="hidden" name="boardNum" value="${detail.boardNum}"/>
            <button type="submit" class="heart-btn">🤍</button>
          </form>
        </c:otherwise>
      </c:choose>
      <span>좋아요 수: ${likeCount}</span>
    </div>

    <hr/>

    <div class="content">
      <c:out value="${detail.boardContents}"/>
    </div>

    <!-- 첨부파일 -->
    <c:if test="${not empty files}">
      <div class="files">
        <strong>첨부파일:</strong>
        <c:forEach var="f" items="${files}">
          <a href="<c:url value='/board/fileDown'><c:param name='fileNum' value='${f.fileNum}'/></c:url>">
            ${f.oldName}
          </a>
        </c:forEach>
      </div>
      <hr/>
    </c:if>

    <!-- 댓글 -->
    <div class="comments">
      <div class="comment-header">
        <h3>댓글 (<c:out value="${comments.size()}"/>)</h3>
      </div>
      <ul class="comment-list">
        <c:forEach var="cmt" items="${comments}">
          <li class="comment-item">
            <div class="comment-meta">
              <strong>${cmt.userName}</strong>
              &nbsp;|&nbsp;
              <fmt:formatDate value="${cmt.commentDate}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
            <div class="comment-body">
              <c:out value="${cmt.commentContents}"/>
            </div>
            <c:if test="${sessionScope.userName == cmt.userName}">
              <div class="comment-actions">
                <form action="<c:url value='/board/updateComment'/>" method="post">
                  <input type="hidden" name="commentNum" value="${cmt.commentNum}"/>
                  <button type="submit">수정</button>
                </form>
                <form action="<c:url value='/board/deleteComment'/>" method="post" onsubmit="return confirm('댓글을 삭제하시겠습니까?');">
                  <input type="hidden" name="commentNum" value="${cmt.commentNum}"/>
                  <button type="submit">삭제</button>
                </form>
              </div>
            </c:if>
          </li>
        </c:forEach>
      </ul>

      <form id="commentForm" action="<c:url value='/board/addComment'/>" method="post">
        <input type="hidden" name="boardNum" value="${detail.boardNum}"/>
        <textarea name="commentContents" placeholder="댓글을 입력하세요"></textarea>
        <button type="submit">댓글 작성</button>
      </form>
    </div>

    <div class="actions">
      <a href="<c:url value='/board/list'/>">목록</a>
      <c:if test="${detail.userName == sessionScope.userName}">
        <a href="<c:url value='/board/update'><c:param name='boardNum' value='${detail.boardNum}'/></c:url>">수정</a>
        <a href="<c:url value='/board/delete'><c:param name='boardNum' value='${detail.boardNum}'/></c:url>"
           onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
      </c:if>
    </div>

    <!-- JS용 숨은 필드 -->
    <input type="hidden" id="boardNum" value="${detail.boardNum}"/>

    <!-- 조회수 비동기 업데이트 -->
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        const boardNum = document.getElementById('boardNum').value;
        fetch(`/board/hitUpdateAsync?boardNum=${boardNum}`, {
          method: 'POST'
        })
        .then(res => {
          if (!res.ok) throw new Error(res.statusText);
          return res.text();
        })
        .then(count => {
          document.getElementById('viewCount').textContent = count;
        })
        .catch(err => console.error('조회수 업데이트 실패:', err));
      });
    </script>
  </div>
</body>
</html>
