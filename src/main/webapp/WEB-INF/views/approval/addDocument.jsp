<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
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

		<label>내용</label><br>
        <div id="content">

		</div>

		<button type="submit">결재 요청</button>


	</form>

<script src="/js/approval/addDocument.js"></script>
</body>
</html>