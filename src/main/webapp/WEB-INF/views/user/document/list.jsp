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
    <h2>내 결재함</h2>
    <label>카테고리</label><br>
    <form method="get">
        <!-- 내용을 변경할때 마다 submit 시킴 -> 양식변경시 재렌더링 위함 -->
        <select onchange="this.form.submit()" id="formSelect" name="formId">
            <!-- 선택한 formId(양식)가 없을 때 모두 보기가 selected-->
            <option value="" ${empty selectedFormId ? 'selected' : ''}>모두 보기</option>
            <c:forEach var="f" items="${forms}">
                <!-- 선택한 formId(양식)가 있을 때 해당 양식목록이 selected-->
                <option value="${f.formId}" ${f.formId eq selectedFormId ? 'selected' : ''}>${f.formTitle}</option>
            </c:forEach>
        </select>
    </form><br><br>
    <c:if test="${not empty ar}">
	    <table class="table">
	        <thead>
	            <tr>
	                <th scope="col">#</th>
	                <th scope="col">종류</th>
	                <th scope="col">작성자</th>
	                <th scope="col">제목</th>
	                <th scope="col">진행상태</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach var="a" items="${ar}">
	                <tr>
	                    <th scope="row">${a.documentId}</th>
                        <td>${a.formVO.formTitle}</a></td>
	                    <td>${a.writerId}</td>
	                    <td><a href="./getDocument?documentId=${a.documentId}">${a.documentTitle}</a></td>
	                    <c:choose>
	                    	<c:when test="${a.documentStatus eq 'D1'}">
	                    		<td>승인</td>
	                    	</c:when>
	                    	<c:when test="${a.documentStatus eq 'D2'}">
	                    		<td>반려</td>
	                    	</c:when>
	                    	<c:otherwise>
	                    		<td>진행중</td>
	                    	</c:otherwise>
	                    </c:choose>
	                </tr>
	            </c:forEach>
	        </tbody>
	    </table>
    </c:if>
    <c:if test="${empty ar}">
    	<h3>조회된 결재문서가 없습니다.</h3>
    </c:if>
</body>
</html>