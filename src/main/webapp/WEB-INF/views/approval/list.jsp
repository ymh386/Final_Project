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
							<h3 class="mb-3">승인 내역</h3>
    
    
							<form method="get" class="d-flex mb-3">
								<select name="searchField" class="form-select w-auto me-2">
									<option value="D.WRITER_ID" ${pager.searchField eq 'D.WRITER_ID' ? 'selected' : ''}>요청자</option>
									<option value="D.DOCUMENT_TITLE" ${pager.searchField eq 'D.DOCUMENT_TITLE' ? 'selected' : ''}>제목</option>
									<option value="F.FORM_TITLE" ${pager.searchField eq 'F.FORM_TITLE' ? 'selected' : ''}>문서 양식</option>
								</select>

								<!-- 검색어 -->
								<input type="text" name="searchWord" class="form-control me-2" value="${pager.searchWord}" placeholder="검색어">

								<!-- 내용을 변경할때 마다 submit 시킴 -> 양식변경시 재렌더링 위함 -->
								<!-- 승인 여부 선택 -->
								<select onchange="this.form.submit()" name="approvalStatus" class="form-select w-auto me-2">
									<option value="" ${approvalStatus == null ? 'selected' : ''}>전체</option>
									<option value="AS1" ${approvalStatus eq 'AS1' ? 'selected' : ''}>승인</option>
									<option value="AS2" ${approvalStatus eq 'AS2' ? 'selected' : ''}>반려</option>
								</select>
								<button type="submit" class="btn btn-dark">검색</button>
							</form>

							<c:if test="${not empty ar}">

								<table class="table table-hover table-bordered">
									<thead class="table-dark">
										<tr>
											<th scope="col">문서 번호</th>
											<th scope="col">문서 양식</th>
											<th scope="col">요청자</th>
											<th scope="col">문서 제목</th>
											<th scope="col">문서 상태</th>
											<th scope="col">승인 여부</th>
											<th scope="col">승인 일시</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="a" items="${ar}">
											<tr onclick="location.href='./detail?approvalId=${a.approvalId}'">
												<th scope="row">${a.documentId}</th>
												<td>${a.documentVO.formVO.formTitle}</td>
												<td>${a.documentVO.userVO.name}(${a.documentVO.writerId})</td>
												<td>${a.documentVO.documentTitle}</td>
												<c:choose>
													<c:when test="${a.documentVO.documentStatus eq 'D1'}">
														<td style="color: blue;">승인</td>
													</c:when>
													<c:when test="${a.documentVO.documentStatus eq 'D2'}">
														<td style="color: red;">반려</td>
													</c:when>
													<c:otherwise>
														<td>진행중</td>
													</c:otherwise>
												</c:choose>
												<c:choose>
													<c:when test="${a.approvalStatus eq 'AS1'}">
														<td style="color: blue;">승인</td>
													</c:when>
													<c:otherwise>
														<td style="color: red;">반려</td>
													</c:otherwise>
												</c:choose>
												<td>${a.approvedAt}</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</c:if>
							<c:if test="${empty ar}">
								<h3>조회된 승인내역 없습니다.</h3>
							</c:if>

							<!-- 페이징 -->
							<nav class="text-center mt-3">
								<ul class="pagination justify-content-center">
									<c:if test="${pager.prev}">
										<li class="page-item"><a class="page-link" href="?curPage=${pager.startPage - 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&approvalStatus=${approvalStatus}">이전</a></li>
									</c:if>
						
									<c:forEach var="i" begin="${pager.startPage}" end="${pager.endPage}">
										<li class="page-item ${pager.curPage == i ? 'active' : ''}">
											<a class="page-link" href="?curPage=${i}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&approvalStatus=${approvalStatus}">${i}</a>
										</li>
									</c:forEach>
						
									<c:if test="${pager.next}">
										<li class="page-item"><a class="page-link" href="?curPage=${pager.endPage + 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&approvalStatus=${approvalStatus}">다음</a></li>
									</c:if>
								</ul>
							</nav>
						</div>

					
					</div>
				</main>
				<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
					
	
	
	
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>