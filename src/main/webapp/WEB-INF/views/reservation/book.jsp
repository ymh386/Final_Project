<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>수업 예약하기</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    label { display: block; margin-top: 10px; }
    select, button { padding: 6px; margin-top: 5px; width: 250px; }
    option { padding: 4px; }
    #remainingInfo { margin-top: 10px; font-weight: bold; }
  </style>
</head>
<body>
  <h2>수업 예약 폼</h2>

  <c:if test="${not empty err}">
    <div style="color:red; margin-bottom:15px;">${err}</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/reservation/book" method="post">
    <!-- 0) 시설 선택 -->
    <label for="facilitySelect">시설</label>
    <select id="facilitySelect">
      <option value="">── 시설을 먼저 선택하세요 ──</option>
      <option value="1">복싱장</option>
      <option value="2">헬스장</option>
      <option value="3">수영장</option>
    </select>

    <!-- 1) 트레이너 선택 -->
    <label for="trainerSelect">트레이너</label>
    <select id="trainerSelect" name="username" disabled>
      <option value="">── 시설을 먼저 선택하세요 ──</option>
    </select>

    <!-- 2) 일정 선택 -->
    <label for="scheduleSelect">일정</label>
    <select id="scheduleSelect" name="scheduleId" disabled>
      <option value="">── 트레이너를 먼저 선택하세요 ──</option>
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
          , 남은 좌석: ${sch.remainingSeats})
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
    document.addEventListener('DOMContentLoaded', function() {
      // username -> 실제 이름 매핑 (trainerList에서 가져옴)
      const trainerNameMap = {
        <c:forEach var="t" items="${trainerList}" varStatus="loop">
          '${t.username}': '${t.name}'<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
      };

      const facilitySelect = document.getElementById('facilitySelect');
      const trainerSelect  = document.getElementById('trainerSelect');
      const scheduleSelect = document.getElementById('scheduleSelect');
      const facilityInput  = document.getElementById('facilityIdInput');
      const submitBtn      = document.getElementById('submitBtn');
      const remainingInfo  = document.getElementById('remainingInfo');

      // 1) 모든 일정 옵션 캐싱 & 숨기기
      const allOptions = Array.from(scheduleSelect.options);
      allOptions.forEach(opt => opt.style.display = 'none');

      // 2) 초기 disabled 상태
      trainerSelect.disabled  = true;
      scheduleSelect.disabled = true;

      // placeholder HTML for schedules
      const schedulePlaceholder = '<option value="">── 일정 선택 ──</option>';

      // 3) 시설 선택 → 트레이너 필터링
      facilitySelect.addEventListener('change', () => {
        const fac = facilitySelect.value;
        // 리셋
        trainerSelect.innerHTML  = '<option value="">── 트레이너 선택 ──</option>';
        scheduleSelect.innerHTML = schedulePlaceholder;
        remainingInfo.textContent = '남은 좌석: –';
        facilityInput.value      = '';
        submitBtn.disabled       = true;

        if (!fac) {
          trainerSelect.disabled  = true;
          scheduleSelect.disabled = true;
          return;
        }
        // 해당 시설 일정만 대상으로 고유 트레이너 집합 생성
        const trainers = new Set(
          allOptions
            .filter(opt => opt.dataset.facilityId === fac)
            .map(opt => opt.dataset.trainer)
        );
        trainers.forEach(id => {
          const o = document.createElement('option');
          o.value       = id;
          o.textContent = trainerNameMap[id] || id;
          trainerSelect.appendChild(o);
        });
        trainerSelect.disabled = false;
      });

      // 4) 트레이너 선택 → 일정 필터링
      trainerSelect.addEventListener('change', () => {
        const fac = facilitySelect.value;
        const trn = trainerSelect.value;
        // 리셋
        scheduleSelect.innerHTML = schedulePlaceholder;
        remainingInfo.textContent = '남은 좌석: –';
        facilityInput.value       = '';
        submitBtn.disabled        = true;

        if (!trn) {
          scheduleSelect.disabled = true;
          return;
        }
        // 해당 시설+트레이너 일정만 복제하여 보여줌
        allOptions.forEach(opt => {
          if (opt.dataset.facilityId === fac && opt.dataset.trainer === trn) {
            const clone = opt.cloneNode(true);
            clone.style.display = '';
            scheduleSelect.appendChild(clone);
          }
        });
        scheduleSelect.disabled = false;
      });

      // 5) 일정 선택 → 남은 좌석, hidden 업데이트, 버튼 활성화
      scheduleSelect.addEventListener('change', () => {
        const sel = scheduleSelect.selectedOptions[0];
        if (sel && sel.value) {
          const rem = +sel.dataset.remainingSeats;
          remainingInfo.textContent = '남은 좌석: ' + rem;
          facilityInput.value = sel.dataset.facilityId;
          submitBtn.disabled  = rem <= 0;
        } else {
          remainingInfo.textContent = '남은 좌석: –';
          facilityInput.value = '';
          submitBtn.disabled = true;
        }
      });
    });
  </script>
</body>
</html>
