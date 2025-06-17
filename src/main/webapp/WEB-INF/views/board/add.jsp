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
      font-family: 'Pretendard', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(120deg, #eef3f7 0%, #f0e9f7 100%);
      color: #272a31;
      min-height: 100vh;
    }
    .container {
      width: 100%;
      max-width: 540px;
      margin: 48px auto 0 auto;
      background: #fff;
      border-radius: 18px;
      box-shadow: 0 8px 32px rgba(68,94,221,0.10), 0 1.5px 6px rgba(0,0,0,0.07);
      overflow: hidden;
      animation: fadeInUp 0.6s cubic-bezier(.19,1,.22,1);
    }
    @keyframes fadeInUp {
      from { transform: translateY(60px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }
    .header {
      background: linear-gradient(90deg, #5575e7 0%, #7a60ee 100%);
      color: #fff;
      padding: 30px 0 22px 0;
      text-align: center;
      font-size: 26px;
      font-weight: 700;
      letter-spacing: -1px;
      border-bottom: 1.5px solid #f3f3f5;
    }

    form {
      padding: 36px 36px 28px 36px;
      background: #fff;
    }
    .form-group {
      margin-bottom: 23px;
    }
    .form-group label {
      display: block;
      margin-bottom: 9px;
      font-weight: 600;
      font-size: 15.5px;
      color: #1a194d;
      letter-spacing: -0.5px;
    }
    .form-group input[type="text"],
    .form-group input[type="password"],
    .form-group select,
    .form-group textarea {
      width: 100%;
      padding: 13px 14px;
      border: 1.5px solid #e4e7ee;
      border-radius: 8px;
      font-size: 15px;
      box-sizing: border-box;
      transition: border-color .18s, box-shadow .18s;
      background: #f8fafc;
      color: #22263c;
      outline: none;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
      border-color: #5575e7;
      box-shadow: 0 2px 7px 0 rgba(68,94,221,0.07);
    }
    .form-group textarea {
      min-height: 120px;
      resize: vertical;
    }
    .note {
      font-size: 13.5px;
      color: #959ab5;
      margin-top: 5px;
      margin-left: 2px;
      font-style: italic;
    }
    #secretRow {
      display: none;
      background: #f5f8ff;
      padding: 18px 14px 10px 14px;
      border-radius: 8px;
      border: 1.5px solid #e7eaf3;
      margin-top: 4px;
      box-shadow: 0 1px 4px 0 rgba(85,117,231,0.05);
    }
    #secretRow label {
      font-weight: 600;
      color: #485087;
    }
    #secretRow input[type="checkbox"] {
      accent-color: #6e79ea;
      margin-right: 7px;
      transform: scale(1.13);
    }
    #secretRow input[type="password"] {
      margin-top: 10px;
      border-radius: 6px;
      border: 1.5px solid #d9dcf0;
      font-size: 15px;
    }

    .actions {
      display: flex;
      justify-content: flex-end;
      gap: 13px;
      margin-top: 34px;
    }
    .btn {
      padding: 11px 30px;
      font-size: 16px;
      border: none;
      border-radius: 7px;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      text-align: center;
      font-weight: 600;
      letter-spacing: -0.5px;
      transition: background .15s, box-shadow .15s, color .13s;
      box-shadow: 0 2px 6px 0 rgba(85,117,231,0.04);
    }
    .btn-primary {
      background: linear-gradient(90deg, #5575e7 0%, #7a60ee 100%);
      color: #fff;
      box-shadow: 0 2px 12px 0 rgba(85,117,231,0.11);
    }
    .btn-secondary {
      background: #e3e7f3;
      color: #48649c;
    }
    .btn-primary:hover {
      background: linear-gradient(90deg, #4261d8 0%, #5c4acc 100%);
      color: #fff;
      box-shadow: 0 3px 15px 0 rgba(85,117,231,0.15);
    }
    .btn-secondary:hover {
      background: #cfd4e7;
      color: #2b3b68;
    }
    /* 파일 업로드 디자인 보완 */
    .form-group input[type="file"] {
      background: #f8fafc;
      border: 1.2px solid #e0e0ed;
      padding: 9px 7px;
      font-size: 15px;
      border-radius: 6px;
      margin-top: 2px;
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
