<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
</head>
<body>
	<h2>전자결재 작성</h2>
	<form action="./addDocument" method="post">
		<label>카테고리</label><br>
			<select id="formSelect" name="categoryId">
				<option selected>-- 양식 선택 --</option>
				<c:forEach var="c" items="${ar}">
					<option value="${c.categoryId}">${c.categoryName}</option>
				</c:forEach>
			</select><br><br>

		<label>제목</label><br>
        <input type="text" name="documentTitle"><br><br>

		<!-- CKEditor 내용 -->
        <label for="editor">내용</label><br>
		<div id="content">
			<textarea name="contentHtml" id="editor"></textarea><br><br>
		</div>

		<button type="submit">결재 요청</button>


	</form>

<script src="/js/approval/addDocument.js"></script>
</body>
</html>