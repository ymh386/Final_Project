<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
	<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
		<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>

		
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
						    <h3 class="mb-3">알림함</h3>
						
						<!-- 카테고리별 검색어 -->
						 <!-- 검색 필드 -->
						    <form method="get" class="d-flex mb-3">
						        <select name="searchField" class="form-select w-auto me-2">
						            <option value="S.NAME" ${pager.searchField eq 'S.NAME' ? 'selected' : ''}>송신자</option>
						            <option value="NOTIFICATION_TITLE" ${pager.searchField eq 'NOTIFICATION_TITLE' ? 'selected' : ''}>종류(제목)</option>
						            <option value="MESSAGE" ${pager.searchField eq 'MESSAGE' ? 'selected' : ''}>내용</option>
						        </select>
								<!-- 검색어 -->
						        <input type="text" name="searchWord" class="form-control me-2" value="${pager.searchWord}" placeholder="검색어">

								<!-- 읽음 여부 선택 -->
								<select onchange="this.form.submit()" name="read" class="form-select w-auto me-2">
									<option value="" ${read == null ? 'selected' : ''}>전체</option>
									<option value="false" ${read eq 'false' ? 'selected' : ''}>안 읽음</option>
									<option value="true" ${read eq 'true' ? 'selected' : ''}>읽음</option>
								</select>
						        <button class="btn btn-dark">검색</button>
						    </form>
						 <c:if test="${not empty ar}">
							 
							 <table class="table table-hover table-bordered">
								 <thead class="table-dark">
									 <tr>
										 <th scope="col">종류</th>
										 <th scope="col">송신자</th>
										 <th scope="col">내용</th>
										 <th scope="col">읽음 여부</th>
										 <th scope="col">발송 시각</th>
									 </tr>
								 </thead>
								 <tbody>
									 <c:forEach var="a" items="${ar}">
										 <tr data-id="${a.notificationId}" data-link="${a.linkUrl}" class="trs">
											<td>${a.notificationTitle}</td>
											<td>${a.senderVO.name}</td>
											 <td style="white-space: pre-line;">${a.message}</td>
 
											<c:choose>
												<c:when test="${a.read}">
													<td>읽음</td>
												</c:when>
												<c:otherwise>
													<td><i class="bi bi-info-circle-fill text-primary mt-1"></i>안 읽음</td>
												</c:otherwise>
											</c:choose>
											
											<td>${a.createdAt}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						 
							</c:if>
							<c:if test="${empty ar}">
					    		<h3>조회된 알림이 없습니다.</h3>
					    	</c:if>

							<!-- 페이징 -->
							<nav class="text-center mt-3">
								<ul class="pagination justify-content-center">
									<c:if test="${pager.prev}">
										<li class="page-item"><a class="page-link" href="?curPage=${pager.startPage - 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&read=${read}">이전</a></li>
									</c:if>
						
									<c:forEach var="i" begin="${pager.startPage}" end="${pager.endPage}">
										<li class="page-item ${pager.curPage == i ? 'active' : ''}">
											<a class="page-link" href="?curPage=${i}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&read=${read}">${i}</a>
										</li>
									</c:forEach>
						
									<c:if test="${pager.next}">
										<li class="page-item"><a class="page-link" href="?curPage=${pager.endPage + 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&read=${read}">다음</a></li>
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
	<script src="/js/notification/list.js"></script>
	</body>
</html>