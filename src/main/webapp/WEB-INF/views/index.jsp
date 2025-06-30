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
		<style>
			.notice-card {
			min-height: 300px;
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

		        .hidden {
					display: none;
				}
			}
		</style>
	</head>
	<body class="sb-nav-fixed d-flex flex-column min-vh-100">
	<sec:authentication property="principal" var="user"/>
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
					<div class="container">
						<sec:authorize access="!hasRole('TRAINER')">
							<div class="container mt-4">
								<div class="row justify-content-center">
									<div class="col-lg-12">
										<div id="mainCarousel" class="carousel slide" data-bs-ride="carousel">
											<div class="carousel-inner" style="height: 500px;">
												<div class="carousel-item active">
													<img src="${pageContext.request.contextPath}/img/boxing.png" class="d-block w-100">
												</div>
												<div class="carousel-item">
													<img src="${pageContext.request.contextPath}/img/swim.png" class="d-block w-100">
												</div>
												<div class="carousel-item">
													<img src="${pageContext.request.contextPath}/img/health.png" class="d-block w-100">
												</div>		  		 						
											</div>
											<button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
												<span class="carousel-control-prev-icon"></span>
											</button>
											<button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
												<span class="carousel-control-next-icon"></span>
											</button>
										</div>
									</div>
								</div>
							</div>

							<div class="container-fluid my-4">
								<div class="row gx-4">
									<div class="col-lg-4">
										<div class="card h-100 notice-card">
											<div class="card-header d-flex justify-content-between align-items-center">
											<h5 class="mb-0">공지사항</h5>
											<a href="/notice/list" class="small text-decoration-none">더보기 &gt;</a>
											</div>
											<ul class="list-group list-group-flush">
											<c:forEach items="${notice}" var="n">
												<li class="list-group-item d-flex justify-content-between align-items-center py-2">
												<span>
													<span class="badge bg-secondary me-1">공지</span>
													<a href="/notice/detail?boardNum=${n.boardNum}" class="text-decoration-none">
													${n.boardTitle}
													</a>
												</span>
												<small class="text-muted">${n.boardDate}</small>
												</li>
											</c:forEach>
											
											</ul>
										</div>
									</div>

									<div class="col-lg-4 d-flex">
										<div class="card flex-fill">
											<div class="card-header d-flex justify-content-between align-items-center">
											<h5 class="mb-0">일정</h5>
											<a href="/schedule/page" class="small text-decoration-none">더보기 &gt;</a>
											</div>
											<ul class="list-group list-group-flush">
											<c:forEach items="${reservation}" var="r">
												<li class="list-group-item d-flex justify-content-between align-items-center py-2">
												<span>
													<span class="badge bg-secondary me-1">${r.trainer}</span>
													<a href="/reservation/my" class="text-decoration-none">
													${r.name}
													</a>
												</span>
												<small class="text-muted">${r.scheduleDate}</small>
												</li>
											</c:forEach>
											
											</ul>
										</div>
									</div>

									<div class="col-lg-4 d-flex">
										<div class="card flex-fill">
											<div class="card-header d-flex justify-content-between align-items-center">
											<h5 class="mb-0">채팅</h5>
											<a href="/chat/list" class="small text-decoration-none">더보기 &gt;</a>
											</div>
											<ul class="list-group list-group-flush">
											<c:forEach items="${chat}" var="c">
												<li class="list-group-item d-flex justify-content-between align-items-center py-2">
												<span>
													<span class="badge bg-secondary me-1">${c.chatMessageVO.senderId}</span>
													<a href="/chat/list" class="text-decoration-none">
													${c.chatMessageVO.contents}
													</a>
												</span>
												<small class="text-muted">${c.chatMessageVO.createdAt}</small>
												</li>
											</c:forEach>							
											</ul>
										</div>
									</div>						
								</div>
							</div>
						</sec:authorize>

							<!-- 좌측: 회원 정보 카드 -->
						<sec:authorize access="hasAnyRole('TRAINER', 'ADMIN')">

							<div class="container-fluid px-4 py-4">
								<div class="row mb-4">
									
									<div class="col-md-6 mb-3">
										<div class="card shadow-sm h-100">
											<div class="card-header bg-dark text-white">
												<i class="bi bi-person-circle"></i> 회원 정보
											</div>
											<div class="card-body">
												<div class="row gx-3">
													<div class="col-6">
														<!-- TODO: 사용자 정보 출력 -->
														<p><strong>이름:</strong> ${user.name}</p>
														<p><strong>등급:</strong> 트레이너</p>
														<p><strong>누적 근무시간:</strong> 120시간</p>
													</div>

													<div class="col-6">
														<div class="card h-100">
															<form action="" method="post">
																<div class="card-header bg-dark text-white text-center">
																	<i class="bi bi-clock-fill"></i> 출퇴근
																</div>
																<div class="card-body d-flex flex-column align-items-center justify-content-center attendance-controls">
																	<p><strong>출근 : </strong> ${user.name}</p>
																	<p><strong>퇴근 : </strong> 트레이너</p>		
																	<button id="checkInBtn" class="hidden">
																		<i class="fas fa-sign-in-alt me-2"></i>출근
																	</button>
																	<button id="checkOutBtn" class="hidden">
																		<i class="fas fa-sign-out-alt me-2"></i>퇴근
																	</button>														
																</div>
															</form>
														</div>
													</div>

												</div>
											</div>
										</div>
									</div>
									
									<!-- 우측: 이번달 근태율 원형 차트 -->
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
								</div>
									<!-- ▶ 하단: 추가 콘텐츠 자리 -->
								<div class="container-fluid my-4">
									<div class="row gx-4">
										<div class="col-lg-4">
											<div class="card h-100 notice-card">
												<div class="card-header d-flex justify-content-between align-items-center">
													<h5 class="mb-0">공지사항</h5>
													<a href="/notice/list" class="small text-decoration-none">더보기 &gt;</a>
												</div>
												<ul class="list-group list-group-flush">
												<c:forEach items="${notice}" var="n">
													<li class="list-group-item d-flex justify-content-between align-items-center py-2">
														<span>
															<span class="badge bg-secondary me-1">공지</span>
															<a href="/notice/detail?boardNum=${n.boardNum}" class="text-decoration-none">
															${n.boardTitle}
															</a>
														</span>
														<small class="text-muted">${n.boardDate}</small>
													</li>
												</c:forEach>
												
												</ul>
											</div>
										</div>

										<div class="col-lg-4 d-flex">
											<div class="card flex-fill">
												<div class="card-header d-flex justify-content-between align-items-center">
													<h5 class="mb-0">일정</h5>
													<a href="/schedule/page" class="small text-decoration-none">더보기 &gt;</a>
												</div>
												<ul class="list-group list-group-flush">
												<c:forEach items="${reservation}" var="r">
													<li class="list-group-item d-flex justify-content-between align-items-center py-2">
														<span>
															<span class="badge bg-secondary me-1">${r.trainer}</span>
															<a href="/reservation/my" class="text-decoration-none">
															${r.name}
															</a>
														</span>
														<small class="text-muted">${r.scheduleDate}</small>
													</li>
												</c:forEach>
												
												</ul>
											</div>
										</div>

										<div class="col-lg-4 d-flex">
											<div class="card flex-fill">
												<div class="card-header d-flex justify-content-between align-items-center">
													<h5 class="mb-0">채팅</h5>
													<a href="/chat/list" class="small text-decoration-none">더보기 &gt;</a>
												</div>
												<ul class="list-group list-group-flush">
												<c:forEach items="${chat}" var="c">
													<li class="list-group-item d-flex justify-content-between align-items-center py-2">
														<span>
															<span class="badge bg-secondary me-1">${c.chatMessageVO.senderId}</span>
															<a href="/chat/list" class="text-decoration-none">
															${c.chatMessageVO.contents}
															</a>
														</span>
														<small class="text-muted">${c.chatMessageVO.createdAt}</small>
													</li>
												</c:forEach>							
												</ul>
											</div>
										</div>						
									</div>
								</div>
							</div>
						</sec:authorize>
								
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