<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>새 게시글 등록</title>
  <style>
    /* 전체 레이아웃 */
    body {
      margin: 0;
      padding: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f4f7f8;
      color: #333;
    }
    .container {
      width: 700px;
      margin: 40px auto;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      overflow: hidden;
    }
    .header {
      background: #007bff;
      color: #fff;
      padding: 20px;
      text-align: center;
      font-size: 24px;
      font-weight: bold;
    }

    form {
      padding: 30px;
    }
    .form-group {
      margin-bottom: 20px;
    }
    .form-group label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      font-size: 16px;
    }
    .form-group input[type="text"],
    .form-group input[type="password"],
    .form-group select,
    .form-group textarea {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid #ccd0d5;
      border-radius: 4px;
      font-size: 16px;
      box-sizing: border-box;
      transition: border-color .2s;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
      border-color: #007bff;
      outline: none;
    }
    .note {
      font-size: 14px;
      color: #666;
      margin-top: 6px;
    }
    #secretRow {
      display: none;
    }
    .actions {
      display: flex;
      justify-content: flex-end;
      gap: 12px;
      margin-top: 30px;
    }
    .btn {
      padding: 10px 24px;
      font-size: 16px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      text-align: center;
    }
    .btn-primary {
      background: #007bff;
      color: #fff;
    }
    .btn-secondary {
      background: #6c757d;
      color: #fff;
    }
    .btn-primary:hover {
      background: #0056b3;
    }
    .btn-secondary:hover {
      background: #565e64;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <c:choose>
        <c:when test="${empty boardVO.boardNum}">새 게시글 등록</c:when>
        <c:otherwise>게시글 수정</c:otherwise>
      </c:choose>
    </div>
    <form action="<c:url value='/board/add'/>" method="post" enctype="multipart/form-data">
      <div class="form-group">
        <label for="title">제목</label>
        <input id="title" type="text" name="boardTitle" required placeholder="제목을 입력하세요" />
      </div>
      <div class="form-group">
        <label for="category">카테고리</label>
        <select id="categorySelect" name="category">
          <option value="1">일반게시판</option>
          <option value="2">Q&amp;A</option>
        </select>
      </div>
      <div class="form-group">
        <label for="content">내용</label>
        <textarea id="content" name="boardContents" rows="8" required placeholder="내용을 입력하세요"></textarea>
      </div>
      <div class="form-group">
        <label>첨부파일</label>
        <input type="file" name="files" multiple />
        <p class="note">최대 5개까지 업로드 가능합니다.</p>
      </div>
      <div class="form-group" id="secretRow">
        <label>
          <input type="checkbox" name="isSecret" value="1" />
          비밀글로 등록
        </label>
        <input type="password" name="secretPassword" placeholder="비밀번호 입력(필수)" style="margin-top:8px;" />
      </div>
      <div class="actions">
        <a href="<c:url value='/board/list'/>" class="btn btn-secondary">취소</a>
        <button type="submit" class="btn btn-primary">등록</button>
      </div>
    </form>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', function(){
      var sel = document.getElementById('categorySelect');
      var secretRow = document.getElementById('secretRow');
      function toggleSecret() {
        secretRow.style.display = (sel.value === '2') ? 'block' : 'none';
      }
      toggleSecret();
      sel.addEventListener('change', toggleSecret);
    });
  </script>
</body>
</html>
