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
            margin-right: 10px;
            font-size: 16px;
            cursor: pointer;
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
        .disabled {
            background-color: #ddd;
            color: #666;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
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

    <div id="buttons">
        <button id="checkInBtn">출근</button>
        <button id="checkOutBtn" class="disabled" disabled>퇴근</button>
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
            <!-- JS가 채워 넣음 -->
        </tbody>
    </table>

    <script>
        (function() {
            const username = '<sec:authentication property="name"/>';
            const contextPath = '${pageContext.request.contextPath}';
            const checkInBtn  = document.getElementById('checkInBtn');
            const checkOutBtn = document.getElementById('checkOutBtn');
            const tbody       = document.querySelector('#attendanceList tbody');

            let latestAttendanceId = null;
            let latestStatus       = null;

            // 페이지 로드 시 본인 근태 목록 불러오기 및 버튼 상태 결정
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
                    // 출근 성공 시
                    latestAttendanceId = vo.attendanceId;
                    // 서비스에서는 "정상출근", "지각", "결근" 중 하나를 status로 넘겨줍니다.
                    latestStatus       = vo.status;
                    toggleButtons();
                    prependAttendanceRow(vo);
                })
                .catch(err => {
                    alert(err.message);
                });
            });

            // 퇴근 버튼 클릭 이벤트
            checkOutBtn.addEventListener('click', () => {
                if (checkOutBtn.disabled) return;
                if (!latestAttendanceId) return;
                const url = contextPath + '/attendance/checkOut?attendanceId=' + latestAttendanceId;
                fetch(url, { method: 'POST' })
                .then(res => {
                    if (!res.ok) throw new Error('퇴근 처리 실패');
                    return res.json();
                })
                .then(vo => {
                    // 퇴근 성공 시
                    latestStatus = '퇴근';
                    toggleButtons();
                    updateLatestRow(vo);
                })
                .catch(err => {
                    alert(err.message);
                });
            });

            // 본인 근태 목록을 불러와 테이블에 표시
            function fetchAttendanceList() {
                const url = contextPath + '/attendance/user?username=' + encodeURIComponent(username);
                fetch(url)
                .then(res => {
                    if (!res.ok) throw new Error('목록 조회 실패');
                    return res.json();
                })
                .then(list => {
                    tbody.innerHTML = '';
                    list.forEach(vo => appendAttendanceRow(vo));
                    determineButtonState(list);
                })
                .catch(err => {
                    console.error(err);
                });
            }

            // 테이블에 새로운 행을 앞으로 추가 (출근 직후)
            function prependAttendanceRow(vo) {
                const tr = createRow(vo);
                tbody.insertBefore(tr, tbody.firstChild);
            }

            // 테이블에 행 추가 (기존 리스트 로드)
            function appendAttendanceRow(vo) {
                const tr = createRow(vo);
                tbody.appendChild(tr);
            }

            // 최신 행(가장 위 행)에서 퇴근 시간과 상태를 업데이트
            function updateLatestRow(vo) {
                const firstRow = tbody.querySelector('tr');
                if (!firstRow) return;
                const cells = firstRow.children;
                // 퇴근 시간 칸(3번째 칸, index 2)
                cells[2].textContent = formatTime(vo.checkoutTime);
                // 상태 칸(4번째 칸, index 3)
                cells[3].textContent = '퇴근';
            }

            // 새로운 AttendanceVO로 테이블 행 생성
            function createRow(vo) {
                const tr = document.createElement('tr');

                // 출근 날짜
                const tdDate = document.createElement('td');
                tdDate.textContent = vo.attendanceDate;
                tr.appendChild(tdDate);

                // 출근 시간
                const tdIn = document.createElement('td');
                tdIn.textContent = formatTime(vo.checkinTime);
                tr.appendChild(tdIn);

                // 퇴근 시간 (퇴근 전이면 빈 칸)
                const tdOut = document.createElement('td');
                tdOut.textContent = vo.checkoutTime ? formatTime(vo.checkoutTime) : '';
                tr.appendChild(tdOut);

                // 상태
                const tdStatus = document.createElement('td');
                tdStatus.textContent = vo.status;
                tr.appendChild(tdStatus);

                // 최신 레코드 정보 갱신
                const today = getToday();
                if (!latestAttendanceId && vo.attendanceDate === today) {
                    latestAttendanceId = vo.attendanceId;
                    latestStatus       = vo.status;
                }

                return tr;
            }

            // 버튼 활성화/비활성화 토글
            function toggleButtons() {
                // 수정: latestStatus가 "정상출근", "지각", "결근" 중 하나이면 "퇴근" 버튼을 활성화,
                // 출근("checkIn")은 비활성화. 그 외(= latestStatus가 "퇴근"이거나 null)이면 출근 버튼만 활성화.
                if (latestStatus === '정상출근' || latestStatus === '지각' || latestStatus === '결근') {
                    // 이미 출근했거나 지각/결근 상태 → 출근 버튼 비활성, 퇴근 버튼 활성
                    checkInBtn.classList.add('disabled');
                    checkInBtn.disabled = true;
                    checkOutBtn.classList.remove('disabled');
                    checkOutBtn.disabled = false;
                } else {
                    // 아직 출근 전이거나, 이미 퇴근한 경우 → 출근 버튼 활성, 퇴근 버튼 비활성
                    checkInBtn.classList.remove('disabled');
                    checkInBtn.disabled = false;
                    checkOutBtn.classList.add('disabled');
                    checkOutBtn.disabled = true;
                }
            }

            // 초기 상태 결정: 오늘자 최신 레코드가 있는지, 상태가 출근(정상/지각/결근)인지
            function determineButtonState(list) {
                const today = getToday();
                // list 배열에서 오늘자 항목만 필터링
                const todayRecords = list.filter(vo => vo.attendanceDate === today);

                if (todayRecords.length === 0) {
                    // 오늘 기록이 없으면 “아직 출근 전” 상태
                    latestAttendanceId = null;
                    latestStatus       = null;
                } else {
                    // 오늘자 기록이 있으면 가장 최근(첫 번째) 항목을 최신으로 간주
                    const mostRecent = todayRecords[0];
                    latestAttendanceId = mostRecent.attendanceId;
                    latestStatus       = mostRecent.status;
                }
                toggleButtons();
            }

            // 현재 날짜를 "YYYY-MM-DD" 형식으로 반환
            function getToday() {
                const d = new Date();
                const yyyy = d.getFullYear();
                const mm   = String(d.getMonth() + 1).padStart(2, '0');
                const dd   = String(d.getDate()).padStart(2, '0');
                return `${yyyy}-${mm}-${dd}`;
            }

            // "HH:MM:SS" 또는 "HH:MM" 형식으로 표시
            function formatTime(timeStr) {
                if (!timeStr) return '';
                return timeStr.length > 5 ? timeStr.substring(0,5) : timeStr;
            }
        })();
    </script>
</body>
</html>
