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
    <h2>부서정보</h2>
    <a class="btn" href="./user">부서별 회원 관리</a>
     <table class="table">
        <thead>
            <tr>
                <th scope="col">부서번호</th>
                <th scope="col">부서명</th>
                <th scope="col">부서 요약</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="a" items="${ar}">
                <tr>
                    <th scope="row">${a.departmentId}</th>
                    <td>${a.departmentName}</td>
                    <td>${a.description}</td>
                    <td><a class="btn" href="./update?departmentId=${a.departmentId}">수정</a></td>
                    <td><a href="./delete?departmentId=${a.departmentId}" class="btn">삭제</a></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <a class="btn" href="./add">부서 생성</a>
</body>
</html>