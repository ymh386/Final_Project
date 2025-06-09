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
			<h2>전자결재</h2>
			<a href="./getDocuments">내 결재함</a>
		</div>

	    
	    <h2>잔여 구독권 현황</h2>
      <table border="1" cellpadding="8">
	    <tr><th>상품명</th><th>시작날짜</th><th>종료날짜</th><th>가격</th></tr>
	    <c:forEach var="l" items="${list}">
	      <tr>
	        <td>${l.subscriptionVO.subscriptionName}</td>
	        <td>${l.startDate}</td>
	        <td>${l.endDate}</td>
	        <td>${l.subscriptionVO.price}</td>
	      </tr>
	    </c:forEach>
	  </table>

    </sec:authorize>
    
    

</body>
</html>