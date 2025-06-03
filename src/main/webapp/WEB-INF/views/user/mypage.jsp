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
    <sec:authentication property="principal" var="user"/>
    <h1>My Page</h1>
    <sec:authorize access="isAuthenticated()">
	    <h2>${user.username}</h2>
	    <h2>${user.name}</h2>
	    <h2>${user.email}</h2>
	    <h2>${user.birth}</h2>
	    <h2>${user.phone}</h2>
	    <a href="/user/update">수정</a>
    </sec:authorize>

</body>
</html>