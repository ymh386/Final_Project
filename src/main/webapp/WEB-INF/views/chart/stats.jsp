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

		<!-- Dark Mode Styling -->
		<style>
			body {
				background-color: #ffffff;
				color: #000000;
			}

			.form-select, .form-control, .btn {
				background-color: #ffffff;
				color: #000000;
				border-color: #cccccc;
			}

			.form-select:focus, .form-control:focus {
				border-color: #999999;
				box-shadow: none;
			}

			.card {
				background-color: #ffffff;
				border: 1px solid #ddd;
			}
		</style>
	</head>
	<body class="sb-nav-fixed d-flex flex-column min-vh-100">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
                    <div class="container">
						<div class="container mt-4">
							<!-- contents -->
							<h2>통계 차트</h2>
							<div class="container py-5">
								<h3 class="mb-4">근태 통계</h2>

								<form id="filterForm" method="get" action="./stats" class="row g-3 mb-4">
									<div class="col-md-2">
									<label class="form-label">연도</label>
									<select name="year" class="form-select">
										<c:forEach var="y" items="${yearList}">
											<option value="${y}" <c:if test="${y == year}">selected</c:if>>${y}년</option>
										</c:forEach>
									</select>
									</div>

									

									<div class="col-md-2">
									<label class="form-label">범위</label>
									<select name="scope" class="form-select" onchange="onScopeChange(this.value)">
										<option value="all" <c:if test="${scope == 'all'}">selected</c:if>>전체</option>
										<option value="dept" <c:if test="${scope == 'dept'}">selected</c:if>>부서별</option>
										<option value="user" <c:if test="${scope == 'user'}">selected</c:if>>직원별</option>
									</select>
									</div>

									<!-- 부서 선택 (부서별 & 직원별 공통) -->
									<div class="col-md-3" id="deptSelectContainer" style="display:none">
										<label class="form-label">부서</label>
										<select id="deptSelect" name="departmentId" class="form-select" onchange="onDeptChange()">
											<option value="">전체</option>
											<c:forEach var="dept" items="${deptList}">
												<option value="${dept.departmentId}"  <c:if test="${dept.departmentId == deptId}">selected</c:if>>${dept.departmentName}</option>
											</c:forEach>
										</select>
									</div>
								
									 <!-- 직원 선택 (직원별일 때만) -->
									<div class="col-md-3" id="userSelectContainer" style="display:none">
										<label class="form-label">직원</label>
										<select name="username" id="userSelect" class="form-select">
										<option value="">선택</option>
										<c:forEach var="user" items="${userList}">
											<option value="${user.username}" <c:if test="${user.username == username}">selected</c:if>>
											${user.name}
											</option>
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
							</div>



						</div>
					
					</div>
				</main>
				<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
					
		<script src="/js/chart/stats.js"></script>
		<script>
		const labels = [
			<c:forEach var="stat" items="${stats}">"${stat.month}월",</c:forEach>
		];

		const presentData = [
			<c:forEach var="stat" items="${stats}">
			${stat.total > 0 ? (stat.present * 100 / stat.total) : 0},
			</c:forEach>
		];

		const lateData = [
			<c:forEach var="stat" items="${stats}">
			${stat.total > 0 ? (stat.late * 100 / stat.total) : 0},
			</c:forEach>
		];

		const absentData = [
			<c:forEach var="stat" items="${stats}">
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


		</script>
	
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>