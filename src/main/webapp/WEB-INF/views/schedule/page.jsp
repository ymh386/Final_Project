<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>트레이너 일정 관리</title>

    <!-- FullCalendar CSS -->
    <link
        href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css"
        rel="stylesheet" />

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

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 6px;
            box-sizing: border-box;
        }
    </style>
</head>
<body>
    <!-- 1) 로그인된 사용자 이름 출력: Principal이 없거나 anonymous면 “손님”으로 표기 -->
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

    <div id="calendar"></div>


    <!-- 일정 생성/삭제용 모달 (관리자 전용) -->
    <div id="scheduleModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <span id="modalTitle">일정 등록</span>
            </div>
            <div class="modal-body">
                <!-- 1) 트레이너 선택 드롭다운 -->
                <div class="form-group">
                    <label for="username">트레이너</label>
                    <select id="username" name="username" class="form-control">
                        <option value="">-- 트레이너 선택 --</option>
                        <c:forEach var="trainer" items="${trainerList}">
                            <option value="${trainer.username}">${trainer.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- 2) 시설 ID -->
                <div class="form-group">
                    <label for="facilityId">시설</label>
                    <select id="facilityId" name="facilityId" class="form-control" required>
                        <option value="">-- 시설 선택 --</option>
                        <option value="1">복싱장</option>
                        <option value="2">헬스장</option>
                        <option value="3">수영장</option>
                    </select>
                </div>

                <!-- 3) 예약 날짜 -->
                <div class="form-group">
                    <label for="scheduleDate">예약 날짜</label>
                    <input type="date" id="scheduleDate" name="scheduleDate" class="form-control" />
                </div>

                <!-- 4) 시작 시간 -->
                <div class="form-group">
                    <label for="startTime">시작 시간</label>
                    <input type="time" id="startTime" name="startTime" class="form-control" />
                </div>

                <!-- 5) 종료 시간 -->
                <div class="form-group">
                    <label for="endTime">종료 시간</label>
                    <input type="time" id="endTime" name="endTime" class="form-control" />
                </div>
            </div>
            <div class="modal-footer">
                <button id="btnCancel" class="btn btn-secondary">취소</button>
                <button id="btnSave" class="btn btn-primary">저장</button>
                <button id="btnDelete" class="btn"
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
                    } 
                }
            });
            calendar.render();

            // 7) Modal 관련 요소 및 함수
            const modal = document.getElementById('scheduleModal');
            const modalTitle = document.getElementById('modalTitle');
            const selectTrainer = document.getElementById('username');   // 트레이너 드롭다운
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
                    selectTrainer.value = '';          // 트레이너 초기화
                    inputFacility.value = '';
                    inputDate.value = data.start;
                    inputStart.value = '09:00';
                    inputEnd.value = '10:00';
                    btnDelete.style.display = 'none';
                    currentScheduleId = null;
                } else if (mode === 'edit') {
                    modalTitle.textContent = '일정 삭제';
                    currentScheduleId = data.scheduleId;
                    // 수정 모드에서는 트레이너 선택 불가하므로 그대로 두거나, 서버에서 트레이너도 내려줘야 합니다.
                    selectTrainer.value = data.username || '';
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

                // (1) 트레이너 아이디 읽기
                const trainerUsername = selectTrainer.value;
                if (!trainerUsername) {
                    alert('트레이너를 선택하세요.');
                    return;
                }

                // (2) 나머지 값 읽기
                const facilityId = parseInt(inputFacility.value);
                const date = inputDate.value;
                const start = inputStart.value;
                const end = inputEnd.value;

                if (!facilityId || !date || !start || !end) {
                    alert('모든 필드를 입력하세요.');
                    return;
                }

                // (3) JSON 바디에 username 포함
                const vo = {
                    username:     trainerUsername,
                    facilityId:   facilityId,
                    scheduleDate: date,
                    startTime:    start + ":00",
                    endTime:      end   + ":00"
                };

                // (4) AJAX 요청
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
                    // 달력에 새 이벤트 추가
                    calendar.addEvent({
                        id: newVo.scheduleId,
                        title: newVo.username + ' / Facility ' + newVo.facilityId,
                        start: newVo.scheduleDate + 'T' + newVo.startTime,
                        end:   newVo.scheduleDate + 'T' + newVo.endTime,
                        extendedProps: {
                            username:   newVo.username,
                            facilityId: newVo.facilityId
                        }
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
