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

			.doc-box {
				border: 1px solid #ccc;
				background: #fff;
				padding: 30px;
				margin-top: 20px;
			}
			.doc-header {
				border-bottom: 2px solid #000;
				padding-bottom: 10px;
				margin-bottom: 20px;
			}
			.doc-title {
				font-size: 1.5rem;
				font-weight: bold;
			}
			.doc-meta {
				font-size: 0.9rem;
				color: #555;
			}
			.doc-body {
				min-height: 300px;
				padding: 15px;
				border: 1px solid #dee2e6;
				background: #fdfdfd;
			}
			.doc-footer {
				margin-top: 30px;
				text-align: right;
			}
			.approval-line {
				border: 1px dashed #999;
				padding: 10px;
				margin-top: 20px;
				background: #f8f9fa;
			}
			.approval-line span {
				display: inline-block;
				width: 120px;
				text-align: center;
				font-weight: bold;
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
						<div class="container py-4">
							<sec:authentication property="principal" var="user"/>
							<div class="doc-box shadow-sm">
                        
								<!-- 헤더: 제목 및 정보 -->
								<div class="doc-header">
									<div class="doc-title">결재양식: ${vo.formTitle}</div>
									<div class="doc-meta">
										<span>양식번호: ${vo.formId}</span> |
										<span>작성일: ${vo.createdAt}</span>
									</div>
								</div>

								<!-- 본문 -->
								<div class="doc-body">
									${vo.contentHtml}
								</div>

								<!-- 버튼 -->
								<div class="doc-footer text-end mt-4">
									<a href="/approval/admin/formUpdate?formId=${vo.formId}"
									class="btn btn-outline-secondary me-2">
										<i class="bi bi-pencil-square"></i> 양식 수정
									</a>
									<a href="/approval/admin/formDelete?formId=${vo.formId}"
									class="btn btn-outline-danger"
									onclick="return confirm('정말로 이 양식을 삭제하시겠습니까?');">
										<i class="bi bi-trash"></i> 삭제하기
									</a>
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