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
	</head>
	<body class="sb-nav-fixed d-flex flex-column min-vh-100">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
			<main class="flex-grow-1 d-flex justify-content-center align-items-center gap-5 px-4">
			<!-- 첫 번째 카드 -->
			<div class="card" style="width: 18rem;">
				<img src="/img/member.png" class="card-img-top" alt="…">
				<div class="card-body">
				<h5 class="card-title">일반 회원 가입</h5>
				<p class="card-text">일반 회원</p>
				<a href="/user/join/memberJoin" class="btn btn-primary">가입</a>
				</div>
			</div>

			<!-- 두 번째 카드 -->
			<div class="card" style="width: 18rem;">
				<img src="/img/trainer.png" class="card-img-top" alt="…">
				<div class="card-body justify-content-center">
				<h5 class="card-title">트레이너 가입</h5>
				<p class="card-text">트레이너, 강사, 코치</p>
				<a href="/user/join/trainerJoin" class="btn btn-primary">가입</a>
				</div>
			</div>
			</main>


			</div>
		</div>
					
	
	
	
	
		<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
		</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>