<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
  <title>구독 확정</title>
</head>
<body>
  <h2>구독 최종 확인</h2>
  <sec:authentication property="principal" var="user"/>

  <!-- 컨트롤러에서 subscription 객체(SubscriptionVO)를 model에 담아서 넘겼다고 가정 -->
  <c:if test="${not empty sub}">
    <p><strong>상품명:</strong> ${sub.subscriptionName}</p>
    <p><strong>기간:</strong> ${sub.days}일</p>
    <p><strong>가격:</strong> ${sub.price}원</p>
  </c:if>

  <!-- 결제 승인(구독 확정) 요청 폼 -->
  <form action="/subscript/subscribe" method="post">
    <!-- 숨겨진 필드로 필요한 값 전달 -->
    <input type="hidden" name="subscriptionId" value="${sub.subscriptionId}" />
    <input type="hidden" name="customerKey"    value="${user.username}" />

    <button type="submit">구독 확정하기</button>
  </form>

  <p>
    <a href="<c:url value='/subscript/list'/>">← 다른 상품 보러가기</a>
  </p>
</body>
</html>