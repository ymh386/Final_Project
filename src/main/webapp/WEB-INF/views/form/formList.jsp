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

    <h2>양식 목록</h2>
    
    <c:if test="${not empty ar}">
	    <table class="table">
	        <thead>
	            <tr>
	                <th scope="col">양식번호</th>
	                <th scope="col">양식이름</th>
	                <th scope="col">제작일시</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach var="a" items="${ar}">
	                <tr>
	                    <th scope="row">${a.formId}</th>
                        <td><a href="./formDetail?formId=${a.formId}">${a.formTitle}</a></td>
	                    <td>${a.createdAt}</td>
	                </tr>
	            </c:forEach>
	        </tbody>
	    </table>
    </c:if>
    <c:if test="${empty ar}">
    	<h3>조회된 양식이 없습니다.</h3>
    </c:if>
    <div>
        <a href="./formRegister" class="btn">양식 등록</a>
    </div>
</body>
</html>