<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>ADMIN</h1>
	
	<h2>승인 대기 리스트</h2>
    <c:forEach items="${userList}" var="u">
    	<h3>${u.username} 허가 필요</h3>
    </c:forEach>

</body>
</html>