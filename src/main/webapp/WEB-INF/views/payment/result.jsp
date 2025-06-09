<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>결제 결과</title>
</head>
<body>
  <h2>결제 결과</h2>

  <c:choose>
    <c:when test="${payment.paymentStatus == 'DONE'}">
      <p>🎉 결제가 정상 처리되었습니다!</p>
      <ul>
        <li>결제키: ${payment.paymentKey}</li>
        <li>금액: ${payment.amount}원</li>
        <li>결제 수단: ${payment.method}</li>
        <li>승인 일시: ${payment.approvedAt}</li>
        <!-- 구독 정보가 넘어왔다면 -->
        <li>구독 시작: ${payment.startDate}</li>
        <li>구독 만료: ${payment.endDate}</li>
      </ul>
      <a href="<c:url value='/'/>">메인으로 돌아가기</a>
    </c:when>
    <c:otherwise>
      <p>❌ 결제에 실패했습니다.</p>
      <p>사유: ${payment.failReason}</p>
      <a href="<c:url value='/subscript/list'/>">다시 시도하기</a>
    </c:otherwise>
  </c:choose>
</body>
</html>
