<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
</head>
<body>
    <h2>승인 대기함</h2>
    
    <c:if test="${not empty ar}">
	    <table class="table">
	        <thead>
	            <tr>
	                <th scope="col">문서번호</th>
	                <th scope="col">종류</th>
	                <th scope="col">요청자</th>
	                <th scope="col">제목</th>
                    <th scope="col">문서상태</th>
                    <th scope="col">승인여부</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach var="a" items="${ar}">
	                <tr>
	                    <th scope="row">${a.documentId}</th>
                        <td>${a.documentVO.formVO.formTitle}</td>
	                    <td>${a.documentVO.writerId}</td>
	                    <td><a href="./awaitDetail?documentId=${a.documentId}">${a.documentVO.documentTitle}</a></td>
                        <c:choose>
	                    	<c:when test="${a.documentVO.documentStatus eq 'D1'}">
	                    		<td>승인</td>
	                    	</c:when>
	                    	<c:when test="${a.documentVO.documentStatus eq 'D2'}">
	                    		<td>반려</td>
	                    	</c:when>
	                    	<c:otherwise>
	                    		<td>진행중</td>
	                    	</c:otherwise>
	                    </c:choose>
                        <c:choose>
	                    	<c:when test="${a.approvalStatus eq 'AS1'}">
	                    		<td>승인</td>
	                    	</c:when>
	                    	<c:otherwise>
	                    		<td>미승인</td>
	                    	</c:otherwise>
	                    </c:choose>
	                </tr>
	            </c:forEach>
	        </tbody>
	    </table>
    </c:if>
    <c:if test="${empty ar}">
    	<h3>조회된 승인대기가 없습니다.</h3>
    </c:if>
</body>
</html>