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
    <h2>승인</h2><br>
    <div class="mb-3">
        <label class="form-label">요청자</label>
        <input type="text" class="form-control" value="${vo.documentVO.writerId}" readonly>
        <label class="form-label">종류</label>
        <input type="text" class="form-control" value="${vo.documentVO.formVO.formTitle}" readonly>
        <label class="form-label">제목</label>
        <input type="text" class="form-control" value="${vo.documentVO.documentTitle}" readonly>
        <label class="form-label">문서 상태</label>
        <c:choose>
            <c:when test="${vo.documentVO.documentStatus eq 'D1'}">
                <input type="text" class="form-control" value="승인" readonly>
            </c:when>
            <c:when test="${vo.documentVO.documentStatus eq 'D2'}">
                <input type="text" class="form-control" value="반려" readonly>
            </c:when>
            <c:otherwise>
                <input type="text" class="form-control" value="진행중" readonly>
            </c:otherwise>
        </c:choose>
        <label class="form-label">승인 여부</label>
        <c:choose>
            <c:when test="${vo.approvalStatus eq 'AS1'}">
                <input type="text" class="form-control" value="승인" readonly>
            </c:when>
            <c:otherwise>
                <input type="text" class="form-control" value="미승인" readonly>
            </c:otherwise>
        </c:choose>
    </div>

    <div>
        ${vo.documentVO.contentHtml}
    </div>

    <div class="mb-3">
        <div class="row">
            <a href="./registerSign" class="button">서명/도장 등록</a>
        </div>
        <div class="row">
            <button class="button" id="approve">승인</button>
            <button class="button" id="rejection">반려</button>
        </div>
    </div>
</body>
</html>