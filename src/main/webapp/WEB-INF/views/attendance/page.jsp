<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec"     uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>출퇴근 관리</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h2 {
            margin-bottom: 20px;
        }
        #buttons {
            margin-bottom: 20px;
        }
        #buttons button {
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
        }
        /* 비활성화 상태 스타일 */
        #buttons button.disabled {
            background-color: #ddd;
            color: #666;
            cursor: not-allowed;
        }
        /* 숨김 처리 */
        .hidden {
            display: none;
        }
        #attendanceList {
            width: 100%;
            border-collapse: collapse;
        }
        #attendanceList th, #attendanceList td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        #attendanceList th {
            background-color: #f4f4f4;
        }
    </style>
</head>
<body>
    <h2>
        
        <c:choose>
            <c:when test="${not empty pageContext.request.userPrincipal}">
                ${pageContext.request.userPrincipal.name}
            </c:when>
            <c:otherwise>
                손님
            </c:otherwise>
        </c:choose>
       님 출/퇴근
    </h2>

    <div id="buttons">
        <!-- 출근/퇴근 버튼 (둘 다 준비해 두되, JS에서 보이거나 숨김 처리) -->
        <button id="checkInBtn" class="hidden">출근</button>
        <button id="checkOutBtn" class="hidden">퇴근</button>
    </div>

    <table id="attendanceList">
        <thead>
            <tr>
                <th>출근 날짜</th>
                <th>출근 시간</th>
                <th>퇴근 시간</th>
                <th>상태</th>
            </tr>
        </thead>
        <tbody>
            <!-- JS가 서버로부터 받은 근태 목록을 여기에 채웁니다 -->
        </tbody>
    </table>

    <script>
        (function() {
            const username     = '<sec:authentication property="name"/>';
            const contextPath  = '${pageContext.request.contextPath}';
            const checkInBtn   = document.getElementById('checkInBtn');
            const checkOutBtn  = document.getElementById('checkOutBtn');
            const tbody        = document.querySelector('#attendanceList tbody');

            // 오늘자 가장 최신 ID/상태를 저장할 변수
            let latestAttendanceId = null;
            let latestStatus       = null;
            // “퇴근” 버튼을 눌러 체크아웃을 한 뒤에는 true로 바꿔서 다시 누르지 못하도록 제어
            let isCheckedOut      = false;

            // 페이지 로드 시 근태 목록 가져오기
            document.addEventListener('DOMContentLoaded', () => {
                fetchAttendanceList();
            });

            // 출근 버튼 클릭 이벤트
            checkInBtn.addEventListener('click', () => {
                if (checkInBtn.disabled) return;
                const url = contextPath + '/attendance/checkIn?username=' + encodeURIComponent(username);
                fetch(url, { method: 'POST' })
                .then(res => {
                    if (!res.ok) throw new Error('출근 처리 실패');
                    return res.json();
                })
                .then(vo => {
                    // 서버로부터 응답받은 VO의 attendanceId, status를 갱신
                    latestAttendanceId = vo.attendanceId;
                    latestStatus       = vo.status; // 정상출근/지각/결근
                    isCheckedOut       = false;    // 아직 체크아웃 전이므로 false

                    // 테이블 맨 위에 새로운 출근 기록 추가
                    prependAttendanceRow(vo);
                    // 버튼 표시/숨김 및 활성화 상태 업데이트
                    updateButtonVisibility();
                })
                .catch(err => alert(err.message));
            });

            // 퇴근 버튼 클릭 이벤트
            checkOutBtn.addEventListener('click', () => {
                // 이미 체크아웃한 상태이거나 버튼이 비활성화 상태라면 리턴
                if (checkOutBtn.disabled || isCheckedOut) return;
                if (!latestAttendanceId) return;

                // 방어 코드: 지각/결근인 경우에도 요청은 보내지만, 
                // 클라이언트에서는 상태를 바꾸지 않음 → 서버에서 checkoutTime만 업데이트
                const url = contextPath + '/attendance/checkOut?attendanceId=' + latestAttendanceId;
                fetch(url, { method: 'POST' })
                .then(res => {
                    if (!res.ok) throw new Error('퇴근 처리 실패');
                    return res.json();
                })
                .then(vo => {
                    // 1) isCheckedOut을 true로 바꿔서 더는 퇴근 버튼을 누르지 못하도록
                    isCheckedOut = true;

                    // 2) “정상출근” 상태에서만 latestStatus를 “퇴근”으로 변경
                    if (latestStatus === '정상출근') {
                        latestStatus = '퇴근';
                    }
                    // “지각” 또는 “결근”인 경우에는 latestStatus를 그대로 둡니다.

                    // 3) 테이블 최신 행(맨 위)만 퇴근 시간만 업데이트
                    updateLatestRow(vo);
                    // 4) 버튼 상태 업데이트
                    updateButtonVisibility();
                })
                .catch(err => alert(err.message));
            });

            // 서버에서 내 개인 근태 목록을 조회하여 테이블에 표시
            function fetchAttendanceList() {
                const url = contextPath + '/attendance/user?username=' + encodeURIComponent(username);
                fetch(url)
                .then(res => {
                    if (!res.ok) throw new Error('목록 조회 실패');
                    return res.json();
                })
                .then(list => {
                    // 1) 테이블 초기화
                    tbody.innerHTML = '';
                    // 2) 전체 내역을 순서대로 하단에 append
                    list.forEach(vo => appendAttendanceRow(vo));
                    // 3) todayRecords를 찾아서 latestAttendanceId, latestStatus 설정
                    determineLatestStatus(list);
                    // 4) 만약 todayRecords 중 마지막 요소(vo)에 checkoutTime이 있다면
                    //    이미 체크아웃된 상태임을 표시
                    if (latestStatus === '퇴근' || hadCheckoutTime(list)) {
                        isCheckedOut = true;
                    } else {
                        isCheckedOut = false;
                    }
                    // 5) 버튼 표시/숨김 및 활성/비활성 업데이트
                    updateButtonVisibility();
                })
                .catch(err => {
                    console.error(err);
                    // 오류 시 두 버튼 모두 숨김
                    checkInBtn.classList.add('hidden');
                    checkOutBtn.classList.add('hidden');
                });
            }

            // 테이블 최상단 행(맨 위)에 퇴근 시간과 상태를 업데이트
            function updateLatestRow(vo) {
                const firstRow = tbody.querySelector('tr');
                if (!firstRow) return;
                const cells = firstRow.children;
                // 3번째 셀(퇴근 시간)만 vo.checkoutTime으로 교체
                cells[2].textContent = formatTime(vo.checkoutTime);
                // 4번째 셀(상태)는
                //   - 최신 상태가 “정상출근”이었으면 “퇴근”으로 바꿔주고
                //   - “지각”/“결근”인 경우에는 아무 변화 없이 그대로 두기
                if (latestStatus === '퇴근') {
                    cells[3].textContent = '퇴근';
                }
            }

            // 새로운 VO를 테이블 맨 위에 삽입 (출근 직후)
            function prependAttendanceRow(vo) {
                const tr = createRow(vo);
                tbody.insertBefore(tr, tbody.firstChild);
            }

            // VO를 테이블 맨 아래에 추가 (초기 로드)
            function appendAttendanceRow(vo) {
                const tr = createRow(vo);
                tbody.appendChild(tr);
            }

            // AttendanceVO 하나로 <tr>를 만들어 리턴
            function createRow(vo) {
                const tr = document.createElement('tr');

                const tdDate   = document.createElement('td');
                const tdIn     = document.createElement('td');
                const tdOut    = document.createElement('td');
                const tdStatus = document.createElement('td');

                tdDate.textContent   = vo.attendanceDate;
                tdIn.textContent     = formatTime(vo.checkinTime);
                tdOut.textContent    = vo.checkoutTime ? formatTime(vo.checkoutTime) : '';
                tdStatus.textContent = vo.status;

                tr.appendChild(tdDate);
                tr.appendChild(tdIn);
                tr.appendChild(tdOut);
                tr.appendChild(tdStatus);
                return tr;
            }

            // 서버에서 내려온 list(AttendanceVO 배열) 중에서 “오늘자” 레코드만 골라
            // attendanceId가 가장 큰(=가장 최근) VO를 찾아 latestAttendanceId, latestStatus를 설정
            function determineLatestStatus(list) {
                // 오늘 연/월/일을 구함
                const now    = new Date();
                const todayY = now.getFullYear();
                const todayM = now.getMonth();   // 0~11
                const todayD = now.getDate();

                // 오늘자 기록만 필터
                const todayRecords = list.filter(vo => {
                    const voDate = new Date(vo.attendanceDate);
                    return (
                        voDate.getFullYear() === todayY &&
                        voDate.getMonth()    === todayM &&
                        voDate.getDate()     === todayD
                    );
                });

                // 디버그용(콘솔에 오늘자 필터 결과를 찍어봅니다)
                console.log("▶ todayRecords after Date filter:", todayRecords);

                if (todayRecords.length === 0) {
                    latestAttendanceId = null;
                    latestStatus       = null;
                } else {
                    // attendanceId가 가장 큰(=가장 최근) VO를 reduce로 선택
                    const mostRecent = todayRecords.reduce((prev, curr) => {
                        return (prev.attendanceId > curr.attendanceId) ? prev : curr;
                    });
                    latestAttendanceId = mostRecent.attendanceId;
                    latestStatus       = mostRecent.status;
                }
            }

            // “정상출근”, “지각”, “결근” 상태에서도 체크아웃 시간이 이미 들어왔는지 확인
            // 오늘자 레코드 중 checkoutTime 프로퍼티가 non-null인 VO가 있으면 true 리턴
            function hadCheckoutTime(list) {
                const now = new Date();
                const todayY = now.getFullYear();
                const todayM = now.getMonth();
                const todayD = now.getDate();

                return list.some(vo => {
                    const voDate = new Date(vo.attendanceDate);
                    if (
                        voDate.getFullYear() === todayY &&
                        voDate.getMonth()    === todayM &&
                        voDate.getDate()     === todayD
                    ) {
                        // 체크아웃 시간이 non-null/빈 문자열이 아니면 이미 체크아웃한 것
                        return vo.checkoutTime && vo.checkoutTime.trim() !== '';
                    }
                    return false;
                });
            }

            // 버튼 표시/숨김 및 활성/비활성 상태 결정
            function updateButtonVisibility() {
                // 1) 오늘자 기록이 없으면 → “출근” 버튼만 보이게, “퇴근” 숨김
                if (!latestAttendanceId || latestStatus === null) {
                    checkInBtn.classList.remove('hidden');
                    checkInBtn.classList.remove('disabled');
                    checkInBtn.disabled = false;

                    checkOutBtn.classList.add('hidden');
                }
                // 2) 출근했지만 퇴근 전상태(정상출근/지각/결근)이라면 → “퇴근” 버튼만 보이게
                //    단, 체크아웃 시간을 이미 찍었으면 “퇴근” 버튼을 비활성화
                else if (
                    latestStatus === '정상출근' ||
                    latestStatus === '지각'    ||
                    latestStatus === '결근'
                ) {
                    checkInBtn.classList.add('hidden');

                    checkOutBtn.classList.remove('hidden');
                    // 이미 체크아웃 했으면 비활 상태, 아니면 활성화
                    if (isCheckedOut) {
                        checkOutBtn.classList.add('disabled');
                        checkOutBtn.disabled = true;
                    } else {
                        checkOutBtn.classList.remove('disabled');
                        checkOutBtn.disabled = false;
                    }
                }
                // 3) 이미 “퇴근” 상태라면 → “퇴근” 버튼 비활성화 상태로만 보이기
                else if (latestStatus === '퇴근') {
                    checkInBtn.classList.add('hidden');

                    checkOutBtn.classList.remove('hidden');
                    checkOutBtn.classList.add('disabled');
                    checkOutBtn.disabled = true;
                }
            }

            // 오늘 날짜 “YYYY-MM-DD” 문자열을 반환
            function getToday() {
                const d = new Date();
                const yyyy = d.getFullYear();
                const mm   = String(d.getMonth() + 1).padStart(2, '0');
                const dd   = String(d.getDate()).padStart(2, '0');
                return `${yyyy}-${mm}-${dd}`;
            }

            // “HH:MM:SS” 또는 “HH:MM” → “HH:MM”만 반환
            function formatTime(timeStr) {
                if (!timeStr) return '';
                return timeStr.length > 5 ? timeStr.substring(0,5) : timeStr;
            }
        })();
    </script>
</body>
</html>
