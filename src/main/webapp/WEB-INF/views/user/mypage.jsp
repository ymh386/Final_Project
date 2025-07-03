<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
	<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
		<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
		
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
		<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
		<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	</head>
<body class="sb-nav-fixed d-flex flex-column min-vh-100">
	<style>
		.sports-topbar {
		position: fixed !important;
		top: 0 !important;
		left: 0 !important;
		right: 0 !important;
		height: 64px !important;
		border-bottom: 4px solid #ffe600 !important;
		margin-top: 0 !important;
		box-shadow: none !important;
		z-index: 1100 !important;
		}


		.club-sidebar {
		position: fixed;
		top: 64px;
		left: 0;
		width: 240px;
		height: calc(100vh - 64px);
		background: #232326;
		border-right: none; /* 테두리 제거 */
		z-index: 1050;
		overflow-y: auto;
		}
		
		/* 메인 콘텐츠 영역 스타일 - 탑바, 사이드바 공간 확보 */
		#layoutSidenav_content {
			margin-left: 240px; /* 사이드바 너비 */
			margin-top: 64px;   /* 탑바 높이 */
			padding: 1rem;
			min-height: calc(100vh - 64px);
			box-sizing: border-box;
			background: #fff;
		}
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
        #subList {
            width: 100%;
            border-collapse: collapse;
        }
        #subList th, #subList td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        #subList th {
            background-color: #f4f4f4;
        }
        .disabled {
            background-color: #ddd;
            color: #666;
            cursor: not-allowed;
        }		
	</style>
