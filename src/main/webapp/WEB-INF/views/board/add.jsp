<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>
    <c:choose>
      <c:when test="${empty boardVO.boardNum}">새 게시글 등록</c:when>
      <c:otherwise>게시글 수정</c:otherwise>
    </c:choose>
  </title>
  <style>
    table { width: 600px; border-collapse: collapse; }
    th, td { padding: 8px; text-align: left; vertical-align: top; }
    th { width: 120px; background: #f0f0f0; }
    textarea { width: 100%; }
    .actions { text-align: right; margin-top: 16px; }
    .actions button, .actions a { margin-left: 8px; }
  </style>
</head>
<body>

  <c:url var="addAction"    value="/board/add"   />
  <c:url var="updateAction" value="/board/update"/>
  <c:url var="listUrl"      value="/board/list"  />

  <h2>
    <c:choose>
      <c:when test="${empty boardVO.boardNum}">새 게시글 등록</c:when>
      <c:otherwise>게시글 수정</c:otherwise>
    </c:choose>
  </h2>

  <form action="${empty boardVO.boardNum ? addAction : updateAction}"
        method="post" enctype="multipart/form-data">

    <!-- 수정일 때만 boardNum 전달 -->
    <c:if test="${not empty boardVO.boardNum}">
      <input type="hidden" name="boardNum" value="${boardVO.boardNum}" />
    </c:if>

    <table>
      <tr>
        <th>제목</th>
        <td>
          <input type="text" name="boardTitle"
                 value="${boardVO.boardTitle}" required style="width:100%;" />
        </td>
      </tr>
      <tr>
        <th>카테고리</th>
        <td>
          <select name="category">
            <option value="1" ${boardVO.category==1?'selected':''}>일반게시판</option>
            <option value="2" ${boardVO.category==2?'selected':''}>Q&amp;A</option>
          </select>
        </td>
      </tr>
      <tr>
        <th>내용</th>
        <td>
          <textarea name="boardContents" rows="10" required>${boardVO.boardContents}</textarea>
        </td>
      </tr>
      <tr>
        <th>첨부파일</th>
        <td>
          <input type="file" name="files" multiple="multiple" />
          <p>최대 5개까지 업로드 가능합니다.</p>
        </td>
      </tr>
      <c:if test="${boardVO.category == 2}">
        <tr>
          <th>비밀글</th>
          <td>
            <label>
              <input type="checkbox" name="isSecret" value="1"
                     ${boardVO.isSecret==1?'checked':''} />
              비밀글로 등록
            </label><br/>
            <input type="password" name="secretPassword"
                   placeholder="비밀번호 입력(필수)" />
          </td>
        </tr>
      </c:if>
    </table>

    <div class="actions">
      <c:choose>
        <c:when test="${empty boardVO.boardNum}">
          <button type="submit">등록</button>
        </c:when>
        <c:otherwise>
          <button type="submit">수정</button>
        </c:otherwise>
      </c:choose>
      <a href="${listUrl}">취소</a>
    </div>

  </form>
</body>
</html>
