<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
</head>
<body>
	<h2>전자결재 작성</h2>
	<sec:authentication property="principal" var="user"/>
	<form id="documentForm" action="./addDocument" method="post">
		<label>카테고리</label><br>
		<select id="formSelect" name="formId">
			<option selected>-- 양식 선택 --</option>
			<c:forEach var="f" items="${ar}">
				<option value="${f.formId}">${f.formTitle}</option>
			</c:forEach>
		</select><br><br>


		<label>제목</label>
        <input type="text" name="documentTitle"><br><br>
		<label>요청자</label>
		<input type="text" value="${user.name}" readonly><br><br>

		<!-- CKEditor 내용 -->
		<label for="editor">내용</label><br>
		<div id="content">
			<textarea name="contentHtml" id="editor"></textarea><br><br>
		</div>


		<input type="hidden" name="approvalLineJson" id="approvalLineJson">
		
		

		<button type="submit">결재 요청</button>


	</form>
	

	<!-- 결재라인 선택 (트리 리스트) -->
	<label>조직도</label>
	<div id="line"></div><button id="addToApprovalLine">결재라인에 추가</button><br><br>

	<label>결재라인</label>
	<ol id="selectedApprovers"></ol><br><br>

	

<script src="/js/approval/addDocument.js"></script>
</body>
</html>