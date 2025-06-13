<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
	<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
		<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
	</head>
	<body class="sb-nav-fixed d-flex flex-column min-vh-100">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1" style="padding-top: 20px;">
                <main class="flex-grow-1">
                    <div class="container">
							<!-- contents -->
							    <h2>채팅</h2>
								<!-- Chat List Wrapper -->
								<div class="list-group">

								<!-- 하나의 채팅방 아이템 -->
								<a href="#" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between py-3">
									<div class="d-flex align-items-center">
									<img src="/img/default.png" 
										class="rounded-circle me-3" 
										width="48" height="48" 
										alt="avatar">
									<div>
										<div class="fw-bold">Test_ChatRoom_title</div>
										<div class="text-muted small text-truncate" style="max-width:200px;">
										Test_ChatRoom_Content_Title
										</div>
									</div>
									</div>
									<div class="text-end">
									<div class="text-muted small">오전 9:50</div>
									<span class="badge bg-danger rounded-pill">1</span>
									</div>
								</a>

								<a href="#" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between py-3">
									<div class="d-flex align-items-center">
									<img src="/img/default.png" class="rounded-circle me-3" width="48" height="48">
									<div>
										<div class="fw-bold">Test_ChatRoom_title</div>
										<div class="text-muted small text-truncate" style="max-width:200px;">
										Test_ChatRoom_Content_Title
										</div>
									</div>
									</div>
									<div class="text-end">
									<div class="text-muted small">오전 9:42</div>
									<span class="badge bg-secondary rounded-pill">4</span>
									</div>
								</a>

								</div>






							
						</div>
					</div>
				</main>
			</div>
					
	
	
	
	
		<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
		</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>