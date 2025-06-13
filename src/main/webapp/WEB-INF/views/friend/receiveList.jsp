<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
								<ul class="nav nav-tabs">
									<li class="nav-item">
										<a class="nav-link" aria-current="page" href="./list">친구</a>
									</li>
									<li class="nav-item">
										<a class="nav-link active" href="./receiveList">받은 요청</a>
									</li>
									<li class="nav-item">
										<a class="nav-link" href="./requestList">보낸 요청</a>
									</li>									
									<li class="nav-item">
										<a class="nav-link" href="./suggestList">추천 친구</a>
									</li>																		
								</ul>
								<c:forEach var="l" items="${list}">
									<form method="post">
										<a href="#" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between py-3">
											<div class="d-flex align-items-center">
											<img src="/img/default.png" 
												class="rounded-circle me-3" 
												width="48" height="48" 
												alt="avatar">
											<div>
												<div class="fw-bold">${l.requesterId}</div>
												<input hidden name="requesterId" value="${l.requesterId}">
											</div>
											</div>
											<div class="text-end">
												<button type="submit" formaction="/friend/receiveList" class="btn btn-primary">+</button>
												<button type="submit" formaction="/friend/rejectList" class="btn btn-danger">x</button>
											</div>
										</a>
									</form>
								</c:forEach>

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