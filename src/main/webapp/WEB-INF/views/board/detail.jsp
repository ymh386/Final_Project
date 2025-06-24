<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>게시글 상세</title>

  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f0f2f5;
      margin: 0; padding: 20px;
      color: #333;
    }
    .container {
      max-width: 800px;
      margin: auto;
      background: #fff;
      padding: 24px;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    h2 {
      margin-top: 0;
    }
    .meta {
      color: #777;
      margin-bottom: 12px;
      font-size: 0.95em;
    }
    .content {
      white-space: pre-wrap;
      line-height: 1.6;
      margin: 18px 0;
    }
    .files a {
      display: inline-block;
      margin-right: 12px;
      color: #2663eb;
      text-decoration: none;
      font-weight: 500;
    }
    .files a:hover {
      text-decoration: underline;
    }
    /* 댓글 리스트 */
    .comment-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    /* 댓글 항목 - 트리 들여쓰기 및 배경색 */
    .comment-item {
      background: #f8f9fa;
      padding: 12px;
      border-radius: 6px;
      margin-bottom: 12px;
      position: relative;
    }
    /* depth별 margin-left (30px씩) */
    .comment-item[data-depth='0'] { margin-left: 0; }
    .comment-item[data-depth='1'] { margin-left: 30px; background-color: #e7f0fd; }
    .comment-item[data-depth='2'] { margin-left: 60px; background-color: #d0e5fc; }
    .comment-item[data-depth='3'] { margin-left: 90px; background-color: #b7dbfb; }
    .comment-item[data-depth='4'] { margin-left: 120px; background-color: #9ed0fa; }
    .comment-item[data-depth='5'] { margin-left: 150px; background-color: #85c6f9; }
    /* 댓글 메타 정보 */
    .comment-meta {
      color: #555;
      font-size: 0.87em;
      margin-bottom: 6px;
    }
    /* 댓글 작성자/날짜 */
    .comment-body {
      margin-bottom: 6px;
    }
    /* 댓글 액션 버튼들 위치 */
    .comment-actions {
      position: absolute;
      top: 12px;
      right: 12px;
    }
    .comment-actions form {
      display: inline;
    }
    .comment-actions button {
      background: none;
      border: none;
      color: #888;
      cursor: pointer;
      font-size: 0.95em;
      margin-left: 8px;
    }
    /* 답글 폼 기본 숨김 */
    form.reply-form {
      display: none;
      margin-top: 8px;
      padding: 12px;
      background: #f7fafc;
      border: 1px solid #cbd5e0;
      border-radius: 6px;
      max-width: 600px;
    }
    form.reply-form textarea {
      width: 100%;
      height: 50px;
      padding: 6px 8px;
      border-radius: 4px;
      border: 1px solid #ccc;
      resize: vertical;
      margin-bottom: 6px;
      font-size: 14px;
    }
    form.reply-form button {
      background-color: #2663eb;
      color: white;
      border: none;
      padding: 6px 16px;
      border-radius: 4px;
      cursor: pointer;
      font-weight: 600;
      float: right;
      transition: background-color 0.2s;
    }
    form.reply-form button:hover {
      background-color: #1d51bc;
    }
    /* 답글쓰기 버튼 */
    .reply-btn {
      font-size: 0.85em;
      color: #2663eb;
      background: none;
      border: none;
      cursor: pointer;
      padding: 0;
      margin-top: 6px;
    }
    .reply-btn:hover {
      text-decoration: underline;
    }
    /* 버튼 그룹 */
    .actions {
      margin-top: 32px;
      text-align: right;
    }
    .actions a, .actions form button {
      display: inline-block;
      padding: 9px 25px;
      font-size: 15px;
      border-radius: 5px;
      border: none;
      text-decoration: none;
      margin-left: 7px;
      font-weight: 500;
      transition: background .18s;
      cursor: pointer;
    }
    .actions .list-btn { background: #e0e3ef; color: #444; }
    .actions .list-btn:hover { background: #d3d6e0; }
    .actions .edit-btn { background: #2663eb; color: #fff; }
    .actions .edit-btn:hover { background: #1d51bc; }
    .actions .delete-btn { background: #d32f2f; color: #fff; }
    .actions .delete-btn:hover { background: #a72323; }
    /* 하트 버튼 스타일 */
    .heart-btn {
      font-size: 1.3em;
      border: none;
      background: none;
      cursor: pointer;
      vertical-align: middle;
      color: #d32f2f;
    }
    
    /* 댓글 입력폼 - 기존에 썼던 스타일 */
    #commentForm textarea {
      width: 100%;
      height: 80px;
      padding: 8px;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 14px;
      resize: vertical;
      box-sizing: border-box;
    }
    #commentForm button {
      margin-top: 8px;
      padding: 8px 16px;
      background: #2663eb;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-weight: bold;
      transition: background-color 0.2s ease;
    }
    #commentForm button:hover {
      background: #1d51bc;
    }
  </style>

  <c:if test="${not empty _csrf}">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
  </c:if>

  <c:url var="hitUrl" value="${pageContext.request.contextPath}/board/hitUpdateAsync" />
</head>
<body>
  <div class="container">
    <h2>
      <c:choose>
        <c:when test="${detail.isSecret}">
          <span style="color:#d32f2f;">비밀글</span>
        </c:when>
        <c:otherwise>
          <c:out value="${detail.boardTitle}" />
        </c:otherwise>
      </c:choose>
    </h2>

    <div class="meta">
      작성자: <c:out value="${detail.userName}" />
      &nbsp;|&nbsp;
      작성일: <fmt:formatDate value="${detail.boardDate}" pattern="yyyy-MM-dd HH:mm:ss" />
      &nbsp;|&nbsp;
      조회수: <span id="viewCount">${detail.boardHits}</span>
    </div>

    <!-- 좋아요 영역 -->
    <div class="meta">
      <c:choose>
        <c:when test="${isLiked}">
          <form action="${pageContext.request.contextPath}/board/removeInteraction" method="post" style="display:inline">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="boardNum" value="${detail.boardNum}" />
            <button type="submit" class="heart-btn">❤️</button>
          </form>
        </c:when>
        <c:otherwise>
          <form action="${pageContext.request.contextPath}/board/addInteraction" method="post" style="display:inline">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="boardNum" value="${detail.boardNum}" />
            <button type="submit" class="heart-btn">🤍</button>
          </form>
        </c:otherwise>
      </c:choose>
      <span>좋아요 : ${likeCount}</span>
    </div>

    <hr />

    <!-- 비밀글 비밀번호 입력 폼 -->
    <c:choose>
      <c:when test="${detail.isSecret && !canRead}">
        <div class="secret-alert" style="color:#d32f2f; margin-bottom:14px;">
          비밀글입니다. 비밀번호를 입력하세요.
        </div>
        <form class="secret-form" method="post" action="${pageContext.request.contextPath}/board/detail">
          <input type="hidden" name="boardNum" value="${detail.boardNum}" />
          <input type="password" name="inputPassword" placeholder="비밀번호" required />
          <button type="submit">확인</button>
        </form>
        <c:if test="${not empty secretError}">
          <div class="secret-alert" style="color:#d32f2f;">${secretError}</div>
        </c:if>
      </c:when>

      <c:otherwise>
        <div class="content">
          <c:out value="${detail.boardContents}" />
        </div>

        <c:if test="${not empty files}">
          <div class="files">
            <strong>첨부파일:</strong>
            <c:forEach var="f" items="${files}">
              <a href="${pageContext.request.contextPath}/board/fileDown?fileNum=${f.fileNum}">${f.oldName}</a>
            </c:forEach>
          </div>
          <hr />
        </c:if>

        <!-- 댓글 섹션 -->
        <div class="comments">
          <div class="comment-header">
            <h3>댓글 (<c:out value="${comments.size()}" />)</h3>
          </div>

          <ul class="comment-list">
            <c:forEach var="cmt" items="${comments}">
              <li class="comment-item" data-depth="${cmt.commentDepth}">
                <div class="comment-meta">
                  <strong><c:out value="${cmt.userName}" /></strong> &nbsp;|&nbsp;
                  <fmt:formatDate value="${cmt.commentDate}" pattern="yyyy-MM-dd HH:mm" />
                </div>
                <div class="comment-body">
                  <c:out value="${cmt.commentContents}" />
                </div>

                <c:if test="${userName != null}">
                  <button type="button" class="reply-btn" onclick="toggleReplyForm(${cmt.commentNum})">답글 쓰기</button>

                  <form id="replyForm-${cmt.commentNum}" class="reply-form" action="${pageContext.request.contextPath}/board/addReplyComment" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="boardNum" value="${detail.boardNum}" />
                    <input type="hidden" name="parentCommentNum" value="${cmt.commentNum}" />
                    <input type="hidden" name="commentDepth" value="${cmt.commentDepth + 1}" />
                    <textarea name="commentContents" placeholder="답글을 입력하세요" required></textarea>
                    <button type="submit">답글 등록</button>
                  </form>
                </c:if>

                <c:if test="${userName == cmt.userName || (roleList != null && fn:contains(roleList, 'ADMIN'))}">
                  <div class="comment-actions">
                    <form action="${pageContext.request.contextPath}/board/updateComment" method="post" style="display:inline;">
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      <input type="hidden" name="commentNum" value="${cmt.commentNum}" />
                      <button type="submit">수정</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/board/deletecomment" method="post" style="display:inline;" onsubmit="return confirm('댓글을 삭제하시겠습니까?');">
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      <input type="hidden" name="commentNum" value="${cmt.commentNum}" />
                      <input type="hidden" name="boardNum" value="${detail.boardNum}" />
                      <button type="submit">삭제</button>
                    </form>
                  </div>
                </c:if>
              </li>
            </c:forEach>
          </ul>

          <!-- 댓글 입력폼: 스타일 변경한 부분만 수정 -->
          <form id="commentForm" action="${pageContext.request.contextPath}/board/addComment" method="post" style="margin-top:16px;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="boardNum" value="${detail.boardNum}" />
            <textarea name="commentContents" placeholder="댓글을 입력하세요" required
                      style="width:100%; height:80px; padding:8px; border:1px solid #ccc; border-radius:4px; font-size:14px; resize: vertical; box-sizing: border-box;"></textarea>
            <button type="submit"
                    style="margin-top:8px; padding:8px 16px; background:#2663eb; color:#fff; border:none; border-radius:4px; cursor:pointer; font-weight:bold; transition: background-color 0.2s ease;">
              댓글 작성
            </button>
          </form>
        </div>
      </c:otherwise>
    </c:choose>

    <!-- 수정, 삭제 버튼 영역 -->
    <div class="actions">
      <a href="${pageContext.request.contextPath}/board/list" class="list-btn">목록</a>
      <c:if test="${isOwnerOrAdmin}">
        <a href="${pageContext.request.contextPath}/board/update?boardNum=${detail.boardNum}" class="edit-btn">수정</a>
        <form action="${pageContext.request.contextPath}/board/delete" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
          <input type="hidden" name="boardNum" value="${detail.boardNum}" />
          <button type="submit" class="delete-btn">삭제</button>
        </form>
      </c:if>
    </div>

    <input type="hidden" id="boardNum" value="${detail.boardNum}" />
  </div>

  <script>
    // 답글 폼 토글 함수
    function toggleReplyForm(commentNum) {
      const form = document.getElementById('replyForm-' + commentNum);
      if (form.style.display === 'block') {
        form.style.display = 'none';
      } else {
        // 모든 답글 폼 닫기
        document.querySelectorAll('form.reply-form').forEach(f => f.style.display = 'none');
        form.style.display = 'block';
      }
    }

    // 조회수 비동기 업데이트
    document.addEventListener('DOMContentLoaded', () => {
      const url = '${hitUrl}';
      const boardNum = document.getElementById('boardNum').value;
      const csrfMeta = document.querySelector('meta[name="_csrf"]');
      const csrfHeader = document.querySelector('meta[name="_csrf_header"]');
      const token = csrfMeta ? csrfMeta.content : '';
      const header = csrfHeader ? csrfHeader.content : 'X-CSRF-TOKEN';
      if (!boardNum) return;

      fetch(url, {
        method: 'POST',
        credentials: 'same-origin',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
          [header]: token
        },
        body: 'boardNum=' + encodeURIComponent(boardNum)
      })
      .then(res => res.ok ? res.text() : Promise.reject(res.status))
      .then(count => {
        document.getElementById('viewCount').textContent = count;
      })
      .catch(err => console.error('조회수 업데이트 실패:', err));
    });
  </script>
</body>
</html>
