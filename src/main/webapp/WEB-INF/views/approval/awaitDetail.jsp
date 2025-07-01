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
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
		<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
		<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
        <style>
            th, td {
                border: 1px solid #000000;
            }
        </style>
	</head>
	<body class="sb-nav-fixed d-flex flex-column min-vh-100">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
                    <div class="container">
							<!-- contents -->
                        <div class="container mt-4">
                            <h2 class="mb-4"><i class="bi bi-file-earmark-text me-2"></i>승인 문서 상세</h2>

                            <input id="approvalId" type="hidden" value="${vo.approvalId}">
                            <input id="documentId" type="hidden" value="${vo.documentId}">

                            <div class="card shadow-sm rounded p-4 mb-4">
                                <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">요청자</label>
                                    <input  type="text" class="form-control" value="${vo.documentVO.userVO.name}(${vo.documentVO.writerId})" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">종류</label>
                                    <input type="text" class="form-control" value="${vo.documentVO.formVO.formTitle}" readonly>
                                </div>
                                </div>

                                <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">제목</label>
                                    <input type="text" class="form-control" value="${vo.documentVO.documentTitle}" readonly>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold">문서 상태</label>
                                    <div>
                                    <c:choose>
                                        <c:when test="${vo.documentVO.documentStatus eq 'D1'}">
                                        <span class="badge bg-success fs-6">승인</span>
                                        </c:when>
                                        <c:when test="${vo.documentVO.documentStatus eq 'D2'}">
                                        <span class="badge bg-danger fs-6">반려</span>
                                        </c:when>
                                        <c:otherwise>
                                        <span class="badge bg-secondary fs-6">진행중</span>
                                        </c:otherwise>
                                    </c:choose>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold">승인 여부</label>
                                    <div>
                                    <c:choose>
                                        <c:when test="${vo.approvalStatus eq 'AS1'}">
                                        <span class="badge bg-primary fs-6">승인</span>
                                        </c:when>
                                        <c:otherwise>
                                        <span class="badge bg-warning text-dark fs-6">미승인</span>
                                        </c:otherwise>
                                    </c:choose>
                                    </div>
                                </div>
                                </div>
                            </div>

                            <div class="card p-4 shadow-sm mb-4">
                                <h5 class="fw-bold mb-3"><i class="bi bi-journal-text me-2"></i>문서 내용</h5>
                                <div id="contentHtml" class="border rounded p-3 bg-white">
                                ${vo.documentVO.contentHtml}
                                </div>
                            </div>

                            <div data-writerId="${vo.documentVO.writerId}" id="appOrRej" class="d-flex flex-wrap gap-2">
                                <button class="btn btn-outline-dark" id="uploadSign"><i class="bi bi-pen me-1"></i>서명/도장 기입</button>
                                <a class="btn btn-outline-secondary" href="./registerSign"><i class="bi bi-pencil-square me-1"></i>서명/도장 등록</a>
                                <button class="btn btn-danger ms-auto" id="rejection"><i class="bi bi-x-circle me-1"></i>반려</button>
                            </div>
                            </div>


    





					
					</div>
				</main>
                <c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
					
	
	
	
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/approval/awaitDetail.js"></script>
	</body>
</html>