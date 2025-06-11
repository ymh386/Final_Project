<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"    %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"     %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시글 상세</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    .meta { color: #666; margin-bottom: 10px; }
    .content { white-space: pre-wrap; margin-bottom: 20px; }
    .files, .comments { margin-bottom: 20px; }
    .files div, .comments div { margin-bottom: 5px; }
    .actions button, .actions a { margin-right: 8px; }
    #commentArea { width: 100%; height: 60px; }
  </style>
</head>
<body>

  <h2><c:out value="${detail.boardTitle}"/></h2>
  <div class="meta">
    작성자: <c:out value="${detail.userName}"/> |
    작성일: <fmt:formatDate value="${detail.boardDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
  </div>

  <div class="actions">
    <!-- 좋아요/취소 토글 -->
    좋아요 (<span id="likeCount">${likeCount}</span>)
    <c:choose>
      <c:when test="${isLiked}">
        <button id="unlikeBtn">좋아요 취소</button>
      </c:when>
      <c:otherwise>
        <button id="likeBtn">좋아요</button>
      </c:otherwise>
    </c:choose>
  </div>

  <hr/>

  <div class="content">
    <c:out value="${detail.boardContents}"/>
  </div>

  <c:if test="${not empty files}">
    <div class="files">
      <strong>첨부파일:</strong>
      <c:forEach var="f" items="${files}">
        <div>
          <a href="<c:url value='/board/fileDown'>
                     <c:param name='fileNum' value='${f.fileNum}'/>
                   </c:url>">
            <c:out value="${f.oriName}"/>
          </a>
        </div>
      </c:forEach>
    </div>
  </c:if>

  <hr/>

  <div class="comments">
    <strong>댓글:</strong>
    <c:forEach var="cmt" items="${comments}">
      <div>
        <strong><c:out value="${cmt.userName}"/></strong>
        &nbsp;|&nbsp;
        <fmt:formatDate value="${cmt.commentDate}" pattern="yyyy-MM-dd HH:mm"/>
        <br/>
        <c:out value="${cmt.commentContents}"/>
      </div>
    </c:forEach>
  </div>

  <!-- 댓글 작성 -->
  <div>
    <textarea id="commentArea" placeholder="댓글을 입력하세요"></textarea><br/>
    <button id="addCommentBtn">댓글 작성</button>
  </div>

  <hr/>

  <div class="actions">
    <a href="<c:url value='/board/list'/>">목록</a>
    <!-- 수정/삭제 버튼은 작성자 자신일 때만 보여주세요 -->
    <c:if test="${detail.userName == sessionScope.userName}">
      <a href="<c:url value='/board/update'>
                 <c:param name='boardNum' value='${detail.boardNum}'/>
               </c:url>">수정</a>
      <a href="<c:url value='/board/delete'>
                 <c:param name='boardNum' value='${detail.boardNum}'/>
               </c:url>"
         onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
    </c:if>
  </div>

  <!-- (필요시 AJAX 스크립트 추가) -->

</body>
</html>
