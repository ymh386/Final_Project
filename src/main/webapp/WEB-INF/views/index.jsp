<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
		<a href="/user/logout">logout</a>
		<h3>${user.email}</h3>
	</sec:authorize>
	<sec:authorize access="!isAuthenticated()">
		<a href="user/join">join</a>
		<a href="user/login">login</a>
	</sec:authorize>
</body>
</html>