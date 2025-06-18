<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 근태관리 시스템</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }
        
        .header {
            padding: 15px 0;
        }
        
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        
        .header h1 {
            font-size: 24px;
            font-weight: normal;
        }
        
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        
        .control-panel {
            background: white;
            padding: 20px;
            border: 1px solid #dee2e6;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .search-section {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-section input, .search-section select {
            padding: 8px 12px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            background: #007bff;
            color: white;
        }
        
        .btn:hover {
            background: #0056b3;
        }
        
        .btn-success {
            background: #28a745;
        }
        
        .btn-success:hover {
            background: #1e7e34;
        }
        
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border: 1px solid #dee2e6;
            text-align: center;
        }
        
        .stat-card .number {
            font-size: 2em;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-card .label {
            color: #666;
            font-size: 14px;
        }
        
        .stat-card.total .number { color: #007bff; }
        .stat-card.present .number { color: #28a745; }
        .stat-card.late .number { color: #ffc107; }
        .stat-card.absent .number { color: #dc3545; }
        
        .table-container {
            background: white;
            border: 1px solid #dee2e6;
        }
        
        .table-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .table-header h2 {
            font-size: 18px;
            font-weight: normal;
        }
        
        #attendanceTable {
            width: 100%;
            border-collapse: collapse;
        }
        
        #attendanceTable th {
            padding: 12px;
            text-align: left;
            font-weight: 600;
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        
        #attendanceTable td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
        }
        
        #attendanceTable tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-present { background: #d4edda; color: #155724; }
        .status-late { background: #fff3cd; color: #856404; }
        .status-absent { background: #f8d7da; color: #721c24; }
        
        .loading, .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        @media (max-width: 768px) {
            .control-panel {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-section {
                flex-direction: column;
            }
            
            .search-section input, .search-section select {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1>근태관리 시스템</h1>
            <div class="admin-info">
                <span>관리자</span>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- 통계 카드 -->
        <div class="stats-cards">
            <div class="stat-card total">
                <div class="number" id="totalCount">0</div>
                <div class="label">전체 트레이너</div>
            </div>
            <div class="stat-card present">
                <div class="number" id="presentCount">0</div>
                <div class="label">출근</div>
            </div>
            <div class="stat-card late">
                <div class="number" id="lateCount">0</div>
                <div class="label">지각</div>
            </div>
            <div class="stat-card absent">
                <div class="number" id="absentCount">0</div>
                <div class="label">결근</div>
            </div>
        </div>

        <!-- 제어 패널 -->
        <div class="control-panel">
            <div class="search-section">
                <input type="text" id="searchUser" placeholder="트레이너명 검색...">
                <input type="date" id="searchDate" value="">
                <select id="statusFilter">
                    <option value="">전체 상태</option>
                    <option value="present">출근</option>
                    <option value="late">지각</option>
                    <option value="absent">결근</option>
                </select>
                <button class="btn" onclick="filterData()">검색</button>
            </div>
            <div>
                <button class="btn btn-success" onclick="exportToExcel()">Excel 내보내기</button>
                <button class="btn" onclick="loadAttendanceData()">새로고침</button>
            </div>
        </div>

        <!-- 출석 테이블 -->
        <div class="table-container">
            <div class="table-header">
                <h2>출석 현황</h2>
                <span id="lastUpdate">최종 업데이트: -</span>
            </div>
            
            <div id="loadingDiv" class="loading">
                데이터를 불러오는 중...
            </div>
            
            <table id="attendanceTable" style="display: none;">
                <thead>
                    <tr>
                        <th>트레이너명</th>
                        <th>출근시간</th>
                        <th>퇴근시간</th>
                        <th>근무시간</th>
                        <th>상태</th>
                        <th>날짜</th>
                        <th>수정</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
            
            <div id="noDataDiv" class="no-data" style="display: none;">
                표시할 데이터가 없습니다.
            </div>
        </div>
    </div>

    <script>
        let originalData = [];
        let totalTrainers = 0;
        
        $(document).ready(function() {
            // 오늘 날짜를 기본값으로 설정
            document.getElementById('searchDate').value = new Date().toISOString().split('T')[0];
            
            // 페이지 로드시 데이터 가져오기
            loadTrainerCount();
            loadAttendanceData();
        });

        // 전체 트레이너 수 조회
        function loadTrainerCount() {
            $.ajax({
                url: '${pageContext.request.contextPath}/attendance/trainer-count',
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    totalTrainers = data.totalTrainers;
                },
                error: function(xhr, status, error) {
                    console.error('트레이너 수 조회 실패:', error);
                    totalTrainers = 0;
                }
            });
        }

        function loadAttendanceData() {
            showLoading();
            
            const searchDate = $('#searchDate').val();
            let url = '${pageContext.request.contextPath}/attendance/';
            
            // 날짜가 선택되어 있으면 해당 날짜, 없으면 오늘 데이터
            if (searchDate) {
                url += 'date/' + searchDate;
            } else {
                url += 'today';
            }
            
            $.ajax({
                url: url,
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    console.log('데이터 받아옴:', data);
                    originalData = data;
                    displayAttendanceList(data);
                    updateStatistics(data);
                    updateLastUpdateTime();
                    hideLoading();
                },
                error: function(xhr, status, error) {
                    console.error('에러 발생:', error);
                    hideLoading();
                    showNoData();
                    alert('데이터를 불러오는데 실패했습니다.');
                }
            });
        }

        function displayAttendanceList(attendanceList) {
            if (!attendanceList || attendanceList.length === 0) {
                showNoData();
                return;
            }
            
            let html = '';
            attendanceList.forEach(function(attendance) {
            	   console.log("attendance 객체:", attendance);
                const workHours = calculateWorkHours(attendance.checkinTime, attendance.checkoutTime);
                const status = getAttendanceStatus(attendance.checkinTime, attendance.checkoutTime);
                const statusBadge = getStatusBadge(status);
                
                html += '<tr>';
                html += '<td><strong>' + (attendance.name || attendance.username || '미등록') + '</strong></td>';
                html += '<td>' + formatTime(attendance.checkinTime) + '</td>';
                html += '<td>' + formatTime(attendance.checkoutTime) + '</td>';
                html += '<td>' + workHours + '</td>';
                html += '<td>' + statusBadge + '</td>';
                html += '<td>' + formatDate(attendance.checkinTime) + '</td>';
                html += '<td><button class="btn btn-sm btn-primary" onclick="openEditModal(' +
                attendance.attendanceId + ', \'' + attendance.checkinTime + '\', \'' + attendance.checkoutTime + '\')">수정</button></td>';
                html += '</tr>';

            });
            
            $('#attendanceTable tbody').html(html);
            $('#attendanceTable').show();
            $('#noDataDiv').hide();
        }

        function updateStatistics(data) {
            let attendedCount = data.length; // 실제 출석한 트레이너 수
            let presentCount = 0;
            let lateCount = 0;
            let absentCount = totalTrainers - attendedCount; // 전체 트레이너 수에서 출석한 수를 뺀 값
            
            data.forEach(function(attendance) {
                const status = getAttendanceStatus(attendance.checkinTime, attendance.checkoutTime);
                switch(status) {
                    case 'present': presentCount++; break;
                    case 'late': lateCount++; break;
                }
            });	
            
            $('#totalCount').text(totalTrainers);
            $('#presentCount').text(presentCount);
            $('#lateCount').text(lateCount);
            $('#absentCount').text(absentCount);
        }

                function getAttendanceStatus(checkinTime, checkoutTime) {
            if (!checkinTime) return 'absent'; // 출근 기록 없으면 결근

            const timeStr = checkinTime.toString();
            const timeParts = timeStr.split(':');
            const hour = parseInt(timeParts[0]);
            const minute = parseInt(timeParts[1]);

            const checkinMinutes = hour * 60 + minute;
            const nineAM = 9 * 60;         // 540분
            const nineThirty = 9 * 60 + 30; // 570분

            if (checkinMinutes <= nineAM) {
                return 'present'; // 정상출근
            } else if (checkinMinutes <= nineThirty) {
                return 'late';    // 지각
            } else {
                return 'absent';  // 결근
            }
        }

        function getStatusBadge(status) {
            const badges = {
                'present': '<span class="status-badge status-present">출근</span>',
                'late': '<span class="status-badge status-late">지각</span>',
                'absent': '<span class="status-badge status-absent">결근</span>'
            };
            return badges[status] || badges['absent'];
        }

        function calculateWorkHours(checkinTime, checkoutTime) {
            if (!checkinTime || !checkoutTime) return '-';
            
            try {
                // 시간 문자열을 Date 객체로 변환
                const checkin = new Date('2000-01-01 ' + checkinTime);
                const checkout = new Date('2000-01-01 ' + checkoutTime);
                
                if (checkout <= checkin) return '-';
                
                const diffMs = checkout - checkin;
                const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
                const diffMinutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));
                
                return diffHours + '시간 ' + diffMinutes + '분';
            } catch (e) {
                return '-';
            }
        }

        function formatTime(timeString) {
            if (!timeString) return '-';
            
            // LocalTime 객체인 경우 문자열로 변환
            if (typeof timeString === 'object' && timeString.hour !== undefined) {
                const hour = String(timeString.hour).padStart(2, '0');
                const minute = String(timeString.minute).padStart(2, '0');
                const second = String(timeString.second || 0).padStart(2, '0');
                return hour + ':' + minute + ':' + second;
            }
            
            // 이미 문자열인 경우 그대로 반환 (필요하면 포맷 조정)
            return timeString.toString().substring(0, 8);
        }

        function formatDate(timeString) {
            if (!timeString) return new Date().toLocaleDateString('ko-KR');
            
            // 현재 날짜 반환 (실제로는 attendance 객체에 날짜 필드가 있어야 함)
            return new Date().toLocaleDateString('ko-KR');
        }

        function filterData() {
            const searchUser = $('#searchUser').val().toLowerCase();
            const searchDate = $('#searchDate').val();
            const statusFilter = $('#statusFilter').val();
            
            // 날짜가 변경되었으면 새로 데이터를 로드
            loadAttendanceData();
            
            // 사용자명과 상태로 필터링
            setTimeout(function() {
                let filteredData = originalData.filter(function(attendance) {
                	const matchUser = !searchUser || (attendance.NAME && attendance.NAME.includes(searchUser));
                    const matchStatus = !statusFilter || getAttendanceStatus(attendance.checkinTime, attendance.checkoutTime) === statusFilter;
                    
                    return matchUser && matchStatus;
                });
                
                displayAttendanceList(filteredData);
                updateStatistics(filteredData);
            }, 500);
        }

        function exportToExcel() {
            // 실제 구현 시에는 서버에서 Excel 파일을 생성하여 다운로드
            const searchDate = $('#searchDate').val() || new Date().toISOString().split('T')[0];
            window.location.href = '${pageContext.request.contextPath}/attendance/export/excel?date=' + searchDate;
        }

        function showLoading() {
            $('#loadingDiv').show();
            $('#attendanceTable').hide();
            $('#noDataDiv').hide();
        }

        function hideLoading() {
            $('#loadingDiv').hide();
        }

        function showNoData() {
            $('#attendanceTable').hide();
            $('#noDataDiv').show();
        }

        function updateLastUpdateTime() {
            const now = new Date();
            const timeString = now.toLocaleString('ko-KR');
            $('#lastUpdate').text('최종 업데이트: ' + timeString);
        }

        function openEditModal(id, checkin, checkout){
            $('#editId').val(id);
            $('#editCheckin').val(checkin);
            $('#editCheckout').val(checkout);
            $('#editReason').val('');
            $('#editModal').show();

        }

        function submitEdit(){
            const id = $('#editId').val();
            const checkin = $('#editCheckin').val();
            const checkout = $('#editCheckout').val();
            const reason = $('#editReason').val();

              console.log("보내는 데이터:", { id, checkin, checkout, reason });

            $.ajax({
                url:'${pageContext.request.contextPath}/attendance/admin/update',
                type:'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    attendanceId: id,
                    checkinTime: checkin,
                    checkoutTime: checkout,
                    updateReason: reason
                }),
                success: function(){
                    alert('수정완료');
                    $('#editModal').hide();
                    loadAttendanceData(); // 새로고침
                },
                error: function(){
                    alert('수정 실패')
                }
            });

        }





    </script>



<div id="editModal" style="display:none; position:fixed; top:20%; left:50%; transform:translateX(-50%); background:white; padding:20px; border:1px solid #ccc; z-index:999;">
    <h3>근무시간 수정</h3>
    <input type="hidden" id="editId">
    <label>출근시간: <input type="time" id="editCheckin"></label><br><br>
    <label>퇴근시간: <input type="time" id="editCheckout"></label><br><br>
    <label>사유: <input type="text" id="editReason"></label><br><br>
    <button onclick="submitEdit()">저장</button>
    <button onclick="$('#editModal').hide()">닫기</button>
</div>

</body>
</html>