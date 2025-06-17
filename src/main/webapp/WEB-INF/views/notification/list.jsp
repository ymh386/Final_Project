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
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
                    <div class="container">
							<!-- contents -->
						<h2>알림함</h2>
    
					    <c:if test="${not empty ar}">
						    <table class="table table-hover">
						        <thead>
						            <tr>
						                <th scope="col">종류</th>
						                <th scope="col">송신자</th>
						                <th scope="col">제목</th>
					                    <th scope="col">내용</th>
					                    <th scope="col">읽음 여부</th>
					                    <th scope="col">발송 시각</th>
						            </tr>
						        </thead>
						        <tbody>
						            <c:forEach var="a" items="${ar}">
						                <tr class="table-row trs" data-id="${a.notificationId}" data-link="${a.linkUrl}">
						                	
						                	<c:choose>
						                    	<c:when test="${a.notificationType eq 'N1'}">
						                    		<td>채팅방 초대</td>
						                    	</c:when>
						                    	<c:when test="${a.notificationType eq 'N2'}">
						                    		<td>구독권 시작</td>
						                    	</c:when>
						                    	<c:when test="${a.notificationType eq 'N3'}">
						                    		<td>구독권 만료</td>
						                    	</c:when>
						                    	<c:when test="${a.notificationType eq 'N4'}">
						                    		<td>수업 예약 완료</td>
						                    	</c:when>
						                    	<c:when test="${a.notificationType eq 'N5'}">
						                    		<td>수업 예약 취소</td>
						                    	</c:when>
						                    	<c:when test="${a.notificationType eq 'N6'}">
						                    		<td>승인 요청</td>
						                    	</c:when>
						                    	<c:when test="${a.notificationType eq 'N7'}">
						                    		<td>승인 결과</td>
						                    	</c:when>
						                    	<c:when test="${a.notificationType eq 'N8'}">
						                    		<td>문서 승인 결과</td>
						                    	</c:when>
						                    	<c:otherwise>
						                    		<td>채팅메세지</td>
						                    	</c:otherwise>
						                    </c:choose>
						                	
					                        <td>${a.senderVO.name}</td>
						                    <td>${a.notificationTitle}</td>
						                    <td>${a.message}</td>
						                   
					                    	<c:choose>
						                    	<c:when test="${a.read}">
						                    		<td>읽음</td>
						                    	</c:when>
						                    	<c:otherwise>
													<td><i class="bi bi-info-circle-fill text-primary mt-1"></i>안 읽음</td>
						                    	</c:otherwise>
						                    </c:choose>
						                    
						                    <td>${a.createdAt}</td>
						                </tr>
						            </c:forEach>
						        </tbody>
						    </table>
					    </c:if>
					    <c:if test="${empty ar}">
					    	<h3>조회된 알림이 없습니다.</h3>
					    </c:if>





					<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
					</div>
				</main>
			</div>
		</div>
					
	
	
	
	
		<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
		</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="/js/notification/list.js"></script>
	</body>
</html>