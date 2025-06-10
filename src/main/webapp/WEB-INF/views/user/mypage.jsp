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
		    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h2 {
            margin-bottom: 20px;
        }
        #buttons {
            margin-bottom: 20px;
        }
        #buttons button {
            padding: 10px 20px;
            margin-right: 10px;
            font-size: 16px;
            cursor: pointer;
        }
        #subList {
            width: 100%;
            border-collapse: collapse;
        }
        #subList th, #subList td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        #subList th {
            background-color: #f4f4f4;
        }
        .disabled {
            background-color: #ddd;
            color: #666;
            cursor: not-allowed;
        }
    </style>
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

	    
	    <h2>구독 내역</h2>
		<table id="subList" border="1" cellpadding="8">
			<tr><th>상품명</th><th>시작날짜</th><th>종료날짜</th><th>가격</th></tr>
			<c:forEach var="l" items="${list}">
				<tr>
					<form action="/subscript/cancel?subscriptId=${l.subscriptId}" method="post">
			        <td>${l.subscriptionVO.subscriptionName}</td>
			        <td>${l.startDate}</td>
			        <td>${l.endDate}</td>
			        <td>${l.subscriptionVO.price}</td>
					</form>
			      </tr>
			    </c:forEach>
		</table>

    </sec:authorize>
    
    

</body>
</html>