<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>트레이너 일정 관리</title>

<!-- FullCalendar CSS -->
<link 
  href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" 
  rel="stylesheet" 
/>

<!-- FullCalendar JS -->
<script 
  src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js">
</script>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
}

#calendar {
	max-width: 900px;
	margin: 0 auto;
}
/* Modal 스타일 */
.modal {
	display: none;
	position: fixed;
	z-index: 100;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
	background-color: #fff;
	margin: 10% auto;
	padding: 20px;
	border-radius: 4px;
	width: 400px;
}

.modal-header {
	font-size: 18px;
	margin-bottom: 10px;
}

.modal-footer {
	text-align: right;
}

.modal-footer button {
	padding: 6px 12px;
	margin-left: 10px;
}

.form-group {
	margin-bottom: 10px;
}

.form-group label {
	display: block;
	font-size: 14px;
}

.form-group input {
	width: 100%;
	padding: 6px;
	box-sizing: border-box;
}
</style>
</head>
<body>
	<!-- 1) 로그인된 사용자 이름 출력: 
         Principal이 없거나 anonymous면 “손님”으로 표기 -->
	<h2>
		안녕하세요,
		<c:choose>
			<c:when test="${not empty pageContext.request.userPrincipal}">
                ${pageContext.request.userPrincipal.name} 
            </c:when>
			<c:otherwise>
                손님
            </c:otherwise>
		</c:choose>
		님
	</h2>

	<div id="calendar"></div>

	<!-- 일정 생성/삭제용 모달 (관리자 전용) -->
	<div id="scheduleModal" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				<span id="modalTitle">일정 등록</span>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label for="facilityId">시설 ID</label> <input type="number"
						id="facilityId" placeholder="숫자만 입력">
				</div>
				<div class="form-group">
					<label for="scheduleDate">예약 날짜</label> <input type="date"
						id="scheduleDate">
				</div>
				<div class="form-group">
					<label for="startTime">시작 시간</label> <input type="time"
						id="startTime">
				</div>
				<div class="form-group">
					<label for="endTime">종료 시간</label> <input type="time" id="endTime">
				</div>
			</div>
			<div class="modal-footer">
				<button id="btnCancel">취소</button>
				<button id="btnSave">저장</button>
				<button id="btnDelete"
					style="background-color: #e74c3c; color: #fff; display: none;">삭제</button>
			</div>
		</div>
	</div>

	<!-- FullCalendar JS -->
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/5.11.3/main.min.js"></script>
	<script>
        document.addEventListener('DOMContentLoaded', function() {
            // 2) 로그인/권한 정보를 JSP tag로 JS 변수에 할당
            //    pageContext.request.userPrincipal이 null이면 익명(anonymous)
            const isLoggedIn = ${not empty pageContext.request.userPrincipal};
            //    hasRole('ADMIN')일 때만 true, 아니면 false
            const isAdmin = 
                <sec:authorize access="hasRole('ADMIN')">true</sec:authorize>
                <sec:authorize access="!hasRole('ADMIN')">false</sec:authorize>;

            // 3) 이벤트 로드 URL 결정
            //    - 로그인된 트레이너는 /schedule/my
            //    - 로그인된 관리자는 /schedule/list
            //    - 비로그인은 이벤트 호출을 하지 않도록 빈 문자열
            let eventsUrl = '';
            if (isLoggedIn) {
                eventsUrl = isAdmin 
                    ? '${pageContext.request.contextPath}/schedule/list'
                    : '${pageContext.request.contextPath}/schedule/my';
            }

            // 4) FullCalendar 초기화
            const calendarEl = document.getElementById('calendar');
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                },
                // 로그인된 관리자인 경우만 날짜 선택 가능
                selectable: isAdmin,
                editable: false, // 이동/리사이즈는 지원하지 않음
                events: {
                    url: eventsUrl,
                    method: 'GET',
                    failure: function() {
                        alert('일정 데이터를 불러오는 중 오류가 발생했습니다.');
                    }
                },
                // 5) Admin만 일정 생성 모달 열기
                select: function(selectionInfo) {
                    if (!isAdmin) return;
                    openModal('create', {
                        start: selectionInfo.startStr.substring(0,10)
                    });
                },
                // 6) 이벤트 클릭 처리
                eventClick: function(info) {
                    const ev = info.event;
                    if (isAdmin) {
                        // 관리자: 수정/삭제 모달
                        openModal('edit', {
                            scheduleId: ev.id,
                            facilityId: ev.extendedProps.facilityId,
                            scheduleDate: ev.startStr.substring(0,10),
                            startTime: ev.startStr.substring(11,16),
                            endTime: ev.endStr ? ev.endStr.substring(11,16) : ev.startStr.substring(11,16)
                        });
                    } else if (isLoggedIn) {
                        // 로그인된 트레이너: 읽기 전용 알림
                        alert(`예약 날짜: ${ev.startStr.substring(0,10)}\n시설 ID: ${ev.extendedProps.facilityId}`);
                    } else {
                        // 비로그인: 달력 이벤트 클릭 금지 또는 간단 알림
                        alert('로그인 후 이용 가능합니다.');
                    }
                }
            });
            calendar.render();

            // 7) Modal 관련 요소 및 함수
            const modal = document.getElementById('scheduleModal');
            const modalTitle = document.getElementById('modalTitle');
            const inputFacility = document.getElementById('facilityId');
            const inputDate = document.getElementById('scheduleDate');
            const inputStart = document.getElementById('startTime');
            const inputEnd = document.getElementById('endTime');
            const btnCancel = document.getElementById('btnCancel');
            const btnSave = document.getElementById('btnSave');
            const btnDelete = document.getElementById('btnDelete');

            let currentMode = '';      // 'create' or 'edit'
            let currentScheduleId = null;

            // Modal 닫기
            btnCancel.onclick = () => { modal.style.display = 'none'; };

            // Modal 열기
            function openModal(mode, data) {
                currentMode = mode;
                if (mode === 'create') {
                    modalTitle.textContent = '일정 등록';
                    inputFacility.value = '';
                    inputDate.value = data.start;
                    inputStart.value = '09:00';
                    inputEnd.value = '10:00';
                    btnDelete.style.display = 'none';
                    currentScheduleId = null;
                } else if (mode === 'edit') {
                    modalTitle.textContent = '일정 삭제';
                    currentScheduleId = data.scheduleId;
                    inputFacility.value = data.facilityId;
                    inputDate.value = data.scheduleDate;
                    inputStart.value = data.startTime;
                    inputEnd.value = data.endTime;
                    btnDelete.style.display = 'inline-block';
                }
                modal.style.display = 'block';
            }

            // 저장 버튼 클릭 (create 모드만, 관리자만)
            btnSave.onclick = () => {
                if (!isAdmin) return;

                const facilityId = parseInt(inputFacility.value);
                const date = inputDate.value;
                const start = inputStart.value;
                const end = inputEnd.value;

                if (!facilityId || !date || !start || !end) {
                    alert('모든 필드를 입력하세요.');
                    return;
                }

                const vo = {
                    facilityId: facilityId,
                    scheduleDate: date,
                    startTime: start + ":00",
                    endTime: end + ":00"
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
                    calendar.addEvent({
                        id: newVo.scheduleId,
                        title: 'Facility ' + newVo.facilityId,
                        start: newVo.scheduleDate + 'T' + newVo.startTime,
                        end: newVo.scheduleDate + 'T' + newVo.endTime,
                        extendedProps: { facilityId: newVo.facilityId }
                    });
                    modal.style.display = 'none';
                })
                .catch(err => {
                    alert('일정 등록 중 오류가 발생했습니다.');
                    console.error(err);
                });
            };

            // 삭제 버튼 클릭 (edit 모드만, 관리자만)
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
                })
                .catch(err => {
                    alert('일정 삭제 중 오류가 발생했습니다.');
                    console.error(err);
                });
            };

            // 모달 바깥 영역 클릭 시 모달 닫기
            window.onclick = (event) => {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            };
        });
    </script>
</body>
</html>
