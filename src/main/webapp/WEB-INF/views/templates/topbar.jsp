<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
            <c:if test="${result eq 0}">
                <a class="btn btn-light me-3"  href="/subscript/list">구독</a>
            </c:if>
            </sec:authorize>
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
              <sec:authorize access="hasRole('TRAINER')">
                  <li><a class="dropdown-item"  href="/schedule/page">일정관리</a></li>
			    <li><a class="dropdown-item"  href="${pageContext.request.contextPath}/attendance/page">근태관리</a></li>
			  </sec:authorize>
			  
			  <sec:authorize access="hasRole('MEMBER')">
			    <li><a class="dropdown-item"  href="${pageContext.request.contextPath}/reservation/book">수업예약</a></li>
			  </sec:authorize>
	  		  <sec:authorize access="hasRole('ADMIN')">
				<li><a class="dropdown-item"  href="/admin/main">관리자</a></li>
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