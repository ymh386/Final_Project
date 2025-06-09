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
    <sec:authentication property="principal" var="user"/>
		<a href="/">home</a>
    <h1>My Page</h1>
    <sec:authorize access="isAuthenticated()">
	    <h2>${user.username}</h2>
	    <h2>${user.name}</h2>
	    <h2>${user.email}</h2>
	    <h2>${user.birth}</h2>
	    <h2>${user.phone}</h2>
	    <a href="/user/update">수정</a>

		<div>
			<h3>서명/도장</h3>
			<c:if test="${not empty userSignature}">
				<img src="/files/userSignature/${userSignature.fileName}" width="200" height="100">
				<a href="/approval/deleteSign">서명/도장 삭제</a>
			</c:if>
			<c:if test="${empty userSignature}">
				<p>등록된 서명/도장이 없습니다.</p>
				<a href="/approval/registerSign">서명/도장 등록</a>
			</c:if>
		</div>
		<div>
			<h2>전자결재</h2>
			<a href="./getDocuments">내 결재함</a>
			<a href="/approval/awaitList">승인 대기함</a>
			<a href="/approval/list">승인 내역</a>
		</div>
    </sec:authorize>

</body>
</html>