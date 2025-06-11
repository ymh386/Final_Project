<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>구독을 재개하시겠습니까?</h1>
	<h2>*현재 취소상태입니다. 재개할 경우 구독권 종료 일자부터 정기결제가 진행됩니다.*</h2>
	<h3>구독권 종료일 : ${endDate}</h3>
	<form action="/subscript/restart?username=${user.username}" method="post">
		<input value="${user.username}" hidden>
		<button type="submit">구독 재개</button>
	</form>
</body>
</html>