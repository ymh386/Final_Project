<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head><title>구독 상품 목록</title>
  <!-- 1) Toss JS SDK 로드 -->
  <sec:authentication property="principal" var="user"/>
  <script src="https://js.tosspayments.com/v1"></script>
    <script>
    // 2) 서버에서 전달한 client key 를 받아 초기화
    const tossPayments = TossPayments('${tossClientKey}');
    
    const origin = window.location.origin;
    
    const context = '${pageContext.request.contextPath}'
    
    // 3) 버튼 클릭 시 팝업 열기
    function openBillingPopup(subscriptionId) {
      tossPayments.requestBillingAuth('카드', {
        customerKey: '${user.username}',  // 로그인한 유저 ID
        successUrl:  origin + context + '/subscript/success?subscriptionId='+subscriptionId,
        failUrl:     origin + context + '/subscript/failure'
      });
    }
  </script>

</head>
<body>
<a href="/">메인화면</a>
  <h2>구독 상품</h2>
  <table border="1" cellpadding="8">
    <tr><th>상품명</th><th>기간(일)</th><th>가격</th><th>설명</th><th>구독</th></tr>
    <c:forEach var="sub" items="${plans}">
      <tr>
        <td>${sub.subscriptionName}</td>
        <td>${sub.days}</td>
        <td>${sub.price}원</td>
        <td>${sub.subscriptionContents}</td>
        <td>
          <button type="button"
                  onclick="openBillingPopup(${sub.subscriptionId})">
            구독하기
          </button>
        </td>
      </tr>
    </c:forEach>
  </table>
  
</body>
</html>