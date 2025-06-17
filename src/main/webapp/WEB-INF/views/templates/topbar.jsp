<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Bootstrap Icons 필요 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<style>
    .toast a:hover, #notification a:hover  {
        text-decoration: underline;
    }
    .table-row {
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .table-row:hover {
        background-color: #f2f2f2 !important;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        transform: scale(1.01);
    }

</style>

<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark justify-content-between">
    <!-- Navbar Brand-->
    <a class="navbar-brand ps-3" href="/">그룹웨어</a>
    <sec:authentication property="principal" var="user"/>
    <!-- Navbar-->
    <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
        <sec:authorize access="isAuthenticated()">

            <sec:authorize access="!hasRole('TRAINER')">
            <h3 class="navbar-brand me-3">구독권 잔여 일자 : ${remainDay} 일</h3>
            <sec:authorize access="hasAuthority('CANCEL')">
                <a class="btn btn-light me-3" href="/subscript/restart">구독 재개</a>
            </sec:authorize>
            <sec:authorize access="hasAuthority('APPROVE')">
                <a class="btn btn-light me-3" href="/subscript/cancel">구독 취소</a>
            </sec:authorize>
            <c:if test="${remainDay eq 0}">
                <a class="btn btn-light me-3"  href="/subscript/list">구독</a>
            </c:if>
            </sec:authorize>

            <!-- 알림 아이콘 -->
            <li class="nav-item">
                <div id="notification" data-username="${user.username}" class="dropdown">
                    <button class="btn btn-light position-relative" id="notificationButton" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-bell" style="font-size: 1.5rem;"></i>
                        <span id="notificationBadge" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="display: none;">
                        0
                        </span>
                    </button>
    
                    <ul id="notificationList" class="dropdown-menu dropdown-menu-end p-2" style="width: 300px; max-height: 400px; overflow-y: auto;">
                        
                    </ul>
                </div>
            </li>

            <!-- Toast Container(실시간 알림 팝업) -->
            <div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1055;">
            </div>

        </sec:authorize>
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="true">
                <i class="fas fa-user fa-fw"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
            <sec:authorize access="isAuthenticated()">
            		<h6>${user.name}님, 환영합니다!</h6>
					<li><a class="dropdown-item"  href="/user/mypage">내 정보</a></li>
					<li><a class="dropdown-item"  href="/user/logout">로그아웃</a></li>
				 <li><a class="dropdown-item"  href="/schedule/page">일정</a></li>
					
              <sec:authorize access="hasRole('TRAINER')">
			    <li><a class="dropdown-item"  href="${pageContext.request.contextPath}/attendance/page">근태관리</a></li>
			    <li><a class="dropdown-item"  href="${pageContext.request.contextPath}/equipment/main">비품 신고</a></li>
			  </sec:authorize>
			  
			  <sec:authorize access="hasRole('MEMBER')">
			    <li><a class="dropdown-item"  href="${pageContext.request.contextPath}/reservation/book">수업예약</a></li>
			  </sec:authorize>
	  		  <sec:authorize access="hasRole('ADMIN')">
				<li><a class="dropdown-item"  href="/admin/main">관리자</a></li>
				<li><a class="dropdown-item"  href="${pageContext.request.contextPath}/equipment/admin">비품 관리</a></li>
			  </sec:authorize>
            </sec:authorize>      
           	<sec:authorize access="!isAuthenticated()">
				<li><a class="dropdown-item"  href="/user/join/join">회원가입</a></li>
				<li><a class="dropdown-item"  href="/user/login/login">로그인</a></li>
			</sec:authorize>
            </ul>
        </li>
    </ul>
</nav>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<audio id="notificationSound" src="/sound/notification.wav" preload="auto"></audio>
<script src="/js/notification/notification.js"></script>
