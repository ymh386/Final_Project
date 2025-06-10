<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>내 예약 목록</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h2 { margin-bottom: 10px; }
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
    th { background: #f0f0f0; }
    .msg { color: green; margin-bottom: 15px; }
    a.button { margin-top: 15px; display: inline-block; padding: 6px 12px; 
               background: #007bff; color: #fff; text-decoration: none; border-radius: 4px; }
    a.button:hover { background: #0056b3; }
  </style>
</head>
<body>
  <h2>내 예약 목록</h2>

  <c:if test="${not empty msg}">
    <div class="msg">${msg}</div>
  </c:if>

  <table>
    <tr>
      <th>예약 ID</th>
      <th>일정 ID</th>
      <th>장소</th>       
      <th>예약 일시</th>
      <th>취소 일시</th>
      <th>취소 사유</th>
      <th>동작</th>
    </tr>
    <c:forEach var="r" items="${list}">
      <tr>
        <td>${r.reservationId}</td>
        <td>${r.scheduleId}</td>
        <!-- 시설ID에 따라 장소명 매핑 -->
        <td>
          <c:choose>
            <c:when test="${r.facilityId == 1}">복싱장</c:when>
            <c:when test="${r.facilityId == 2}">헬스장</c:when>
            <c:when test="${r.facilityId == 3}">수영장</c:when>
            <c:otherwise>알 수 없음</c:otherwise>
          </c:choose>
        </td>
        <td>${r.createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))}</td>
        <td>
          <c:choose>
            <c:when test="${not empty r.canceledAt}">
              ${r.canceledAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))}
            </c:when>
            <c:otherwise>–</c:otherwise>
          </c:choose>
        </td>
        <td>${r.canceledReason}</td>
        <td>
          <c:if test="${empty r.canceledAt}">
            <form action="${pageContext.request.contextPath}/reservation/cancel" method="post" style="display:inline;">
              <input type="hidden" name="reservationId" value="${r.reservationId}"/>
              <input type="text" name="canceledReason" placeholder="취소 사유" required/>
              <button type="submit">취소</button>
            </form>
          </c:if>
        </td>
      </tr>
    </c:forEach>
  </table>

  <a class="button" href="${pageContext.request.contextPath}/reservation/my">
    내 예약 목록으로 이동
  </a>
</body>
</html>