<sec:authentication property="principal" var="user"></sec:authentication>
  <!-- 탑바 고정 -->
  <div class="sports-topbar">
    <c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
  </div>
  <div id="layoutSidenav" class="d-flex flex-grow-1">
    <!-- 사이드바 고정 -->
    <div class="club-sidebar">
      <c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
    </div>

  <div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
    <main class="flex-grow-1">
      <div class="container">

        <!-- 페이지 타이틀 -->
        <h1 class="mb-4">내 정보</h1>

        <!-- 기본 정보 카드 -->
        <div class="card mb-4 shadow-sm">
          <div class="card-header bg-white">
            <strong>기본 정보</strong>
          </div>
          <ul class="list-group list-group-flush">
		    <li class="list-group-item d-flex justify-content-between align-items-center">
              <span>프로필 사진</span>
                    <c:if test="${user.sns eq null and user.fileName ne 'default'}">
                    	<img src="/files/user/${user.fileName}"
                         id="senderimg"
                    		 class="rouned-circle me-3"
                    		 width="48" height="48"
                    		 alt="avatar">
                    </c:if>
                    <c:if test="${user.sns ne null}">
                    	<img src="${user.fileName}"
                         id="senderimg"
                    		 class="rouned-circle me-3"
                    		 width="48" height="48"
                    		 alt="avatar">
                    </c:if>
                    <c:if test="${user.sns eq null and user.fileName eq 'default'}">
	                    <img src="/img/default.png"
                         id="senderimg" 
	                      class="rounded-circle me-3" 
	                      width="48" height="48" 
	                      alt="avatar">
                    </c:if>
            </li>
			<input hidden name="username" value="${user.username}">
            <li class="list-group-item d-flex justify-content-between">
              <span>아이디</span>
              <span>${user.username}</span>
            </li>
            <li class="list-group-item d-flex justify-content-between">
              <span>이름</span>
              <span>${user.name}</span>
            </li>			
            <li class="list-group-item d-flex justify-content-between">
              <span>이메일</span>
              <span>${user.email}</span>
            </li>			
            <li class="list-group-item d-flex justify-content-between">
              <span>생년월일</span>
              <span>${user.birth}</span>
            </li>
            <li class="list-group-item d-flex justify-content-between">
              <span>휴대전화</span>
              <span>${user.phone}</span>
            </li>
		
          </ul>
          <div class="card-body">
            <a href="/user/update" class="btn btn-outline-primary btn-sm">
              정보 수정
            </a>
          </div>
        </div>

		<sec:authorize access="hasAnyRole('ADMIN', 'TRAINER')">
        <div class="container py-5" id="chart">
          <h1 class="mb-4">근태/휴가 통계</h1>

          <form id="filterForm" method="get" action="./mypage#chart" class="row g-3 mb-4">
            <div class="col-md-2">
            <label class="form-label">연도</label>
            <select name="year" class="form-select">
              <c:forEach var="y" items="${yearList}">
                <option value="${y}" <c:if test="${y == year}">selected</c:if>>${y}년</option>
              </c:forEach>
            </select>
            </div>

            <div class="col-md-2 d-flex align-items-end">
              <button type="submit" class="btn btn-dark">조회</button>
            </div>
          </form>

          <div class="card p-4 shadow">
            <canvas id="attendanceChart" height="400"></canvas>
          </div>

		  <div class="card p-4 shadow">
				<canvas id="leaveChart" height="400"></canvas>
			</div>
        </div>

		
				
			

		

		
		<h1 class="mb-4">전자 결재</h1>
        <div class="card mb-4 shadow-sm">
          <div class="card-header bg-white">
            <strong>전자 결재</strong>
          </div>
          <ul class="list-group list-group-flush">
            <li class="list-group-item d-flex justify-content-between align-items-center">
				<span>내 결재함</span>
				<a class="btn btn-primary-outline btn-sm" href="./getDocuments">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-right" viewBox="0 0 16 16">
						<path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0z"/>
						<path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"/>
					</svg>
				</a>
            </li>
            <li class="list-group-item d-flex justify-content-between">
              <span>승인 대기함</span>
				<a class="btn btn-primary-outline btn-sm" href="/approval/awaitList">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-right" viewBox="0 0 16 16">
						<path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0z"/>
						<path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"/>
					</svg>
				</a>
            </li>			
            <li class="list-group-item d-flex justify-content-between">
              <span>승인 내역</span>
				<a class="btn btn-primary-outline btn-sm" href="/approval/list">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-right" viewBox="0 0 16 16">
						<path fill-rule="evenodd" d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0z"/>
						<path fill-rule="evenodd" d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"/>
					</svg>
				</a>
            </li>
            <li class="list-group-item d-flex justify-content-between">
              <span>서명/도장</span>
			  	<c:if test="${empty userSignature}">
					<a href="/approval/registerSign">서명/도장 등록</a>
				</c:if>
				<c:if test="${not empty userSignature}">
					<button class="btn btn-primary-outline btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
					  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-compact-down" viewBox="0 0 16 16">
						  <path fill-rule="evenodd" d="M1.553 6.776a.5.5 0 0 1 .67-.223L8 9.44l5.776-2.888a.5.5 0 1 1 .448.894l-6 3a.5.5 0 0 1-.448 0l-6-3a.5.5 0 0 1-.223-.67"/>
					  </svg>
					</button>
				</c:if>
				<div class="collapse" id="collapseExample">
					<div class="card card-body">
						<img src="/files/userSignature/${userSignature.fileName}" width="200" height="100">
						<a href="/approval/deleteSign">서명/도장 삭제</a>
					</div>
			  </div>
            </li>
          </ul>
        </div>
		</sec:authorize>	

		<sec:authorize access="!hasRole('TRAINER')">
	    <h1>구독 내역</h1>
		<table id="subList" border="1" cellpadding="8">
			<tr><th>상품명</th><th>시작날짜</th><th>종료날짜</th><th>가격</th></tr>
			<c:forEach var="l" items="${list}">
				<tr>
					<form action="/subscript/cancel?subscriptId=${l.subscriptId}" method="post">
			        <td>${l.subscriptionVO.subscriptionName}</td>
			        <td>${l.startDate}</td>
			        <td>${l.endDate}</td>
			        <td>${l.subscriptionVO.price}</td>
					</form>
			      </tr>
			    </c:forEach>
		</table>
		</sec:authorize>

        <!-- 추가 섹션 필요하면 동일한 패턴으로 쭉 쌓기 -->
        <!-- 예: 결제 및 구독 정보, 보안 설정 등 -->

		<!-- 회원 탈퇴 -->
		<div class="d-flex justify-content-end my-3">
			<button id="deleteUser" type="button" class="btn btn-danger">탈퇴하기</button>
		</div>
		

		<!-- 비밀번호 확인 모달 -->
		<div class="modal fade" id="passwordModal" tabindex="-1" aria-labelledby="passwordModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="passwordModalLabel">비밀번호 확인</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
			</div>
			<div class="modal-body">
				<p>정말 탈퇴하시겠습니까?<br><strong>※ 탈퇴 시 모든 정보는 삭제되며 복구되지 않습니다.</strong></p>
				<input type="password" id="confirmPassword" class="form-control" placeholder="비밀번호 입력" />
				<div id="errorMsg" class="text-danger mt-2" style="display:none;">비밀번호가 일치하지 않습니다.</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
				<button type="button" id="confirmDeleteBtn" class="btn btn-danger">확인</button>
			</div>
			</div>
		</div>
		</div>

      </div>
    </main>

    <!-- 푸터 -->
    <c:import url="/WEB-INF/views/templates/footer.jsp"/>
  </div>

  <!-- Bootstrap JS (필요하다면) -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/js/user/mypage.js"></script>
  <script>

		//근태율 차트
		const labels = [
			<c:forEach var="stat" items="${attendanceStats}">"${stat.month}월",</c:forEach>
		];

		const presentData = [
			<c:forEach var="stat" items="${attendanceStats}">
			${stat.total > 0 ? (stat.present * 100 / stat.total) : 0},
			</c:forEach>
		];

		const lateData = [
			<c:forEach var="stat" items="${attendanceStats}">
			${stat.total > 0 ? (stat.late * 100 / stat.total) : 0},
			</c:forEach>
		];

		const absentData = [
			<c:forEach var="stat" items="${attendanceStats}">
			${stat.total > 0 ? (stat.absent * 100 / stat.total) : 0},
			</c:forEach>
		];

		new Chart(document.getElementById('attendanceChart'), {
			type: 'bar',
			data: {
			labels: labels,
			datasets: [
				{
				label: '출근',
				data: presentData,
				backgroundColor: 'rgba(54, 162, 235, 0.8)'
				},
				{
				label: '지각',
				data: lateData,
				backgroundColor: 'rgba(255, 206, 86, 0.8)'
				},
				{
				label: '결근',
				data: absentData,
				backgroundColor: 'rgba(255, 99, 132, 0.8)'
				}
			]
			},
			options: {
			responsive: true,
			maintainAspectRatio: false,
			plugins: {
				title: {
				display: true,
				text: "${year}년 월별 근태율 (출근/지각/결근)",
				color: "#000000",
				font: { size: 18 }
				},
				legend: {
				labels: { color: "#000000" }
				}
			},
			scales: {
				x: {
				stacked: true,
				ticks: { color: "#000000" },
				grid: { color: "#e0e0e0" }
				},
				y: {
				stacked: true,
				min: 0,
				max: 100,
				ticks: {
					color: "#000000",
					callback: function(value) { return value + '%' }
				},
				title: {
					display: true,
					text: '비율 (%)',
					color: "#000000"
				},
				grid: { color: "#e0e0e0" }
				}
			}
			}
		});

		//휴가율 차트
		const labels2 = [
			<c:forEach var="stat" items="${leaveStats}">
				"${stat.leaveVO.leaveName}",
			</c:forEach>
		];

		const usedData = [
			<c:forEach var="stat" items="${leaveStats}">
				${stat.usedDays},
			</c:forEach>
		];

		

		new Chart(document.getElementById('leaveChart'), {
			type: 'bar',
			data: {
				labels: labels2,
				datasets: [{
				label: '사용일 수',
				data: usedData,
				backgroundColor: ['#4caf50', '#2196f3', '#ff9800', '#9c27b0']
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
				title: {
					display: true,
					text: "${year}년 휴가유형별 사용일 수",
					color: "#000000",
					font: { size: 18 }
				},
				legend: {
					labels: { color: "#000000" }
				}
				},
				scales: {
				x: {
					ticks: { color: "#000000" },
					grid: { color: "#e0e0e0" }
				},
				y: {
					beginAtZero: true,
					ticks: {
					color: "#000000",
					stepSize: 1
					},
					title: {
					display: true,
					text: '사용일 수',
					color: "#000000"
					},
					grid: { color: "#e0e0e0" }
				}
				}
			}
		});


		</script>
</body>
</html>