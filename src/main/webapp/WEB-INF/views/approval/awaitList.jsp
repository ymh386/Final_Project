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
						<h2>승인 대기함</h2>

						<c:if test="${not empty ar}">

							<table class="table table-hover table-bordered">
								<thead class="table-dark">
									<tr>
										<th scope="col">문서번호</th>
										<th scope="col">종류</th>
										<th scope="col">요청자</th>
										<th scope="col">제목</th>
										<th scope="col">문서상태</th>
										<th scope="col">승인여부</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="a" items="${ar}">
										<tr class="table-row" onclick="location.href='./awaitDetail?approvalId=${a.approvalId}'">
											<th scope="row">${a.documentId}</th>
											<td>${a.documentVO.formVO.formTitle}</td>
											<td>${a.documentVO.writerId}</td>
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
													<td>승인</td>
												</c:when>
												<c:otherwise>
													<td>미승인</td>
												</c:otherwise>
											</c:choose>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</c:if>
						<c:if test="${empty ar}">
							<h3>조회된 승인대기가 없습니다.</h3>
						</c:if>



						</div>
					
					</div>
				</main>
				<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
					
	
	
	
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>