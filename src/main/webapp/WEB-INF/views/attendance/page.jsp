<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
<head>
    <meta charset="UTF-8">
    <title>출퇴근 관리</title>
    <c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
    <script async defer src="https://maps.googleapis.com/maps/api/js?key=${googleMapApiKey}&callback=initMap"></script>
    <style>
        /* 출퇴근 관리 전용 스타일 */
        .attendance-container {
            padding: 20px;
        }
        
        .attendance-header {
            margin-bottom: 30px;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        
        .attendance-header h2 {
            margin: 0;
            font-size: 1.8rem;
            font-weight: 300;
        }
        
        .attendance-controls {
            margin-bottom: 30px;
            text-align: center;
        }
        
        .attendance-controls button {
            padding: 12px 30px;
            font-size: 16px;
            font-weight: 500;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            margin: 0 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        #checkInBtn {
            background: linear-gradient(45deg, #4CAF50, #45a049);
            color: white;
        }
        
        #checkOutBtn {
            background: linear-gradient(45deg, #f44336, #d32f2f);
            color: white;
        }
        
        .attendance-controls button:hover:not(.disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }
        
        .attendance-controls button.disabled {
            background: #ddd !important;
            color: #666 !important;
            cursor: not-allowed;
            transform: none !important;
            box-shadow: none !important;
        }
        
        .hidden {
            display: none;
        }
        
        /* 월별 필터 스타일 개선 */
        .month-filter {
            margin-bottom: 30px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .month-filter h4 {
            margin-bottom: 15px;
            color: #333;
            font-weight: 500;
        }
        
        .filter-controls {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .filter-controls label {
            font-weight: 500;
            color: #555;
        }
        
        .filter-controls select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background: white;
            font-size: 14px;
        }
        
        .filter-controls button {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        #filterBtn {
            background: #007bff;
            color: white;
        }
        
        #resetBtn {
            background: #6c757d;
            color: white;
        }
        
        .filter-controls button:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }
        
        /* 현재 조회 월 표시 */
        .current-month {
            font-weight: 600;
            color: #007bff;
            margin-bottom: 20px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 5px;
            text-align: center;
        }
        
        /* 테이블 스타일 개선 */
        .attendance-table-container {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .attendance-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        
        .attendance-table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: center;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #dee2e6;
        }
        
        .attendance-table td {
            padding: 12px 15px;
            text-align: center;
            border-bottom: 1px solid #dee2e6;
        }
        
        .attendance-table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .attendance-table tbody tr:last-child td {
            border-bottom: none;
        }
        
        /* 지도 스타일 */
        .map-container {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-top: 30px;
        }
        
        .map-header {
            padding: 15px 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            font-weight: 600;
            color: #333;
        }
        
        #map {
            width: 100%;
            height: 400px;
        }
        
        /* 반응형 */
        @media (max-width: 768px) {
            .filter-controls {
                flex-direction: column;
                align-items: stretch;
            }
            
            .filter-controls > div {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            
            .attendance-controls button {
                display: block;
                width: 100%;
                margin: 10px 0;
            }
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
                    <div class="attendance-container">
                        <!-- 헤더 -->
                        <div class="attendance-header">
                            <h2>
                                <i class="fas fa-clock me-2"></i>
                                <c:choose>
                                    <c:when test="${not empty pageContext.request.userPrincipal}">
                                        ${pageContext.request.userPrincipal.name}
                                    </c:when>
                                    <c:otherwise>
                                        손님
                                    </c:otherwise>
                                </c:choose>
                                님의 출퇴근 관리
                            </h2>
                        </div>


                        <!-- 출퇴근 버튼 -->
                        <div class="attendance-controls">
                            <button id="checkInBtn" class="hidden">
                                <i class="fas fa-sign-in-alt me-2"></i>출근
                            </button>
                            <button id="checkOutBtn" class="hidden">
                                <i class="fas fa-sign-out-alt me-2"></i>퇴근
                            </button>
                        </div>
                        
                        <!-- 월별 필터 -->
                        <div class="month-filter">
                            <h4><i class="fas fa-filter me-2"></i>기간별 조회</h4>
                            <div class="filter-controls">
                                <div>
                                    <label for="yearSelect">년도:</label>
                                    <select id="yearSelect">
                                        <!-- JS에서 동적으로 채움 -->
                                    </select>
                                </div>
                                
                                <div>
                                    <label for="monthSelect">월:</label>
                                    <select id="monthSelect">
                                        <option value="1">1월</option>
                                        <option value="2">2월</option>
                                        <option value="3">3월</option>
                                        <option value="4">4월</option>
                                        <option value="5">5월</option>
                                        <option value="6">6월</option>
                                        <option value="7">7월</option>
                                        <option value="8">8월</option>
                                        <option value="9">9월</option>
                                        <option value="10">10월</option>
                                        <option value="11">11월</option>
                                        <option value="12">12월</option>
                                    </select>
                                </div>
                                
                                <div>
                                    <button id="filterBtn">
                                        <i class="fas fa-search me-1"></i>조회
                                    </button>
                                    <button id="resetBtn">
                                        <i class="fas fa-undo me-1"></i>전체 보기
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- 현재 조회 월 표시 -->
                        <div id="currentMonth" class="current-month"></div>

                        <!-- 출퇴근 기록 테이블 -->
                        <div class="attendance-table-container">
                            <table id="attendanceList" class="attendance-table">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-calendar-day me-2"></i>출근 날짜</th>
                                        <th><i class="fas fa-clock me-2"></i>출근 시간</th>
                                        <th><i class="fas fa-clock me-2"></i>퇴근 시간</th>
                                        <th><i class="fas fa-info-circle me-2"></i>상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- JS가 서버로부터 받은 근태 목록을 여기에 채웁니다 -->
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- 지도 -->
                        <div class="map-container">
                            <div class="map-header">
                                <i class="fas fa-map-marker-alt me-2"></i>현재 위치 및 회사 위치
                            </div>
                            <div id="map"></div>
                        </div>
                    </div>
                </div>
            </main>
            
            <c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (function() {
            const username     = '<sec:authentication property="name"/>';
            const contextPath  = '${pageContext.request.contextPath}';
            const checkInBtn   = document.getElementById('checkInBtn');
            const checkOutBtn  = document.getElementById('checkOutBtn');
            const tbody        = document.querySelector('#attendanceList tbody');
            
            // 월별 필터 요소들
            const yearSelect = document.getElementById('yearSelect');
            const monthSelect = document.getElementById('monthSelect');
            const filterBtn = document.getElementById('filterBtn');
            const resetBtn = document.getElementById('resetBtn');
            const currentMonth = document.getElementById('currentMonth');

            // 오늘자 가장 최신 ID/상태를 저장할 변수
            let latestAttendanceId = null;
            let latestStatus       = null;
            let isCheckedOut      = false;
            
            // 전체 근태 데이터를 저장할 변수
            let allAttendanceData = [];

            // 페이지 로드 시 초기화
            document.addEventListener('DOMContentLoaded', () => {
                initYearSelect();
                setCurrentMonth();
                fetchAttendanceList();
                
                // 이벤트 리스너 등록
                filterBtn.addEventListener('click', filterByMonth);
                resetBtn.addEventListener('click', showAllData);
            });
            
            // 년도 셀렉트박스 초기화 (현재 년도 기준으로 ±2년)
            function initYearSelect() {
                const currentYear = new Date().getFullYear();
                yearSelect.innerHTML = '';
                
                for (let year = currentYear - 2; year <= currentYear + 1; year++) {
                    const option = document.createElement('option');
                    option.value = year;
                    option.textContent = year + '년';
                    if (year === currentYear) {
                        option.selected = true;
                    }
                    yearSelect.appendChild(option);
                }
            }
            
            // 현재 월로 셀렉트박스 설정
            function setCurrentMonth() {
                const currentMonth = new Date().getMonth() + 1;
                monthSelect.value = currentMonth;
            }
            
            // 월별 필터링
            function filterByMonth() {
                const selectedYear = parseInt(yearSelect.value);
                const selectedMonth = parseInt(monthSelect.value);
                
                const filteredData = allAttendanceData.filter(vo => {
                    const voDate = new Date(vo.attendanceDate);
                    return voDate.getFullYear() === selectedYear && 
                           voDate.getMonth() + 1 === selectedMonth;
                });
                
                displayAttendanceData(filteredData);
                currentMonth.textContent = `${selectedYear}년 ${selectedMonth}월 근태 내역`;
            }
            
            // 전체 데이터 보기
            function showAllData() {
                displayAttendanceData(allAttendanceData);
                currentMonth.textContent = '전체 근태 내역';
            }
            
            // 테이블에 데이터 표시
            function displayAttendanceData(data) {
                tbody.innerHTML = '';
                data.forEach(vo => appendAttendanceRow(vo));
            }

            // 출근 버튼 클릭 이벤트
            checkInBtn.addEventListener('click', () => {
                if (checkInBtn.disabled) return;

                navigator.geolocation.getCurrentPosition(function(pos) {
                    const lat = pos.coords.latitude;
                    const lng = pos.coords.longitude;

                    const url = contextPath + '/attendance/checkIn?username=' + encodeURIComponent(username);
                    fetch(url, {
                         method: 'POST',
                         headers:{ 'Content-type': 'application/json' },
                         body: JSON.stringify({
                            username: username,
                            lat: lat,
                            lng: lng
                         })
                     })
                    .then(res => {
                        if (!res.ok) throw new Error('출근 처리 실패');
                        return res.json();
                    })
                    .then(vo => {
                        latestAttendanceId = vo.attendanceId;
                        latestStatus       = vo.status;
                        isCheckedOut       = false;

                        // 전체 데이터에 새 데이터 추가
                        allAttendanceData.unshift(vo);
                        
                        // 현재 필터 상태에 따라 표시 업데이트
                        if (currentMonth.textContent.includes('전체')) {
                            prependAttendanceRow(vo);
                        } else {
                            // 현재 필터링된 월과 새 데이터의 월이 같으면 표시
                            const selectedYear = parseInt(yearSelect.value);
                            const selectedMonth = parseInt(monthSelect.value);
                            const voDate = new Date(vo.attendanceDate);
                            
                            if (voDate.getFullYear() === selectedYear && 
                                voDate.getMonth() + 1 === selectedMonth) {
                                prependAttendanceRow(vo);
                            }
                        }
                        
                        updateButtonVisibility();
                    })
                    .catch(err => alert(err.message));	
                });
            });

            // 퇴근 버튼 클릭 이벤트
            checkOutBtn.addEventListener('click', () => {
                if (checkOutBtn.disabled || isCheckedOut) return;
                if (!latestAttendanceId) return;

                const url = contextPath + '/attendance/checkOut?attendanceId=' + latestAttendanceId;
                fetch(url, { method: 'POST' })
                .then(res => {
                    if (!res.ok) throw new Error('퇴근 처리 실패');
                    return res.json();
                })
                .then(vo => {
                    isCheckedOut = true;

                    if (latestStatus === '정상출근') {
                        latestStatus = '퇴근';
                    }
                    
                    // 전체 데이터에서 해당 항목 업데이트
                    const index = allAttendanceData.findIndex(item => item.attendanceId === latestAttendanceId);
                    if (index !== -1) {
                        allAttendanceData[index] = vo;
                    }

                    updateLatestRow(vo);
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
                    // 전체 데이터 저장
                    allAttendanceData = list;
                    
                    // 초기에는 전체 데이터 표시
                    displayAttendanceData(list);
                    currentMonth.textContent = '전체 근태 내역';
                    
                    determineLatestStatus(list);
                    if (latestStatus === '퇴근' || hadCheckoutTime(list)) {
                        isCheckedOut = true;
                    } else {
                        isCheckedOut = false;
                    }
                    updateButtonVisibility();
                })
                .catch(err => {
                    console.error(err);
                    checkInBtn.classList.add('hidden');
                    checkOutBtn.classList.add('hidden');
                });
            }

            // 테이블 최상단 행(맨 위)에 퇴근 시간과 상태를 업데이트
            function updateLatestRow(vo) {
                const firstRow = tbody.querySelector('tr');
                if (!firstRow) return;
                const cells = firstRow.children;
                cells[2].textContent = formatTime(vo.checkoutTime);
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

            function determineLatestStatus(list) {
                const now    = new Date();
                const todayY = now.getFullYear();
                const todayM = now.getMonth();
                const todayD = now.getDate();

                const todayRecords = list.filter(vo => {
                    const voDate = new Date(vo.attendanceDate);
                    return (
                        voDate.getFullYear() === todayY &&
                        voDate.getMonth()    === todayM &&
                        voDate.getDate()     === todayD
                    );
                });

                console.log("▶ todayRecords after Date filter:", todayRecords);

                if (todayRecords.length === 0) {
                    latestAttendanceId = null;
                    latestStatus       = null;
                } else {
                    const mostRecent = todayRecords.reduce((prev, curr) => {
                        return (prev.attendanceId > curr.attendanceId) ? prev : curr;
                    });
                    latestAttendanceId = mostRecent.attendanceId;
                    latestStatus       = mostRecent.status;
                }
            }

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
                        return vo.checkoutTime && vo.checkoutTime.trim() !== '';
                    }
                    return false;
                });
            }

            function updateButtonVisibility() {
                if (!latestAttendanceId || latestStatus === null) {
                    checkInBtn.classList.remove('hidden');
                    checkInBtn.classList.remove('disabled');
                    checkInBtn.disabled = false;
                    checkOutBtn.classList.add('hidden');
                }
                else if (
                    latestStatus === '정상출근' ||
                    latestStatus === '지각'    ||
                    latestStatus === '결근'
                ) {
                    checkInBtn.classList.add('hidden');
                    checkOutBtn.classList.remove('hidden');
                    if (isCheckedOut) {
                        checkOutBtn.classList.add('disabled');
                        checkOutBtn.disabled = true;
                    } else {
                        checkOutBtn.classList.remove('disabled');
                        checkOutBtn.disabled = false;
                    }
                }
                else if (latestStatus === '퇴근') {
                    checkInBtn.classList.add('hidden');
                    checkOutBtn.classList.remove('hidden');
                    checkOutBtn.classList.add('disabled');
                    checkOutBtn.disabled = true;
                }
            }

            function getToday() {
                const d = new Date();
                const yyyy = d.getFullYear();
                const mm   = String(d.getMonth() + 1).padStart(2, '0');
                const dd   = String(d.getDate()).padStart(2, '0');
                return `${yyyy}-${mm}-${dd}`;
            }

            function formatTime(timeStr) {
                if (!timeStr) return '';
                return timeStr.length > 5 ? timeStr.substring(0,5) : timeStr;
            }
        })();
        
        
        function initMap() {
            const map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: 37.476502, lng: 126.880193 },
                zoom: 16,
            });

            navigator.geolocation.getCurrentPosition(function(pos) {
                const myPos = {
                    lat: pos.coords.latitude,
                    lng: pos.coords.longitude
                };

                new google.maps.Marker({
                    position: myPos,
                    map: map,
                    label: "나",
                    icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"
                });

                map.setCenter(myPos);
            });

            const officePos = { lat: 37.476502, lng: 126.880193 };
            new google.maps.Marker({
                position: officePos,
                map: map,
                label: "회사",
                icon: "http://maps.google.com/mapfiles/ms/icons/red-dot.png"
            });
        }

        window.initMap = initMap;
    </script>
</body>
</html>