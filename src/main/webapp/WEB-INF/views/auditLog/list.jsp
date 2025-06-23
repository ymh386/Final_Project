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
						    <h3 class="mb-3">감사 로그 관리</h3>
						    
						    <a href="./excel?searchField=${pager.searchField}&searchWord=${pager.searchWord}" class="btn btn-success">
							   ⬇ 엑셀 다운로드
							</a>
						
						<!-- 카테고리별 검색어 -->
						    <form method="get" class="d-flex mb-3">
						        <select name="searchField" class="form-select w-auto me-2">
						            <option value="username" ${pager.searchField eq 'username' ? 'selected' : ''}>사용자</option>
						            <option value="ACTION_TYPE" ${pager.searchField eq 'ACTION_TYPE' ? 'selected' : ''}>행위</option>
						            <option value="IP_ADDRESS" ${pager.searchField eq 'IP_ADDRESS' ? 'selected' : ''}>IP주소</option>
						        </select>
						        <input type="text" name="searchWord" class="form-control me-2" value="${pager.searchWord}" placeholder="검색어">
						        <button class="btn btn-dark">검색</button>
						    </form>
						
						    <table class="table table-hover table-bordered">
						        <thead class="table-dark">
						            <tr>
						                <th>ID</th>
						                <th>사용자</th>
						                <th>행위</th>
						                <th>테이블</th>
						                <th>RowId</th>
						                <th>메시지</th>
						                <th>시간</th>
						                <th>IP</th>
						                <th>User-Agent</th>
						            </tr>
						        </thead>
						        <tbody>
						            <c:forEach var="log" items="${ar}">
						                <tr>
						                    <td>${log.auditLogId}</td>
						                    <td>${log.username}</td>
						                    <td>${log.actionType}</td>
						                    <td>${log.targetTable}</td>
						                    <td>${log.targetId}</td>
						                    <td>${log.description}</td>
						                    <td>${log.createdAt}</td>
						                    <td>${log.ipAddress}</td>
						                    <td><small>${log.userAgent}</small></td>
						                </tr>
						            </c:forEach>
						        </tbody>
						    </table>
						
						    <!-- 페이징 -->
						    <nav class="text-center mt-3">
						        <ul class="pagination justify-content-center">
						            <c:if test="${pager.prev}">
						                <li class="page-item"><a class="page-link" href="?curPage=${pager.startPage - 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}">이전</a></li>
						            </c:if>
						
						            <c:forEach var="i" begin="${pager.startPage}" end="${pager.endPage}">
						                <li class="page-item ${pager.curPage == i ? 'active' : ''}">
						                    <a class="page-link" href="?curPage=${i}&searchField=${pager.searchField}&searchWord=${pager.searchWord}">${i}</a>
						                </li>
						            </c:forEach>
						
						            <c:if test="${pager.next}">
						                <li class="page-item"><a class="page-link" href="?curPage=${pager.endPage + 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}">다음</a></li>
						            </c:if>
						        </ul>
						    </nav>
						</div>





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