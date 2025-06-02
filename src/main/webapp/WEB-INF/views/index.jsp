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
	
	<a href="user/join">join</a>
	<a href="user/login">login</a>
	<sec:authentication property="principal" var="user"/>
	<sec:authorize access="isAuthenticated()">
		<h3>${user}</h3>
	</sec:authorize>
	
	<div>
		<a href="/approval/formRegister">양식등록(관리자)</a>
		<a href="/approval/addDocument">결재신청</a>
	</div>
</body>
</html>