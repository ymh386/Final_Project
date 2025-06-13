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
<style>
    th, td {
        border: 1px solid #000000;
    }
</style>
</head>
<body>
    <sec:authentication property="principal" var="user"/>
    <h2>양식 정보</h2><br>
    <div class="mb-3">
        <label class="form-label">양식이름</label>
        <input type="text" class="form-control" value="${vo.formTitle}" readonly>
        <label class="form-label">제작일시</label>
        <input type="text" class="form-control" value="${vo.createdAt}" readonly>

    <div>
        ${vo.contentHtml}
    </div>

    <div>
        <a href="/approval/formUpdate?formId=${vo.formId}" class="btn">양식 수정</a><br>
        <a href="/approval/formDelete?formId=${vo.formId}" class="btn">양식 삭제</a>
    </div>

</body>
</html>