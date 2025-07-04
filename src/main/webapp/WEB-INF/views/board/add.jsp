<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko" class="fontawesome-i2svg-active fontawesome-i2svg-complete">
<head>
  <meta charset="UTF-8">
  <title>게시글 등록</title>
  <c:import url="/WEB-INF/views/templates/header.jsp"/>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    body { font-family: 'Pretendard', 'Segoe UI', sans-serif; background: #f5f7fa; color: #333; }
    .form-wrap {
      max-width: 700px;
      margin: 40px auto;
      background: #fff;
      padding: 36px 40px;
      border-radius: 14px;
      box-shadow: 0 8px 30px rgba(0,0,0,0.05);
    }
    .form-wrap h2 {
      font-size: 1.8rem;
      font-weight: 700;
      margin-bottom: 30px;
      text-align: center;
    }
    .form-group { margin-bottom: 22px; }
    .form-group label { display: block; margin-bottom: 8px; font-weight: 600; }
    .form-group input[type="text"],
    .form-group input[type="password"],
    .form-group select,
    .form-group textarea {
      width: 100%; padding: 12px 14px;
      border: 1px solid #ccc; border-radius: 6px;
      font-size: 15px; background: #f9f9fc;
    }
    .form-group textarea { min-height: 140px; resize: vertical; }
    .form-group input[type="file"] { margin-top: 8px; }
    #secretRow { display: none; padding-top: 10px; }
    .actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 30px; }
    .btn {
      padding: 10px 24px; border: none; border-radius: 6px; font-size: 15px;
      font-weight: 600; cursor: pointer; transition: all 0.2s ease;
    }
    .btn-primary { background: #546de5; color: white; }
    .btn-secondary { background: #dcdde1; color: #2f3640; }
    .btn-primary:hover { background: #3d56c1; }
    .btn-secondary:hover { background: #c8ccd3; }
  </style>
</head>
<body class="sb-nav-fixed d-flex flex-column min-vh-100">
  <c:import url="/WEB-INF/views/templates/topbar.jsp"/>
  <div id="layoutSidenav" class="d-flex flex-grow-1">
    <c:import url="/WEB-INF/views/templates/sidebar.jsp"/>
    <div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
      <main class="flex-grow-1">
        <div class="form-wrap">
          <h2>
            <c:choose>
              <c:when test="${empty boardVO.boardNum}">새 게시글 등록</c:when>
              <c:otherwise>게시글 수정</c:otherwise>
            </c:choose>
          </h2>
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
              <small style="display:block; margin-top:4px; color:#888">최대 5개까지 업로드 가능합니다.</small>
            </div>
            <div class="form-group" id="secretRow">
              <label>
                <input type="checkbox" name="isSecret" value="1" /> 비밀글로 등록
              </label>
              <input type="password" name="secretPassword" placeholder="비밀번호 입력(필수)" />
            </div>
            <div class="actions">
              <a href="<c:url value='/board/list'/>" class="btn btn-secondary">취소</a>
              <button type="submit" class="btn btn-primary">등록</button>
            </div>
          </form>
        </div>
      </main>
      <c:import url="/WEB-INF/views/templates/footer.jsp"/>
    </div>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', function(){
      const sel = document.getElementById('categorySelect');
      const secretRow = document.getElementById('secretRow');
      function toggleSecret() {
        secretRow.style.display = (sel.value === '2') ? 'block' : 'none';
      }
      toggleSecret();
      sel.addEventListener('change', toggleSecret);
    });
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
