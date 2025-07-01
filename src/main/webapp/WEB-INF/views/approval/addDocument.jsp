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

  #selectedApprovers button {
    margin-left: 5px;
  }
  #selectedApprovers li {
    margin-bottom: 5px;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  label {
            font-weight: 600;
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
        <div class="container-fluid py-4">
          <div class="row">
            <!-- 왼쪽 사이드바 -->
            <div class="col-md-3">
              <div class="sticky-top" style="top: 80px; right: 0; position: sticky;">
                <!-- 조직도 카드 -->
                <div class="card mb-3 ms-3">
                  <div class="card-header bg-light">
                    <strong>조직도</strong>
                  </div>
                  <div class="card-body">
                    <div id="line" style="max-height: 300px; overflow-y: auto;"></div>
                    <button id="addToApprovalLine" class="btn btn-outline-primary btn-sm mt-2 w-100">
                      <i class="bi bi-plus-circle"></i> 결재라인에 추가
                    </button>
                  </div>
                </div>

                <!-- 결재라인 카드 -->
                <div class="card ms-3">
                  <div class="card-header bg-light">
                    <strong>결재라인</strong>
                  </div>
                  <div class="card-body p-2" style="max-height: 300px; overflow-y: auto;">
                    <ol id="selectedApprovers" class="list-group list-group-numbered small"></ol>
                  </div>
                </div>
              </div>
            </div>

            <!-- 오른쪽 작성영역 -->
            <div class="col-md-9">
              <div class="card shadow-sm">
                <div class="card-header bg-secondary text-white">
                  <h5 class="mb-0">전자결재 작성</h5>
                </div>
                <sec:authentication property="principal" var="user"/>
                <div class="card-body">
                  <form id="documentForm" action="./addDocument" method="post" class="card p-4 shadow-sm">
    
                    <!-- 카테고리 선택 -->
                    <div class="mb-3 row align-items-center">
                      <label for="formSelect" class="col-sm-3 col-form-label fw-semibold">결재 양식</label>
                      <div class="col-sm-9">
                        <select id="formSelect" name="formId" class="form-select" required>
                          <option value="" selected disabled>-- 양식 선택 --</option>
                          <c:forEach var="f" items="${ar}">
                            <option value="${f.formId}">${f.formTitle}</option>
                          </c:forEach>
                        </select>
                      </div>
                    </div>
                    
                    <!-- 제목 -->
                    <div class="mb-3 row align-items-center">
                      <label for="documentTitle" class="col-sm-3 col-form-label fw-semibold">제목</label>
                      <div class="col-sm-9">
                        <input type="text" name="documentTitle" id="documentTitle" class="form-control" placeholder="문서 제목을 입력하세요" required>
                      </div>
                    </div>
                    
                    <!-- 요청자 -->
                    <div class="mb-3 row align-items-center">
                      <label class="col-sm-3 col-form-label fw-semibold">요청자</label>
                      <div class="col-sm-9">
                        <input type="text" class="form-control" value="${user.name}" readonly>
                      </div>
                    </div>
                    
                    <!-- 내용 (CKEditor) -->
                    <div class="mb-4">
                      <label for="editor" class="form-label fw-semibold">내용</label>
                      <textarea name="contentHtml" id="editor" class="form-control" rows="15"></textarea>
                    </div>
                    
                    <input type="hidden" name="approvalLineJson" id="approvalLineJson">
                    
                    <button type="submit" class="btn btn-secondary w-100">결재 요청하기</button>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
      <c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/js/approval/addDocument.js"></script>
</body>
</html>
