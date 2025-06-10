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
    <h2>결재 정보</h2><br>
    <div class="mb-3">
        <label class="form-label">작성자</label>
        <input type="text" class="form-control" value="${vo.writerId}" readonly>
        <label class="form-label">종류</label>
        <input type="text" class="form-control" value="${vo.formVO.formTitle}" readonly>
        <label class="form-label">제목</label>
        <input type="text" class="form-control" value="${vo.documentTitle}" readonly>
        <label class="form-label">진행 상태</label>
        <c:choose>
            <c:when test="${vo.documentStatus eq 'D1'}">
                <input type="text" class="form-control" value="승인" readonly>
            </c:when>
            <c:when test="${vo.documentStatus eq 'D2'}">
                <input type="text" class="form-control" value="반려" readonly>
            </c:when>
            <c:otherwise>
                <input type="text" class="form-control" value="진행중" readonly>
            </c:otherwise>
        </c:choose>
    </div>

    <div>
        ${vo.contentHtml}
    </div>

</body>
</html>