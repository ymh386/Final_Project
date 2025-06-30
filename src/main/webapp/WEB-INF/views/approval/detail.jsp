<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
<head>
    <meta charset="UTF-8">
    <title>승인 내역 상세</title>
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
                <div class="container mt-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-secondary text-white">
                            <h4 class="mb-0"><i class="bi bi-journal-check me-2"></i>승인 내역 상세</h4>
                        </div>

                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">요청자</label>
                                    <input type="text" class="form-control" value="${vo.documentVO.userVO.name}(${vo.documentVO.writerId})" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">문서 양식</label>
                                    <input type="text" class="form-control" value="${vo.documentVO.formVO.formTitle}" readonly>
                                </div>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">문서 제목</label>
                                    <input type="text" class="form-control" value="${vo.documentVO.documentTitle}" readonly>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold">문서 상태</label>
                                    <c:choose>
                                        <c:when test="${vo.documentVO.documentStatus eq 'D1'}">
                                            <div class="form-control bg-light text-primary"><i class="bi bi-check-circle-fill"></i> 승인</div>
                                        </c:when>
                                        <c:when test="${vo.documentVO.documentStatus eq 'D2'}">
                                            <div class="form-control bg-light text-danger"><i class="bi bi-x-circle-fill"></i> 반려</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="form-control bg-light text-secondary"><i class="bi bi-hourglass-split"></i> 진행중</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold">승인 여부</label>
                                    <c:choose>
                                        <c:when test="${vo.approvalStatus eq 'AS1'}">
                                            <div class="form-control bg-light text-success"><i class="bi bi-hand-thumbs-up-fill"></i> 승인</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="form-control bg-light text-danger"><i class="bi bi-hand-thumbs-down-fill"></i> 반려</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold">문서 내용</label>
                                <div class="border p-3 rounded bg-light">
                                    ${vo.documentVO.contentHtml}
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
</body>
</html>
