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
    <h2>승인 내역</h2>
    
    
    <form method="get">
        <label>카테고리</label><br>
        <!-- 내용을 변경할때 마다 submit 시킴 -> 양식변경시 재렌더링 위함 -->
        <select onchange="this.form.submit()" id="formSelect" name="formId">
            <!-- 선택한 formId(양식)가 없을 때 모두 보기가 selected-->
            <option value="" ${empty selectedFormId ? 'selected' : ''}>모두 보기</option>
            <c:forEach var="f" items="${forms}">
                <!-- 선택한 formId(양식)가 있을 때 해당 양식목록이 selected-->
                <option value="${f.formId}" ${f.formId eq selectedFormId ? 'selected' : ''}>${f.formTitle}</option>
            </c:forEach>
        </select><br>
        <label>요청자ID</label><br>
        <input type="text" value="${writedId}" name="search"/>
        <button type="submit">검색</button>
    </form><br><br>

    <c:if test="${not empty ar}">
	    <table class="table">
	        <thead>
	            <tr>
	                <th scope="col">문서번호</th>
	                <th scope="col">종류</th>
	                <th scope="col">요청자</th>
	                <th scope="col">문서제목</th>
                    <th scope="col">문서상태</th>
                    <th scope="col">승인여부</th>
					<th scope="col">승인일시</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach var="a" items="${ar}">
	                <tr>
	                    <th scope="row">${a.documentId}</th>
                        <td>${a.documentVO.formVO.formTitle}</td>
	                    <td>${a.documentVO.writerId}</td>
	                    <td><a href="./detail?approvalId=${a.approvalId}">${a.documentVO.documentTitle}</a></td>
                        <c:choose>
	                    	<c:when test="${a.documentVO.documentStatus eq 'D1'}">
	                    		<td style="color: blue;">승인</td>
	                    	</c:when>
	                    	<c:when test="${a.documentVO.documentStatus eq 'D2'}">
	                    		<td style="color: red;">반려</td>
	                    	</c:when>
	                    	<c:otherwise>
	                    		<td>진행중</td>
	                    	</c:otherwise>
	                    </c:choose>
                        <c:choose>
	                    	<c:when test="${a.approvalStatus eq 'AS1'}">
	                    		<td style="color: blue;">승인</td>
	                    	</c:when>
	                    	<c:otherwise>
	                    		<td style="color: red;">반려</td>
	                    	</c:otherwise>
	                    </c:choose>
						<td>${a.approvedAt}</td>
	                </tr>
	            </c:forEach>
	        </tbody>
	    </table>
    </c:if>
    <c:if test="${empty ar}">
    	<h3>조회된 승인내역 없습니다.</h3>
    </c:if>
</body>
</html>