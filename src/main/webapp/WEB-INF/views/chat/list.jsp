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
							    <div class="d-flex justify-content-between align-items-center mb-3">
								<h2 class="mb-0">채팅</h2>

								<div class="d-flex gap-2">
									<a href="#" onclick="makeChat()" class="btn btn-primary btn-sm">채팅 시작</a>
								</div>
								</div>
								<!-- Chat List Wrapper -->
								<div class="list-group">
								<sec:authentication property="principal" var="user"/>
								<input hidden name="senderId" id="senderId"  value="${user.username}">
								<c:forEach var="item" items="${list}">
									<input hidden id="getRoomId" name="roomId" value="${item.roomId}">
									<a href="#" onclick="openChatRoom('${item.roomId}')" id="chat-list-item-${item.roomId}"  class="list-group-item list-group-item-action d-flex align-items-center justify-content-between py-3">
										<div class="d-flex align-items-center">
										<img src="/img/default.png" 
											class="rounded-circle me-3" 
											width="48" height="48" 
											alt="avatar">
										<div>
											<div class="fw-bold">${item.roomName}</div>
											<div class="last-message text-muted small text-truncate" style="max-width:200px;">
											${item.message}
											</div>
										</div>
										</div>
										<div class="text-end">
											<div class="text-muted small chat-time">${item.createdAt}</div>
											<c:if test="${item.unread > 0}">
												<span class="badge bg-danger rounded-pill unread">${item.unread}</span>		
											</c:if>
										</div>
									</a>
								</c:forEach>
								</div>
								
							</div>
					</div>
				</main>
			</div>
					
			
			
			
			
			<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
		</div>
		<script>
		window.baseUrl = '${pageContext.request.contextPath}';
		</script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
		<script src="/js/chat/list.js"></script>
	</body>
</html>
