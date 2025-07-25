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
				<sec:authentication property="principal" var="user"/>
                <main class="flex-grow-1">
                    <div class="container">
							<!-- contents -->
								<ul class="nav nav-tabs">
									<li class="nav-item">
										<a class="nav-link active" aria-current="page" href="./list">친구</a>
									</li>
									<li class="nav-item">
										<a class="nav-link" href="./receiveList">받은 요청</a>
									</li>
									<li class="nav-item">
										<a class="nav-link" href="./requestList">보낸 요청</a>
									</li>									
									<li class="nav-item">
										<a class="nav-link" href="./suggestList">추천 친구</a>
									</li>																		
								</ul>
								    <c:if test="${empty list}">
									<div class="d-flex justify-content-center align-items-center" 
										style="height: 60vh;">
										<h1 class="text-muted">친구가 없습니다ㅠㅠㅠ 불쌍해라</h1>
										<input hidden name="user1" value="${user.username}">
									</div>
									</c:if>
								<c:forEach var="l" items="${list}">
									<form action="/friend/deleteFriend" method="post">
										<a href="#" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between py-3">
											<div class="d-flex align-items-center">
											<c:if test="${l.sns eq null and l.fileName ne 'default'}">
												<img src="/files/user/${l.fileName}"
													class="rouned-circle me-3"
													width="48" height="48"
													alt="avatar">
											</c:if>
											<c:if test="${l.sns ne null}">
												<img src="${l.fileName}"
													class="rouned-circle me-3"
													width="48" height="48"
													alt="avatar">
											</c:if>
											<c:if test="${l.sns eq null and l.fileName eq 'default'}">
												<img src="/img/default.png" 
												class="rounded-circle me-3" 
												width="48" height="48" 
												alt="avatar">
											</c:if>
											<div>
												<div class="fw-bold">${l.user2}</div>
												<input hidden name="user2" value="${l.user2}">
												<input hidden name="user1" value="${user.username}">
											</div>
											</div>
											<div class="text-end">
												<button type="submit" class="btn btn-danger">친구 삭제</button>
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