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
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
                    <div class="container">
						<div class="container mt-4">
							<!-- contents -->
							<sec:authorize access="isAuthenticated()">
								<!-- ▶ 상단: 회원정보 카드 + 근태율 차트 -->
								<div class="row mb-4">
									
									<!-- 좌측: 회원 정보 카드 -->
									<div class="col-md-6 mb-3">
										<div class="card shadow-sm h-100">
											<div class="card-header bg-dark text-white">
											<i class="bi bi-person-circle"></i> 회원 정보
											</div>
											<div class="card-body">
											<!-- TODO: 사용자 정보 출력 -->
											<p><strong>이름:</strong> 홍길동</p>
											<p><strong>등급:</strong> 트레이너</p>
											<p><strong>누적 근무시간:</strong> 120시간</p>
											</div>
										</div>
									</div>
	
									<!-- 우측: 이번달 근태율 원형 차트 -->
									<sec:authorize access="hasAnyRole('TRAINER', 'ADMIN')">
										<div class="col-md-6 mb-3">
											<div class="card shadow-sm h-100">
												<div class="card-header bg-secondary text-white">
												<i class="bi bi-pie-chart-fill"></i> 이번 달 근태율
												</div>
												<div class="card-body">
													<canvas id="attendancePieChart" width="100%" height="200"></canvas>
												</div>
											</div>
										</div>
									</sec:authorize>
	
								</div>
	
								<!-- ▶ 하단: 추가 콘텐츠 자리 -->
								<div class="row">
									<div class="col-12">
									<div class="card shadow-sm">
										<div class="card-header bg-warning text-white">
										<i class="bi bi-layout-text-window"></i> 추가 콘텐츠 (예: 공지사항, 예약현황 등)
										</div>
										<div class="card-body">
										<!-- TODO: 추후 기능 추가 -->
										<p>이곳에 추가 기능 또는 위젯을 배치할 수 있습니다.</p>
										</div>
									</div>
									</div>
								</div>
							
							</sec:authorize>




						</div>
					
					</div>
				</main>
				<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
					
	
	
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
		<!-- 원형 근태율 차트 -->
		<script>
			const present = ${attendanceStat.present};
			const late = ${attendanceStat.late};
			const absent = ${attendanceStat.absent};

			const total = present + late + absent;

			const data = [
				total > 0 ? Math.round(present * 100 / total) : 0,
				total > 0 ? Math.round(late * 100 / total) : 0,
				total > 0 ? Math.round(absent * 100 / total) : 0
			];

			const labels = ['출근', '지각', '결근'];
			const colors = ['rgba(54, 162, 235, 0.8)', 'rgba(255, 206, 86, 0.8)', 'rgba(255, 99, 132, 0.8)'];

			new Chart(document.getElementById('attendancePieChart').getContext('2d'), {
				type: 'doughnut',  // 또는 'pie'
				data: {
					labels: labels,
					datasets: [{
						data: data,
						backgroundColor: colors,
						borderWidth: 1
					}]
				},
				options: {
					responsive: true,
					maintainAspectRatio: false,
					plugins: {
						legend: {
							position: 'bottom',
							labels: {
								color: "#000000"
							}
						},
						tooltip: {
							callbacks: {
								label: function(context) {
							const label = context.label || '';
							const value = context.raw || 0;
							return label + ': ' + value + '%';
								}
							}
						}
					}
				}
			});
		</script>
	</body>
</html>