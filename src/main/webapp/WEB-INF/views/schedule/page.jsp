<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
<head>
    <meta charset="UTF-8">
    <title>트레이너 일정 관리</title>
    <c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
    
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet" />
      <style>
        .calendar-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .page-header {
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .page-title {
            color: #495057;
            font-weight: 600;
            margin: 0;
            line-height:2;
        }
        
        .user-greeting {
            color: #6c757d;
            font-size: 1rem;
            margin-top: 5px;
        }
        
        /* FullCalendar 스타일 - 이벤트 잘림 방지 */
        .fc-event {
            border-radius: 4px;
            border: none;
            padding: 2px 4px;
            overflow: visible !important;
        }
        
        .fc-event-title {
            font-weight: 500;
            font-size: 12px;
            white-space: pre-line;
            overflow: visible !important;
        }
        
        .fc-daygrid-event {
            white-space: pre-line !important;
            height: auto !important;
            min-height: 40px;
            overflow: visible !important;
        }
        
        .fc-event-time {
            display: none !important;
        }
        
        /* 캘린더 셀 높이 조정 */
        .fc-daygrid-day {
            min-height: 120px !important;
        }
        
        .fc-daygrid-day-events {
            margin-top: 2px;
            min-height: 80px !important;
        }
        
        .fc-daygrid-event-harness {
            margin-bottom: 2px;
        }
        
        /* 캘린더 전체 높이 조정 */
        .fc-daygrid-body {
            min-height: 600px;
        }
        
        .fc-scrollgrid-section-body > td {
            overflow: visible !important;
        }
        
        /* Modal 스타일 */
        .modal-content {
            border-radius: 8px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .modal-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            border-radius: 8px 8px 0 0;
        }
        
        .modal-title {
            font-weight: 600;
            color: #495057;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            font-weight: 500;
            color: #495057;
            margin-bottom: 5px;
        }
        
        .form-control {
            border-radius: 4px;
            border: 1px solid #ced4da;
            padding: 8px 12px;
        }
        
        .form-control:focus {
            border-color: #80bdff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        
        .form-control:disabled {
            background-color: #e9ecef;
            opacity: 1;
        }
        
        .btn {
            border-radius: 4px;
            font-weight: 500;
            padding: 8px 16px;
        }
        
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        
        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }
    </style>
</head>
<body class="sb-nav-fixed">
    <c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
    <div id="layoutSidenav">
        <c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
        
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <!-- 페이지 헤더 -->
                    <div class="page-header">
                        <h1 class="page-title">트레이너 일정 관리</h1>
                        <div class="user-greeting">
                            안녕하세요,
                            <c:choose>
                                <c:when test="${not empty pageContext.request.userPrincipal}">
                                    <strong>${pageContext.request.userPrincipal.name}</strong>
                                </c:when>
                                <c:otherwise><strong>손님</strong></c:otherwise>
                            </c:choose>
                            님
                        </div>
                    </div>
                    
                    <!-- 캘린더 -->
                    <div class="calendar-container">
                        <div id="calendar"></div>
                    </div>
                </div>
            </main>
            
            <c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
        </div>
    </div>

    <!-- 관리자 전용 모달 (생성/수정용) -->
    <sec:authorize access="hasRole('ROLE_ADMIN')">
        <div class="modal fade" id="scheduleModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">일정 등록</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
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
                            <input type="text" id="facilityText" class="form-control" style="display: none;" disabled />
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
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                        <button id="btnSave" type="button" class="btn btn-primary">저장</button>
                        <button id="btnDelete" type="button" class="btn btn-danger" style="display: none;">삭제</button>
                    </div>
                </div>
            </div>
        </div>
    </sec:authorize>

    <!-- 트레이너 전용 모달 (삭제 전용) -->
    <sec:authorize access="hasRole('ROLE_TRAINER') and !hasRole('ROLE_ADMIN')">
        <div class="modal fade" id="scheduleViewModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="viewModalTitle">일정 상세</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="viewUsername">트레이너</label>
                            <input type="text" id="viewUsername" class="form-control" disabled />
                        </div>
                        <div class="form-group">
                            <label for="viewFacilityId">시설</label>
                            <input type="text" id="viewFacilityId" class="form-control" disabled />
                        </div>
                        <div class="form-group">
                            <label for="viewScheduleDate">예약 날짜</label>
                            <input type="date" id="viewScheduleDate" class="form-control" disabled />
                        </div>
                        <div class="form-group">
                            <label for="viewStartTime">시작 시간</label>
                            <input type="time" id="viewStartTime" class="form-control" disabled />
                        </div>
                        <div class="form-group">
                            <label for="viewEndTime">종료 시간</label>
                            <input type="time" id="viewEndTime" class="form-control" disabled />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                        <button id="btnViewDelete" type="button" class="btn btn-danger">삭제</button>
                    </div>
                </div>
            </div>
        </div>
    </sec:authorize>

    <!-- FullCalendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
                    eventsUrl = '${pageContext.request.contextPath}/schedule/list';
                } else if (isTrainer) {
                    eventsUrl = '${pageContext.request.contextPath}/schedule/my';
                } else if (isMember) {
                    eventsUrl = '${pageContext.request.contextPath}/reservation/events';
                }
            }

            // Modal 인스턴스
            var scheduleModal, scheduleViewModal;
            var currentMode = '';
            var currentScheduleId = null;

            // Bootstrap 모달 초기화
            if (isAdmin) {
                scheduleModal = new bootstrap.Modal(document.getElementById('scheduleModal'));
            }
            if (isTrainer && !isAdmin) {
                scheduleViewModal = new bootstrap.Modal(document.getElementById('scheduleViewModal'));
            }

            // 시설 ID를 이름으로 변환하는 함수
            function getFacilityName(facilityId) {
                switch(facilityId) {
                    case 1: case '1': return '복싱장';
                    case 2: case '2': return '헬스장';
                    case 3: case '3': return '수영장';
                    default: return '알 수 없음';
                }
            }

            // 관리자용 모달 열기 함수
            window.openModal = function(mode, data) {
                console.log('openModal 호출됨:', mode, data);
                
                if (!isAdmin) {
                    console.log('관리자 권한 없음');
                    return;
                }
                
                currentMode = mode;
                const modalTitle = document.getElementById('modalTitle');
                const selectTrainer = document.getElementById('username');
                const inputFacility = document.getElementById('facilityId');
                const facilityText = document.getElementById('facilityText');
                const inputDate = document.getElementById('scheduleDate');
                const inputStart = document.getElementById('startTime');
                const inputEnd = document.getElementById('endTime');
                const btnDelete = document.getElementById('btnDelete');
                const btnSave = document.getElementById('btnSave');
                
                if (mode === 'create') {
                    modalTitle.textContent = '일정 등록';
                    selectTrainer.value = '';
                    inputFacility.value = '';
                    facilityText.value = '';
                    inputDate.value = data.start;
                    inputStart.value = '09:00';
                    inputEnd.value = '10:00';
                    btnDelete.style.display = 'none';
                    btnSave.style.display = 'inline-block';
                    currentScheduleId = null;
                    
                    // 생성 모드일 때는 모든 필드 활성화
                    selectTrainer.disabled = false;
                    inputFacility.disabled = false;
                    inputFacility.style.display = 'block';
                    facilityText.style.display = 'none';
                    inputDate.disabled = false;
                    inputStart.disabled = false;
                    inputEnd.disabled = false;
                } else {
                    modalTitle.textContent = '일정 상세';
                    currentScheduleId = data.scheduleId;
                    selectTrainer.value = data.username || '';
                    facilityText.value = getFacilityName(data.facilityId);
                    inputDate.value = data.scheduleDate;
                    inputStart.value = data.startTime;
                    inputEnd.value = data.endTime;
                    btnDelete.style.display = 'inline-block';
                    btnSave.style.display = 'none';
                    
                    // 수정 모드일 때는 모든 필드 비활성화
                    selectTrainer.disabled = true;
                    inputFacility.style.display = 'none';
                    facilityText.style.display = 'block';
                    inputDate.disabled = true;
                    inputStart.disabled = true;
                    inputEnd.disabled = true;
                }
                scheduleModal.show();
            }

            // 트레이너용 읽기 전용 모달 열기 함수
            window.openViewModal = function(data) {
                console.log('openViewModal 호출됨:', data);
                
                if (!isTrainer || isAdmin) {
                    console.log('트레이너 권한 없음 또는 관리자임');
                    return;
                }
                
                currentScheduleId = data.scheduleId;
                document.getElementById('viewUsername').value = data.username || '';
                document.getElementById('viewFacilityId').value = getFacilityName(data.facilityId);
                document.getElementById('viewScheduleDate').value = data.scheduleDate;
                document.getElementById('viewStartTime').value = data.startTime;
                document.getElementById('viewEndTime').value = data.endTime;
                
                scheduleViewModal.show();
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
                        
                        if (!isAdmin) {
                            console.log('관리자 권한 없어서 리턴');
                            return;
                        }
                        
                        window.openModal('create', { start: info.startStr.substring(0,10) });
                    },
                    
                    eventClick: function(info) {
                        console.log('이벤트 클릭됨:', info);
                        
                        const props = info.event.extendedProps;
                        console.log('이벤트 속성:', props);
                        
                        if (isAdmin) {
                            window.openModal('edit', {
                                scheduleId: props.scheduleId,
                                username: props.username,
                                facilityId: props.facilityId,
                                scheduleDate: props.scheduleDate,
                                startTime: props.startTime,
                                endTime: props.endTime
                            });
                        } else if (isTrainer) {
                            window.openViewModal({
                                scheduleId: props.scheduleId,
                                username: props.username,
                                facilityId: props.facilityId,
                                scheduleDate: props.scheduleDate,
                                startTime: props.startTime,
                                endTime: props.endTime
                            });
                        }
                    }
                }
            );

            calendar.render();

            // 관리자용 이벤트 핸들러
            if (isAdmin) {
                document.getElementById('btnSave').onclick = () => {
                    if (currentMode !== 'create') {
                        alert('기존 일정은 수정할 수 없습니다.');
                        return;
                    }
                    
                    const trainerUsername = document.getElementById('username').value;
                    if (!trainerUsername) { alert('트레이너를 선택하세요.'); return; }
                    const facilityId = parseInt(document.getElementById('facilityId').value);
                    const date = document.getElementById('scheduleDate').value;
                    const start = document.getElementById('startTime').value;
                    const end = document.getElementById('endTime').value;
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
                        if (!res.ok) throw new Error('저장 실패: ' + res.status); 
                        return res.json(); 
                    })
                    .then(newEvent => {
                        calendar.addEvent(newEvent);
                        alert('일정이 성공적으로 등록되었습니다.');
                        scheduleModal.hide();
                    })
                    .catch(err => { 
                        alert('일정 저장 중 오류가 발생했습니다.'); 
                        console.error(err); 
                    });
                };

                document.getElementById('btnDelete').onclick = () => {
                    if (!currentScheduleId) return;
                    if (!confirm('정말 이 일정을 삭제하시겠습니까?')) return;
                    
                    fetch('${pageContext.request.contextPath}/schedule/delete/' + currentScheduleId, { 
                        method: 'DELETE' 
                    })
                    .then(res => { 
                        if (!res.ok) throw new Error('삭제 실패: ' + res.status); 
                        const ev = calendar.getEventById(String(currentScheduleId)); 
                        if (ev) ev.remove(); 
                        scheduleModal.hide();
                        alert('일정이 성공적으로 삭제되었습니다.');
                    })
                    .catch(err => { 
                        alert('일정 삭제 중 오류가 발생했습니다.'); 
                        console.error(err); 
                    });
                };
            }

            // 트레이너용 이벤트 핸들러
            if (isTrainer && !isAdmin) {
                document.getElementById('btnViewDelete').onclick = () => {
                    if (!currentScheduleId) return;
                    if (!confirm('정말 이 일정을 삭제하시겠습니까?')) return;
                    
                    fetch('${pageContext.request.contextPath}/schedule/delete/' + currentScheduleId, { 
                        method: 'DELETE' 
                    })
                    .then(res => { 
                        if (!res.ok) throw new Error('삭제 실패: ' + res.status); 
                        const ev = calendar.getEventById(String(currentScheduleId)); 
                        if (ev) ev.remove(); 
                        scheduleViewModal.hide();
                        alert('일정이 성공적으로 삭제되었습니다.');
                    })
                    .catch(err => { 
                        alert('일정 삭제 중 오류가 발생했습니다.'); 
                        console.error(err); 
                    });
                };
            }
        });
    </script>
</body>
</html>