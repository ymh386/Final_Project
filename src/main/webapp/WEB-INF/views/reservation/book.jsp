<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>수업 예약하기</title>
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background: #f8f9fa;
      padding-top: 2rem;
    }
    .card {
      border: none;
      border-radius: 0.75rem;
      box-shadow: 0 4px 8px rgba(0,0,0,0.05);
    }
    .card-header {
      background: #fff;
      border-bottom: none;
      font-weight: 600;
      font-size: 1.25rem;
    }
    .form-select, .btn {
      border-radius: 0.5rem;
    }
    #remainingInfo {
      font-size: 1rem;
      font-weight: 500;
      margin-top: 0.5rem;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="card mx-auto" style="max-width: 600px;">
      <div class="card-header text-center">
        수업 예약 폼
      </div>
      <div class="card-body">
        <c:if test="${not empty err}">
          <div class="alert alert-danger">${err}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reservation/book" method="post">
          <!-- 시설 선택 -->
          <div class="mb-3">
            <label for="facilitySelect" class="form-label">시설 선택</label>
            <select id="facilitySelect" class="form-select" required>
              <option value="">── 시설을 먼저 선택하세요 ──</option>
              <option value="1">복싱장</option>
              <option value="2">헬스장</option>
              <option value="3">수영장</option>
            </select>
          </div>

          <!-- 트레이너 선택 -->
          <div class="mb-3">
            <label for="trainerSelect" class="form-label">트레이너 선택</label>
            <select id="trainerSelect" name="username" class="form-select" disabled>
              <option value="">── 시설을 먼저 선택하세요 ──</option>
            </select>
          </div>

          <!-- 일정 선택 -->
          <div class="mb-3">
            <label for="scheduleSelect" class="form-label">일정 선택</label>
            <select id="scheduleSelect" name="scheduleId" class="form-select" disabled>
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
                    </c:choose>
                    , 남은 좌석: ${sch.remainingSeats})
                </option>
              </c:forEach>
            </select>
          </div>

          <!-- 남은 좌석 표시 -->
          <div id="remainingInfo">남은 좌석: –</div>

          <!-- facilityId 전송을 위한 hidden -->
          <input type="hidden" id="facilityIdInput" name="facilityId" />

          <!-- 예약 버튼 -->
          <div class="d-grid mt-4">
            <button type="submit" id="submitBtn" class="btn btn-primary btn-lg" disabled>예약하기</button>
          </div>
        </form>

        <div class="text-center mt-3">
          <a href="${pageContext.request.contextPath}/reservation/my" class="text-decoration-none">&larr; 일정 목록으로 돌아가기</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
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

      const allOptions = Array.from(scheduleSelect.options);
      trainerSelect.disabled  = true;
      scheduleSelect.disabled = true;

      facilitySelect.addEventListener('change', () => {
        const fac = facilitySelect.value;
        trainerSelect.innerHTML  = '<option value="">── 트레이너 선택 ──</option>';
        scheduleSelect.innerHTML = '<option value="">── 일정 선택 ──</option>';
        remainingInfo.textContent = '남은 좌석: –';
        facilityInput.value      = '';
        submitBtn.disabled       = true;

        if (!fac) { trainerSelect.disabled = true; return; }
        const trainers = new Set(
          allOptions.filter(opt => opt.dataset.facilityId === fac).map(opt => opt.dataset.trainer)
        );
        trainers.forEach(id => {
          const o = document.createElement('option');
          o.value       = id;
          o.textContent = trainerNameMap[id] || id;
          trainerSelect.appendChild(o);
        });
        trainerSelect.disabled = false;
      });

      trainerSelect.addEventListener('change', () => {
        const fac = facilitySelect.value;
        const trn = trainerSelect.value;
        scheduleSelect.innerHTML = '<option value="">── 일정 선택 ──</option>';
        remainingInfo.textContent = '남은 좌석: –';
        facilityInput.value       = '';
        submitBtn.disabled        = true;

        if (!trn) { scheduleSelect.disabled = true; return; }
        allOptions.forEach(opt => {
          if (opt.dataset.facilityId === fac && opt.dataset.trainer === trn) {
            const clone = opt.cloneNode(true);
            clone.style.display = '';
            scheduleSelect.appendChild(clone);
          }
        });
        scheduleSelect.disabled = false;
      });

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
