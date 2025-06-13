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
        
        /* 캘린더 이벤트 스타일 개선 */
        .fc-event-title {
            font-weight: bold;
            font-size: 12px;
            white-space: pre-line; /* 줄바꿈 처리 */
        }
        .fc-event-time {
            font-size: 11px;
            color: #666;
        }
        
        /* 이벤트 박스 높이 조정 */
        .fc-daygrid-event {
            white-space: pre-line !important;
            height: auto !important;
            min-height: 50px;
        }
        
        /* 이벤트 시간 숨기기 */
        .fc-event-time {
            display: none !important;
        }
        
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
        님 일정표
    </h2>
    
    <!-- 캘린더 (모든 로그인 사용자에게 표시) -->
    <div id="calendar"></div>

    <!-- 관리자/트레이너 전용 모달 -->
    <sec:authorize access="hasAnyRole('ROLE_ADMIN')">
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
                <sec:authorize access="hasRole('ROLE_ADMIN')">true</sec:authorize>
                <sec:authorize access="!hasRole('ROLE_ADMIN')">false</sec:authorize>;
            const isTrainer =
                <sec:authorize access="hasRole('ROLE_TRAINER')">true</sec:authorize>
                <sec:authorize access="!hasRole('ROLE_TRAINER')">false</sec:authorize>;
            const isMember =
                <sec:authorize access="hasRole('ROLE_MEMBER')">true</sec:authorize>
                <sec:authorize access="!hasRole('ROLE_MEMBER')">false</sec:authorize>;

            console.log('로그인:', isLoggedIn, '관리자:', isAdmin, '트레이너:', isTrainer, '멤버:', isMember);
            
            // 권한 체크 디버깅
            if (!isLoggedIn) {
                console.log('로그인되지 않은 사용자입니다.');
                return;
            }
            
            if (!isAdmin && !isTrainer) {
                console.log('관리자 또는 트레이너 권한이 없습니다.');
            }

            // 각 권한별로 다른 API 엔드포인트 사용
            let eventsUrl = '';
            if (isLoggedIn) {
                if (isAdmin) {
                    eventsUrl = '${pageContext.request.contextPath}/schedule/list';  // 관리자: 모든 일정
                } else if (isTrainer) {
                    eventsUrl = '${pageContext.request.contextPath}/schedule/my';    // 트레이너: 본인 일정
                } else if (isMember) {
                    eventsUrl = '${pageContext.request.contextPath}/reservation/events';  // 일반회원: 본인 예약 일정
                }
            }

            // Modal 변수들을 전역 스코프로 이동
            var modal, modalTitle, selectTrainer, inputFacility, inputDate, inputStart, inputEnd;
            var btnCancel, btnSave, btnDelete;
            var currentMode = '';
            var currentScheduleId = null;

            // openModal 함수를 전역 스코프로 이동
            window.openModal = function(mode, data) {
                console.log('openModal 호출됨:', mode, data);
                
                if (!isAdmin && !isTrainer) {
                    console.log('권한 없음 - 관리자:', isAdmin, '트레이너:', isTrainer);
                    return;
                }
                
                if (!modal) {
                    console.log('Modal 요소를 찾을 수 없습니다.');
                    return;
                }
                
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
                    modalTitle.textContent = '일정 수정/삭제';
                    currentScheduleId = data.scheduleId;
                    selectTrainer.value = data.username || '';
                    inputFacility.value = data.facilityId;
                    inputDate.value = data.scheduleDate;
                    inputStart.value = data.startTime;
                    inputEnd.value = data.endTime;
                    btnDelete.style.display = 'inline-block';
                }
                modal.style.display = 'block';
                console.log('Modal 표시됨');
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
                    selectable: isAdmin || isTrainer, // 관리자와 트레이너만 날짜 선택 가능
                    editable: false,
                    eventDisplay: 'block',
                    dayMaxEvents: false,
                    height: 'auto',
                    
                    // 이벤트 로드
                    events: eventsUrl ? {
                        url: eventsUrl,
                        method: 'GET',
                        failure: function() {
                            alert('일정 데이터를 불러오는 중 오류가 발생했습니다.');
                        }
                    } : [],
                    
                    // 이벤트 렌더링
                    eventDidMount: function(info) {
                        console.log('이벤트 데이터:', info.event);
                        info.el.title = info.event.title.replace(/\n/g, ' | ');
                    },
                    
                    select: function(info) {
                        console.log('날짜 선택됨:', info);
                        console.log('권한 체크 - 관리자:', isAdmin, '트레이너:', isTrainer);
                        
                        if (!isAdmin && !isTrainer) {
                            console.log('권한 없어서 리턴');
                            return;
                        }
                        
                        console.log('openModal 호출 시도');
                        window.openModal('create', { start: info.startStr.substring(0,10) });
                    },
                    
                    eventClick: function(info) {
                        console.log('이벤트 클릭됨:', info);
                        console.log('권한 체크 - 관리자:', isAdmin, '트레이너:', isTrainer);
                        
                        if (isAdmin || isTrainer) {
                            console.log('이벤트 클릭 처리 시작');
                            const props = info.event.extendedProps;
                            console.log('이벤트 속성:', props);
                            
                            window.openModal('edit', {
                                scheduleId: props.scheduleId,
                                username: props.username,
                                facilityId: props.facilityId,
                                scheduleDate: props.scheduleDate,
                                startTime: props.startTime,
                                endTime: props.endTime
                            });
                        } else {
                            console.log('권한 없어서 이벤트 클릭 무시');
                        }
                    }
                }
            );

            calendar.render();

            // Modal 초기화 (관리자/트레이너만 접근 가능)
            if (isAdmin || isTrainer) {
                modal = document.getElementById('scheduleModal');
                modalTitle = document.getElementById('modalTitle');
                selectTrainer = document.getElementById('username');
                inputFacility = document.getElementById('facilityId');
                inputDate = document.getElementById('scheduleDate');
                inputStart = document.getElementById('startTime');
                inputEnd = document.getElementById('endTime');
                btnCancel = document.getElementById('btnCancel');
                btnSave = document.getElementById('btnSave');
                btnDelete = document.getElementById('btnDelete');

                btnCancel.onclick = () => modal.style.display = 'none';

                btnSave.onclick = () => {
                    const trainerUsername = selectTrainer.value;
                    if (!trainerUsername) { alert('트레이너를 선택하세요.'); return; }
                    const facilityId = parseInt(inputFacility.value);
                    const date = inputDate.value;
                    const start = inputStart.value;
                    const end = inputEnd.value;
                    if (!facilityId || !date || !start || !end) { alert('모든 필드를 입력하세요.'); return; }
                    
                    const vo = { 
                        username: trainerUsername, 
                        facilityId, 
                        scheduleDate: date, 
                        startTime: start + ':00', 
                        endTime: end + ':00' 
                    };

                    const url = currentMode === 'create' 
                        ? '${pageContext.request.contextPath}/schedule/create'
                        : '${pageContext.request.contextPath}/schedule/update/' + currentScheduleId;
                    
                    const method = currentMode === 'create' ? 'POST' : 'PUT';

                    fetch(url, { 
                        method: method, 
                        headers: { 'Content-Type': 'application/json' }, 
                        body: JSON.stringify(vo) 
                    })
                    .then(res => { 
                        if (!res.ok) throw new Error('저장 실패: ' + res.status); 
                        return res.json(); 
                    })
                    .then(newEvent => {
                        if (currentMode === 'create') {
                            calendar.addEvent(newEvent);
                            alert('일정이 성공적으로 등록되었습니다.');
                        } else {
                            // 수정 모드일 때는 기존 이벤트 제거 후 새로 추가
                            const existingEvent = calendar.getEventById(String(currentScheduleId));
                            if (existingEvent) existingEvent.remove();
                            calendar.addEvent(newEvent);
                            alert('일정이 성공적으로 수정되었습니다.');
                        }
                        modal.style.display = 'none';
                    })
                    .catch(err => { 
                        alert('일정 저장 중 오류가 발생했습니다.'); 
                        console.error(err); 
                    });
                };

                btnDelete.onclick = () => {
                    if (!currentScheduleId) return;
                    if (!confirm('정말 이 일정을 삭제하시겠습니까?')) return;
                    
                    fetch('${pageContext.request.contextPath}/schedule/delete/' + currentScheduleId, { 
                        method: 'DELETE' 
                    })
                    .then(res => { 
                        if (!res.ok) throw new Error('삭제 실패: ' + res.status); 
                        const ev = calendar.getEventById(String(currentScheduleId)); 
                        if (ev) ev.remove(); 
                        modal.style.display = 'none';
                        alert('일정이 성공적으로 삭제되었습니다.');
                    })
                    .catch(err => { 
                        alert('일정 삭제 중 오류가 발생했습니다.'); 
                        console.error(err); 
                    });
                };

                window.onclick = event => { 
                    if (event.target === modal) modal.style.display = 'none'; 
                };
            }
        });
    </script>
</body>
</html>