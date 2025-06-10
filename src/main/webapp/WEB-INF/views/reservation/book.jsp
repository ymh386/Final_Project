<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>수업 예약하기</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    label { display: block; margin-top: 10px; }
    select, button { padding: 6px; margin-top: 5px; width: 250px; }
    option { padding: 4px; }
    #remainingInfo { margin-top:10px; font-weight:bold; }
  </style>
</head>
<body>
  <h2>수업 예약 폼</h2>

  <c:if test="${not empty err}">
    <div style="color:red; margin-bottom:15px;">${err}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/reservation/book" method="post">
    <!-- 1) 트레이너 선택 -->
    <label for="trainerSelect">트레이너</label>
    <select id="trainerSelect" name="trainerName">
      <option value="">── 트레이너 선택 ──</option>
      <c:forEach var="t" items="${trainers}">
        <option value="${t}">${t}</option>
      </c:forEach>
    </select>

    <!-- 2) 일정 선택 -->
    <label for="scheduleSelect">일정</label>
    <select id="scheduleSelect" name="scheduleId" disabled>
      <option value="">── 먼저 트레이너를 선택하세요 ──</option>
      <c:forEach var="sch" items="${schedules}">
        <option 
          value="${sch.scheduleId}"
          data-trainer="${sch.username}"
          data-facility-id="${sch.facilityId}"
          data-remaining-seats="${sch.remainingSeats}"
          style="display:none;"
        >
          ${sch.scheduleDate} ${sch.startTime}-${sch.endTime}
              (장소: 
      <c:choose>
        <c:when test="${sch.facilityId == 1}">복싱장</c:when>
        <c:when test="${sch.facilityId == 2}">헬스장</c:when>
        <c:when test="${sch.facilityId == 3}">수영장</c:when>
        <c:otherwise>알 수 없음</c:otherwise>
      </c:choose>
          (남은 좌석: ${sch.remainingSeats})
        </option>
      </c:forEach>
    </select>

    <!-- 3) 남은 좌석 표시 -->
    <p id="remainingInfo">남은 좌석: –</p>

    <!-- 4) facilityId 전송을 위한 hidden -->
    <input type="hidden" id="facilityIdInput" name="facilityId" />

    <!-- 5) 예약 버튼 -->
    <button type="submit" id="submitBtn" disabled>예약하기</button>
  </form>

  <p style="margin-top:20px;">
    <a href="${pageContext.request.contextPath}/reservation/my">일정 목록으로 돌아가기</a>
  </p>


  <script>
    const trainerSelect   = document.getElementById('trainerSelect');
    const scheduleSelect  = document.getElementById('scheduleSelect');
    const facilityInput   = document.getElementById('facilityIdInput');
    const submitBtn       = document.getElementById('submitBtn');
    const remainingInfoEl = document.getElementById('remainingInfo');

    trainerSelect.addEventListener('change', () => {
      const trainer = trainerSelect.value;
      [...scheduleSelect.options].forEach(opt => {
        if (opt.dataset.trainer === trainer) {
          opt.style.display = '';
        } else {
          opt.style.display = 'none';
        }
      });
      if (trainer) {
        scheduleSelect.disabled = false;
        scheduleSelect.value = '';
        remainingInfoEl.textContent = '남은 좌석: –';
        submitBtn.disabled = true;
      } else {
        scheduleSelect.disabled = true;
        scheduleSelect.value = '';
        remainingInfoEl.textContent = '남은 좌석: –';
        facilityInput.value = '';
        submitBtn.disabled = true;
      }
    });

    scheduleSelect.addEventListener('change', () => {
      const sel = scheduleSelect.selectedOptions[0];
      if (sel && sel.value) {
        const rem = sel.dataset.remainingSeats;
        remainingInfoEl.textContent = '남은 좌석: ' + rem;
        facilityInput.value = sel.dataset.facilityId;
        submitBtn.disabled = rem <= 0;
      } else {
        remainingInfoEl.textContent = '남은 좌석: –';
        facilityInput.value = '';
        submitBtn.disabled = true;
      }
    });
  </script>
</body>
</html>
