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
        }
        .fc-event-time {
            font-size: 11px;
            color: #666;
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

            // 시설 ID를 이름으로 변환하는 함수
            function getFacilityName(facilityId) {
                const facilities = {
                    1: '복싱장',
                    2: '헬스장', 
                    3: '수영장'
                };
                return facilities[facilityId] || '시설' + facilityId;
            }

            // 시간을 HH:MM 형태로 포맷하는 함수
            function formatTime(timeString) {
                if (!timeString) return '';
                return timeString.substring(0, 5); // HH:MM:SS에서 HH:MM만 추출
            }

            // 트레이너 username을 실제 이름으로 변환하는 함수
            function getTrainerName(username) {
                // trainerList에서 username으로 실제 이름 찾기
                const trainerSelect = document.getElementById('username');
                if (trainerSelect) {
                    const options = trainerSelect.options;
                    for (let i = 0; i < options.length; i++) {
                        if (options[i].value === username) {
                            return options[i].text;
                        }
                    }
                }
                return username || '트레이너'; // 찾지 못하면 username 그대로 또는 기본값
            }

            // 이벤트 제목을 생성하는 함수
            function createEventTitle(data) {
                const facilityName = getFacilityName(data.facilityId);
                const startTime = formatTime(data.startTime);
                const endTime = formatTime(data.endTime);
                
                // 여러 가지 방법으로 트레이너 이름 찾기
                let trainerName = data.name || data.trainerName || getTrainerName(data.username) || data.username || '트레이너';
                
                console.log('이벤트 데이터:', data); // 디버깅용
                console.log('트레이너 이름:', trainerName); // 디버깅용
                
                return `${startTime}-${endTime}\n${trainerName}\n${facilityName}`;
            }

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
                    eventDisplay: 'block',
                    dayMaxEvents: false, // 이벤트 개수 제한 해제
                    events: {
                        url: eventsUrl,
                        method: 'GET',
                        failure: function() {
                            alert('일정 데이터를 불러오는 중 오류가 발생했습니다.');
                        }
                    },
                    // 이벤트 데이터 변환 및 스타일링
                    eventDataTransform: function(eventData) {
                        console.log('서버에서 받은 원본 데이터:', eventData);
                        
                        // 기존 title에서 facilityId 추출 (예: "Facility 2" -> 2)
                        let facilityId = null;
                        if (eventData.title && eventData.title.includes('Facility ')) {
                            facilityId = parseInt(eventData.title.replace('Facility ', ''));
                        }
                        
                        // extendedProps에서 데이터 추출
                        const username = eventData.extendedProps ? eventData.extendedProps.username : eventData.username;
                        
                        // 가짜 데이터 구조 생성 (createEventTitle 함수용)
                        const processedData = {
                            facilityId: facilityId,
                            username: username,
                            startTime: eventData.start ? eventData.start.substring(11, 19) : '09:00:00',
                            endTime: eventData.end ? eventData.end.substring(11, 19) : '10:00:00',
                            scheduleDate: eventData.start ? eventData.start.substring(0, 10) : ''
                        };
                        
                        console.log('변환된 데이터:', processedData);
                        
                        return {
                            id: eventData.id,
                            title: createEventTitle(processedData),
                            start: eventData.start,
                            end: eventData.end,
                            backgroundColor: getFacilityColor(facilityId),
                            borderColor: getFacilityColor(facilityId),
                            textColor: '#ffffff',
                            extendedProps: {
                                username: username,
                                facilityId: facilityId,
                                startTime: processedData.startTime,
                                endTime: processedData.endTime,
                                scheduleDate: processedData.scheduleDate
                            }
                        };
                    },
                    select: function(info) {
                        if (!isAdmin) return;
                        openModal('create', { start: info.startStr.substring(0,10) });
                    },
                    eventClick: function(info) {
                        if (isAdmin) {
                            openModal('edit', {
                                scheduleId: info.event.id,
                                username: info.event.extendedProps.username,
                                facilityId: info.event.extendedProps.facilityId,
                                scheduleDate: info.event.extendedProps.scheduleDate || info.event.startStr.substring(0,10),
                                startTime: info.event.extendedProps.startTime || info.event.startStr.substring(11,16),
                                endTime: info.event.extendedProps.endTime || (info.event.endStr || info.event.startStr).substring(11,16)
                            });
                        }
                    }
                }
            );

            // 시설별 색상 지정
            function getFacilityColor(facilityId) {
                const colors = {
                    1: '#e74c3c', // 복싱장 - 빨간색
                    2: '#3498db', // 헬스장 - 파란색
                    3: '#2ecc71'  // 수영장 - 초록색
                };
                return colors[facilityId] || '#95a5a6';
            }

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
                
                const vo = { 
                    username: trainerUsername, 
                    facilityId, 
                    scheduleDate: date, 
                    startTime: start + ':00', 
                    endTime: end + ':00' 
                };

                fetch('${pageContext.request.contextPath}/schedule/create', { 
                    method: 'POST', 
                    headers: { 'Content-Type': 'application/json' }, 
                    body: JSON.stringify(vo) 
                })
                .then(res => { 
                    if (!res.ok) throw new Error('생성 실패: ' + res.status); 
                    return res.json(); 
                })
                .then(newVo => {
                    // 새로운 이벤트를 캘린더에 추가
                    calendar.addEvent({
                        id: newVo.scheduleId,
                        title: createEventTitle(newVo),
                        start: newVo.scheduleDate + 'T' + newVo.startTime,
                        end: newVo.scheduleDate + 'T' + newVo.endTime,
                        backgroundColor: getFacilityColor(newVo.facilityId),
                        borderColor: getFacilityColor(newVo.facilityId),
                        textColor: '#ffffff',
                        extendedProps: {
                            username: newVo.username,
                            facilityId: newVo.facilityId,
                            startTime: newVo.startTime,
                            endTime: newVo.endTime,
                            scheduleDate: newVo.scheduleDate
                        }
                    });
                    modal.style.display = 'none';
                    alert('일정이 성공적으로 등록되었습니다.');
                })
                .catch(err => { 
                    alert('일정 등록 중 오류가 발생했습니다.'); 
                    console.error(err); 
                });
            };

            btnDelete.onclick = () => {
                if (!isAdmin || !currentScheduleId) return;
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
        });
    </script>
</body>
</html>