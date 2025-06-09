<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h3>home</h3>
	
	<sec:authentication property="principal" var="user"/>
	<sec:authorize access="isAuthenticated()">
		<h3>${user.name}</h3>
		<a href="/user/mypage">mypage</a>
		<a href="/user/logout">logout</a>
		<a href="/schedule/page">schedule</a>
	
	  <sec:authorize access="hasRole('TRAINER')">
    <a href="${pageContext.request.contextPath}/attendance/page">근태관리</a>
  </sec:authorize>
  
    <sec:authorize access="hasRole('MEMBER')">
    <a href="${pageContext.request.contextPath}/reservation/book">수업예약</a>
  </sec:authorize>
</sec:authorize>
  
	
	<sec:authorize access="!isAuthenticated()">
		<a href="user/join/join">join</a>
		<a href="user/login/login">login</a>
	</sec:authorize>
		<sec:authorize access="hasRole('ADMIN')">
		<a href="admin/main">admin</a>
	</sec:authorize>
	
	<div>
		<sec:authorize access="hasRole('ADMIN')">
			<a href="/approval/formRegister">양식등록(관리자)</a>
		</sec:authorize>
		<a href="/approval/addDocument">결재신청</a>
	</div>
</body>
</html>