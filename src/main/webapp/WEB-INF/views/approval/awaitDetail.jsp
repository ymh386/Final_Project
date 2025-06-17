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

                        <h2>승인</h2><br>
                        <div class="mb-3">
                            <input id="approvalId" type="hidden" value="${vo.approvalId}">
                            <input id="documentId" type="hidden" value="${vo.documentId}">
                            <label class="form-label">요청자</label>
                            <input id="writerId" type="text" class="form-control" value="${vo.documentVO.writerId}" readonly>
                            <label class="form-label">종류</label>
                            <input type="text" class="form-control" value="${vo.documentVO.formVO.formTitle}" readonly>
                            <label class="form-label">제목</label>
                            <input type="text" class="form-control" value="${vo.documentVO.documentTitle}" readonly>
                            <label class="form-label">문서 상태</label>
                            <c:choose>
                                <c:when test="${vo.documentVO.documentStatus eq 'D1'}">
                                    <input type="text" class="form-control" value="승인" readonly style="color: blue;">
                                </c:when>
                                <c:when test="${vo.documentVO.documentStatus eq 'D2'}">
                                    <input type="text" class="form-control" value="반려" readonly style="color: red;">
                                </c:when>
                                <c:otherwise>
                                    <input type="text" class="form-control" value="진행중" readonly>
                                </c:otherwise>
                            </c:choose>
                            <label class="form-label">승인 여부</label>
                            <c:choose>
                                <c:when test="${vo.approvalStatus eq 'AS1'}">
                                    <input type="text" class="form-control" value="승인" readonly>
                                </c:when>
                                <c:otherwise>
                                    <input type="text" class="form-control" value="미승인" readonly>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div id="contentHtml">
                            ${vo.documentVO.contentHtml}
                        </div>

                        <div class="mb-3">
                            <div class="row">
                                <button class="btn" id="uploadSign">서명/도장 기입</button>
                                <a class="btn" href="./registerSign" class="button">서명/도장 등록</a>
                            </div>
                            <div id="appOrRej" class="row">
                                <button class="btn" id="rejection">반려</button>
                            </div>
                        </div>

    





					<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
					</div>
				</main>
			</div>
		</div>
					
	
	
	
	
		<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
		</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/approval/awaitDetail.js"></script>
	</body>
</html>