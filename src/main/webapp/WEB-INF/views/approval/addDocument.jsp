<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>

<style>
  .sports-topbar { 
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    right: 0 !important;
    height: 64px !important;
    border-bottom: 4px solid #ffe600 !important;
    margin-top: 0 !important;
    box-shadow: none !important;
    z-index: 1100 !important;
  }
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
</head>
<body class="sb-nav-fixed d-flex flex-column min-vh-100">
  <c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
  <div id="layoutSidenav" class="d-flex flex-grow-1">
    <c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
    <div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
      <main class="flex-grow-1">
        <div class="container">
          <!-- contents -->
          <h2>전자결재 작성</h2>
          <sec:authentication property="principal" var="user"/>
          <form id="documentForm" action="./addDocument" method="post">
            <label>카테고리</label><br>
            <select id="formSelect" name="formId">
              <option selected>-- 양식 선택 --</option>
              <c:forEach var="f" items="${ar}">
                <option value="${f.formId}">${f.formTitle}</option>
              </c:forEach>
            </select><br><br>

            <label>제목</label>
            <input type="text" name="documentTitle"><br><br>
            <label>요청자</label>
            <input type="text" value="${user.name}" readonly><br><br>

            <!-- CKEditor 내용 -->
            <label for="editor">내용</label><br>
            <div id="content">
              <textarea name="contentHtml" id="editor"></textarea><br><br>
            </div>

            <input type="hidden" name="approvalLineJson" id="approvalLineJson">

            <button type="submit">결재 요청</button>
          </form>

          <!-- 결재라인 선택 (트리 리스트) -->
          <label>조직도</label>
          <div id="line"></div><button id="addToApprovalLine">결재라인에 추가</button><br><br>

          <label>결재라인</label>
          <ol id="selectedApprovers"></ol><br><br>

          <c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
        </div>
      </main>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/js/approval/addDocument.js"></script>
</body>
</html>
