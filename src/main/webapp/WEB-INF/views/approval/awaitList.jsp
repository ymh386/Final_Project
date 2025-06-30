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
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
		<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
		<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
	</head>
	<body class="sb-nav-fixed d-flex flex-column min-vh-100">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
                    <div class="container">
							<!-- contents -->
						<div class="container mt-4">
							<div class="card shadow-sm">
								<div class="card-header bg-secondary text-white">
									<h4 class="mb-0"><i class="bi bi-journal-check me-2"></i>승인 대기함</h4>
								</div>
								<div class="card-body">
									<c:if test="${not empty ar}">
										<div class="table-responsive shadow-sm rounded">
										<table class="table table-hover align-middle text-center border">
											<thead class="table-dark">
											<tr>
												<th>문서번호</th>
												<th>종류</th>
												<th>요청자</th>
												<th>제목</th>
												<th>문서상태</th>
												<th>승인여부</th>
											</tr>
											</thead>
											<tbody>
											<c:forEach var="a" items="${ar}">
												<tr class="table-row cursor-pointer" onclick="location.href='./awaitDetail?approvalId=${a.approvalId}'">
												<th>${a.documentId}</th>
												<td>${a.documentVO.formVO.formTitle}</td>
												<td>${a.documentVO.userVO.name} (${a.documentVO.writerId})</td>
												<td class="text-start">${a.documentVO.documentTitle}</td>
												
												<!-- 문서상태 -->
												<td>
													<c:choose>
													<c:when test="${a.documentVO.documentStatus eq 'D1'}">
														<span class="badge bg-success">승인</span>
													</c:when>
													<c:when test="${a.documentVO.documentStatus eq 'D2'}">
														<span class="badge bg-danger">반려</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-secondary">진행중</span>
													</c:otherwise>
													</c:choose>
												</td>
		
												<!-- 승인여부 -->
												<td>
													<c:choose>
													<c:when test="${a.approvalStatus eq 'AS1'}">
														<span class="badge bg-primary">승인</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-warning text-dark">미승인</span>
													</c:otherwise>
													</c:choose>
												</td>
												</tr>
											</c:forEach>
											</tbody>
										</table>
										</div>
									</c:if>
		
									<c:if test="${empty ar}">
										<div class="alert alert-info text-center mt-4" role="alert">
										<i class="bi bi-exclamation-circle-fill me-2"></i>조회된 승인대기가 없습니다.
										</div>
									</c:if>
								</div>
							</div>
							

						</div>
					
					</div>
				</main>
				<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
					
	
	
	
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>