<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head><title>결제 성공</title></head>
<body>
<h1>결제 성공!</h1>
<p>주문번호: ${approved.orderId}</p>
<p>결제금액: ${approved.amount}원</p>
<p>결제수단: ${approved.method}</p>
<p>승인시간: ${approved.approvedAt}</p>
<a href="/subscriptions">구독권 목록으로</a>
</body>
</html>
