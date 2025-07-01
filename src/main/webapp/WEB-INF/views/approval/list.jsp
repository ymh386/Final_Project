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
									<h4 class="mb-0">승인 내역</h4>
								</div>
								<div class="card-body">
	
									<!-- 검색/필터 폼 -->
									<form method="get" class="row row-cols-lg-auto g-3 align-items-center mb-4">
										<div class="col">
											<select name="searchField" class="form-select form-select-sm">
												<option value="D.WRITER_ID" ${pager.searchField eq 'D.WRITER_ID' ? 'selected' : ''}>요청자ID</option>
												<option value="D.DOCUMENT_TITLE" ${pager.searchField eq 'D.DOCUMENT_TITLE' ? 'selected' : ''}>제목</option>
												<option value="F.FORM_TITLE" ${pager.searchField eq 'F.FORM_TITLE' ? 'selected' : ''}>문서 양식</option>
											</select>
										</div>
										<div class="col">
											<input type="text" name="searchWord" class="form-control form-control-sm"
												value="${pager.searchWord}" placeholder="검색어 입력">
										</div>
										<div class="col">
											<select onchange="this.form.submit()" name="approvalStatus" class="form-select form-select-sm">
												<option value="" ${approvalStatus == null ? 'selected' : ''}>전체</option>
												<option value="AS1" ${approvalStatus eq 'AS1' ? 'selected' : ''}>승인</option>
												<option value="AS2" ${approvalStatus eq 'AS2' ? 'selected' : ''}>반려</option>
											</select>
										</div>
										<div class="col">
											<button type="submit" class="btn btn-sm btn-dark">
												<i class="bi bi-search"></i> 검색
											</button>
										</div>
									</form>
		
									<!-- 결과 테이블 -->
									<c:if test="${not empty ar}">
										<div class="table-responsive shadow-sm rounded">
											<table class="table table-hover align-middle text-center">
												<thead class="table-dark">
													<tr>
														<th>문서번호</th>
														<th>문서 양식</th>
														<th>요청자</th>
														<th>문서 제목</th>
														<th>문서 상태</th>
														<th>승인 여부</th>
														<th>승인 일시</th>
													</tr>
												</thead>
												<tbody>
													<c:forEach var="a" items="${ar}">
														<tr class="clickable-row" onclick="location.href='./detail?approvalId=${a.approvalId}'" style="cursor: pointer;">
															<td>${a.documentId}</td>
															<td>${a.documentVO.formVO.formTitle}</td>
															<td>${a.documentVO.userVO.name}(${a.documentVO.writerId})</td>
															<td>${a.documentVO.documentTitle}</td>
		
															<!-- 문서 상태 -->
															<td>
																<c:choose>
																	<c:when test="${a.documentVO.documentStatus eq 'D1'}">
																		<span class="badge text-bg-primary">승인</span>
																	</c:when>
																	<c:when test="${a.documentVO.documentStatus eq 'D2'}">
																		<span class="badge text-bg-danger">반려</span>
																	</c:when>
																	<c:otherwise>
																		<span class="badge text-bg-secondary">진행중</span>
																	</c:otherwise>
																</c:choose>
															</td>
		
															<!-- 승인 여부 -->
															<td>
																<c:choose>
																	<c:when test="${a.approvalStatus eq 'AS1'}">
																		<span class="badge bg-success">승인</span>
																	</c:when>
																	<c:otherwise>
																		<span class="badge bg-danger">반려</span>
																	</c:otherwise>
																</c:choose>
															</td>
		
															<td>${a.approvedAt}</td>
														</tr>
													</c:forEach>
												</tbody>
											</table>
										</div>
									</c:if>
		
									<!-- 조회결과 없음 -->
									<c:if test="${empty ar}">
										<div class="alert alert-secondary text-center mt-4" role="alert">
											조회된 승인내역이 없습니다.
										</div>
									</c:if>
		
									<!-- 페이지네이션 -->
									<nav class="mt-4">
										<ul class="pagination justify-content-center">
											<c:if test="${pager.prev}">
												<li class="page-item">
													<a class="page-link" href="?curPage=${pager.startPage - 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&approvalStatus=${approvalStatus}">이전</a>
												</li>
											</c:if>
											<c:forEach var="i" begin="${pager.startPage}" end="${pager.endPage}">
												<li class="page-item ${pager.curPage == i ? 'active' : ''}">
													<a class="page-link" href="?curPage=${i}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&approvalStatus=${approvalStatus}">${i}</a>
												</li>
											</c:forEach>
											<c:if test="${pager.next}">
												<li class="page-item">
													<a class="page-link" href="?curPage=${pager.endPage + 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&approvalStatus=${approvalStatus}">다음</a>
												</li>
											</c:if>
										</ul>
									</nav>
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