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
	<h2>전자결재 양식 등록</h2>
	<form action="./formRegister" method="post">
		<label>양식 제목</label><br>
		<input type="text" name="formTitle" required><br><br>
		

        <label>내용</label><br>
        <textarea name="contentHtml" id="editor"></textarea><br><br>
        
        <button type="submit">등록</button>
	</form>
	
	<script>
        CKEDITOR.replace('editor');
    </script>
</body>
</html>