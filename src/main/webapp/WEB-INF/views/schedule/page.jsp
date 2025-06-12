<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>트레이너 일정 관리</title>

    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet" />
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        #calendar { max-width: 900px; margin: 0 auto; }
        /* Modal 스타일 */
        .modal { display: none; position: fixed; z-index: 100; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.4); }
        .modal-content { background-color: #fff; margin: 10% auto; padding: 20px; border-radius: 4px; width: 400px; }
        .modal-header { font-size: 18px; margin-bottom: 10px; }
        .modal-footer { text-align: right; }
        .modal-footer button { padding: 6px 12px; margin-left: 10px; }
        .form-group { margin-bottom: 10px; }
        .form-group label { display: block; font-size: 14px; }
        .form-group input, .form-group select { width: 100%; padding: 6px; box-sizing: border-box; }
    </style>
</head>
<body>
    <!-- 로그인된 사용자 인사말 -->
    <h2>
        안녕하세요,
        <c:choose>
            <c:when test="${not empty pageContext.request.userPrincipal}">
                ${pageContext.request.userPrincipal.name}
            </c:when>
            <c:otherwise>손님</c:otherwise>
        </c:choose>
        님
    </h2>
    


    <!-- 캘린더 (모든 로그인 사용자에게 표시) -->
    <div id="calendar"></div>

    <!-- 관리자/트레이너 전용 모달 -->
    <sec:authorize access="hasAnyRole('ADMIN','TRAINER')">
        <div id="scheduleModal" class="modal">
            <div class="modal-content">
                <div class="modal-header"><span id="modalTitle">일정 등록</span></div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="username">트레이너</label>
                        <select id="username" name="username" class="form-control">
                            <option value="">-- 트레이너 선택 --</option>
                            <c:forEach var="trainer" items="${trainerList}">
                                <option value="${trainer.username}">${trainer.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="facilityId">시설</label>
                        <select id="facilityId" name="facilityId" class="form-control" required>
                            <option value="">-- 시설 선택 --</option>
                            <option value="1">복싱장</option>
                            <option value="2">헬스장</option>
                            <option value="3">수영장</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="scheduleDate">예약 날짜</label>
                        <input type="date" id="scheduleDate" name="scheduleDate" class="form-control" />
                    </div>
                    <div class="form-group">
                        <label for="startTime">시작 시간</label>
                        <input type="time" id="startTime" name="startTime" class="form-control" />
                    </div>
                    <div class="form-group">
                        <label for="endTime">종료 시간</label>
                        <input type="time" id="endTime" name="endTime" class="form-control" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="btnCancel" class="btn btn-secondary">취소</button>
                    <button id="btnSave" class="btn btn-primary">저장</button>
                    <button id="btnDelete" class="btn" style="background-color: #e74c3c; color: #fff; display: none;">삭제</button>
                </div>
            </div>
        </div>
    </sec:authorize>
    

    <button type="button" class="btn-back" onclick="location.href='${pageContext.request.contextPath}/';">
   	홈으로 이동
</button>

    <!-- FullCalendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const isLoggedIn = ${not empty pageContext.request.userPrincipal};
            const isAdmin =
                <sec:authorize access="hasRole('ADMIN')">true</sec:authorize>
                <sec:authorize access="!hasRole('ADMIN')">false</sec:authorize>;
            const isTrainer =
                <sec:authorize access="hasRole('TRAINER')">true</sec:authorize>
                <sec:authorize access="!hasRole('TRAINER')">false</sec:authorize>;
            const isMember =
                <sec:authorize access="hasRole('MEMBER')">true</sec:authorize>
                <sec:authorize access="!hasRole('MEMBER')">false</sec:authorize>;

            console.log('로그인:',    isLoggedIn,
                        '관리자:',    isAdmin,
                        '트레이너:',  isTrainer,
                        '멤버:',      isMember);

            let eventsUrl = '';
            if (isLoggedIn) {
                if (isAdmin) {
                    eventsUrl = '${pageContext.request.contextPath}/schedule/list';
                } else if (isTrainer) {
                    eventsUrl = '${pageContext.request.contextPath}/schedule/my';
                } else if (isMember) {
                    eventsUrl = '${pageContext.request.contextPath}/reservation/events';
                }
            }

            const calendar = new FullCalendar.Calendar(
                document.getElementById('calendar'), {
                    initialView: 'dayGridMonth',
                    locale: 'ko',
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'dayGridMonth,timeGridWeek,timeGridDay'
                    },
                    selectable: isAdmin,
                    editable: false,
                    events: {
                        url: eventsUrl,
                        method: 'GET',
                        failure: function() {
                            alert('일정 데이터를 불러오는 중 오류가 발생했습니다.');
                        }
                    },
                    select: function(info) {
                        if (!isAdmin) return;
                        openModal('create', { start: info.startStr.substring(0,10) });
                    },
                    eventClick: function(info) {
                        if (isAdmin) {
                            openModal('edit', {
                                scheduleId: info.event.id,
                                facilityId: info.event.extendedProps.facilityId,
                                scheduleDate: info.event.startStr.substring(0,10),
                                startTime: info.event.startStr.substring(11,16),
                                endTime: (info.event.endStr || info.event.startStr).substring(11,16)
                            });
                        }
                    }
                }
            );
            calendar.render();

            // Modal 핸들러
            const modal = document.getElementById('scheduleModal');
            const modalTitle = document.getElementById('modalTitle');
            const selectTrainer = document.getElementById('username');
            const inputFacility = document.getElementById('facilityId');
            const inputDate = document.getElementById('scheduleDate');
            const inputStart = document.getElementById('startTime');
            const inputEnd = document.getElementById('endTime');
            const btnCancel = document.getElementById('btnCancel');
            const btnSave = document.getElementById('btnSave');
            const btnDelete = document.getElementById('btnDelete');
            let currentMode = '';
            let currentScheduleId = null;

            btnCancel.onclick = () => modal.style.display = 'none';

            function openModal(mode, data) {
                currentMode = mode;
                if (mode === 'create') {
                    modalTitle.textContent = '일정 등록';
                    selectTrainer.value = '';
                    inputFacility.value = '';
                    inputDate.value = data.start;
                    inputStart.value = '09:00';
                    inputEnd.value = '10:00';
                    btnDelete.style.display = 'none';
                    currentScheduleId = null;
                } else {
                    modalTitle.textContent = '일정 삭제';
                    currentScheduleId = data.scheduleId;
                    selectTrainer.value = data.username || '';
                    inputFacility.value = data.facilityId;
                    inputDate.value = data.scheduleDate;
                    inputStart.value = data.startTime;
                    inputEnd.value = data.endTime;
                    btnDelete.style.display = 'inline-block';
                }
                modal.style.display = 'block';
            }

            btnSave.onclick = () => {
                if (!isAdmin) return;
                const trainerUsername = selectTrainer.value;
                if (!trainerUsername) { alert('트레이너를 선택하세요.'); return; }
                const facilityId = parseInt(inputFacility.value);
                const date = inputDate.value;
                const start = inputStart.value;
                const end = inputEnd.value;
                if (!facilityId || !date || !start || !end) { alert('모든 필드를 입력하세요.'); return; }
                const vo = { username: trainerUsername, facilityId, scheduleDate: date, startTime: start + ':00', endTime: end + ':00' };
                fetch('${pageContext.request.contextPath}/schedule/create', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(vo) })
                    .then(res => { if (!res.ok) throw new Error('생성 실패: ' + res.status); return res.json(); })
                    .then(newVo => {
                        calendar.addEvent({ id: newVo.scheduleId, title: newVo.username + ' / Facility ' + newVo.facilityId, start: newVo.scheduleDate + 'T' + newVo.startTime, end: newVo.scheduleDate + 'T' + newVo.endTime, extendedProps: { username: newVo.username, facilityId: newVo.facilityId } });
                        modal.style.display = 'none';
                    })
                    .catch(err => { alert('일정 등록 중 오류가 발생했습니다.'); console.error(err); });
            };

            btnDelete.onclick = () => {
                if (!isAdmin || !currentScheduleId) return;
                if (!confirm('정말 이 일정을 삭제하시겠습니까?')) return;
                fetch('${pageContext.request.contextPath}/schedule/delete/' + currentScheduleId, { method: 'DELETE' })
                    .then(res => { if (!res.ok) throw new Error('삭제 실패: ' + res.status); const ev = calendar.getEventById(String(currentScheduleId)); if (ev) ev.remove(); modal.style.display = 'none'; })
                    .catch(err => { alert('일정 삭제 중 오류가 발생했습니다.'); console.error(err); });
            };

            window.onclick = event => { if (event.target === modal) modal.style.display = 'none'; };
        });
    </script>
</body>
</html>
