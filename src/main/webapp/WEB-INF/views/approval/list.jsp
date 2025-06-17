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
						<h2>승인 내역</h2>
    
    
						<form method="get">
							<label>카테고리</label><br>
							<!-- 내용을 변경할때 마다 submit 시킴 -> 양식변경시 재렌더링 위함 -->
							<select onchange="this.form.submit()" id="formSelect" name="formId">
								<!-- 선택한 formId(양식)가 없을 때 모두 보기가 selected-->
								<option value="" ${empty selectedFormId ? 'selected' : ''}>모두 보기</option>
								<c:forEach var="f" items="${forms}">
									<!-- 선택한 formId(양식)가 있을 때 해당 양식목록이 selected-->
									<option value="${f.formId}" ${f.formId eq selectedFormId ? 'selected' : ''}>${f.formTitle}</option>
								</c:forEach>
							</select><br>
							<label>요청자ID</label><br>
							<input type="text" value="${writedId}" name="search"/>
							<button type="submit">검색</button>
						</form><br><br>

						<c:if test="${not empty ar}">
							<table class="table table-hover">
								<thead>
									<tr>
										<th scope="col">문서번호</th>
										<th scope="col">종류</th>
										<th scope="col">요청자</th>
										<th scope="col">문서제목</th>
										<th scope="col">문서상태</th>
										<th scope="col">승인여부</th>
										<th scope="col">승인일시</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="a" items="${ar}">
										<tr class="table-row" onclick="location.href='./detail?approvalId=${a.approvalId}'">
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





					<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
					</div>
				</main>
			</div>
		</div>
					
	
	
	
	
		<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
		</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>