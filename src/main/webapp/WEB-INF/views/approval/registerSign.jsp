<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>서명/도장 등록</title>
	<c:import url="/WEB-INF/views/templates/header.jsp" />
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
	<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
	<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body class="sb-nav-fixed d-flex flex-column min-vh-100">
	<c:import url="/WEB-INF/views/templates/topbar.jsp" />
	<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp" />
		<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
			<main class="flex-grow-1">
				<div class="container mt-4">
					<!-- 페이지 제목 -->
					<h3 class="mb-4 border-bottom pb-2 fw-bold"><i class="bi bi-pencil-square me-2"></i>서명/도장 등록</h3>

					<!-- 선택 버튼 -->
					<div class="mb-4">
						<button id="sign" class="btn btn-light me-2 text-dark">
							<i class="bi bi-pencil-fill me-1"></i>서명 등록
						</button>
						<button id="stamp" class="btn btn-light text-dark">
							<i class="bi bi-image-fill me-1"></i>도장 등록
						</button>
					</div>

					<!-- 서명 패드 또는 도장 영역 -->
					<div id="signPad" class="mb-4"></div>

					<!-- 서명 저장용 폼 -->
					<form id="signatureForm" action="./saveSign" method="post">
						<input type="hidden" name="imageData" id="imageData">
					</form>

					<!-- 도장 업로드 폼 -->
					<form id="stampForm" action="./saveStamp" method="post" enctype="multipart/form-data"></form>
				</div>
			</main>
			<c:import url="/WEB-INF/views/templates/footer.jsp" />
		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="/js/approval/registerSign.js"></script>
</body>
</html>
