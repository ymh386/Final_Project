<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>구독을 취소하시겠습니까?</h1>
	<h2>*다음 달부터 정기 결제가 중지됩니다.*</h2>
	<form action="/subscript/cancel?username=${user.username}" method="post">
		<input value="${user.username}" hidden>
		<button type="submit">구독 취소</button>
	</form>
</body>
</html>