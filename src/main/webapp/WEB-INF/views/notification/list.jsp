<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
	<head>
	<meta charset="UTF-8">
	<title>알림함</title>
		<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
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
                                    <h4 class="mb-0">알림함</h4>
                                </div>
                                <div class="card-body">
                                    <!-- 검색/필터 폼 -->
                                    <form method="get" class="row row-cols-lg-auto g-3 align-items-center mb-4">
                                        <div class="col">
                                            <select name="searchField" class="form-select form-select-sm">
                                                <option value="S.NAME" ${pager.searchField eq 'S.NAME' ? 'selected' : ''}>송신자</option>
                                                <option value="NOTIFICATION_TITLE" ${pager.searchField eq 'NOTIFICATION_TITLE' ? 'selected' : ''}>제목(종류)</option>
                                                <option value="MESSAGE" ${pager.searchField eq 'MESSAGE' ? 'selected' : ''}>내용</option>
                                            </select>
                                        </div>
                                        <div class="col">
                                            <input type="text" name="searchWord" class="form-control form-control-sm" value="${pager.searchWord}" placeholder="검색어 입력">
                                        </div>
                                        <div class="col">
                                            <select onchange="this.form.submit()" name="read" class="form-select form-select-sm">
                                                <option value="" ${read == null ? 'selected' : ''}>전체</option>
                                                <option value="false" ${read eq 'false' ? 'selected' : ''}>안 읽음</option>
                                                <option value="true" ${read eq 'true' ? 'selected' : ''}>읽음</option>
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
                                                        <th>제목</th>
                                                        <th>송신자</th>
                                                        <th>내용</th>
                                                        <th>읽음 여부</th>
                                                        <th>발송 시각</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="a" items="${ar}">
                                                        <tr data-id="${a.notificationId}" data-link="${a.linkUrl}" class="trs">
                                                            <td>${a.notificationTitle}</td>
                                                            <td>${a.senderVO.name}(${a.senderId})</td>
                                                            <td class="text-start" style="white-space: pre-line;">${a.message}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${a.read}">
                                                                        <span class="badge bg-secondary">읽음</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-primary"><i class="bi bi-info-circle-fill"></i> 안 읽음</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${a.createdAt}</td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>

                                    <!-- 조회결과 없음 -->
                                    <c:if test="${empty ar}">
                                        <div class="alert alert-secondary text-center mt-4" role="alert">
                                            조회된 알림이 없습니다.
                                        </div>
                                    </c:if>

                                    <!-- 페이지네이션 -->
                                    <nav class="mt-4">
                                        <ul class="pagination justify-content-center">
                                            <c:if test="${pager.prev}">
                                                <li class="page-item">
                                                    <a class="page-link" href="?curPage=${pager.startPage - 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&read=${read}">이전</a>
                                                </li>
                                            </c:if>
                                            <c:forEach var="i" begin="${pager.startPage}" end="${pager.endPage}">
                                                <li class="page-item ${pager.curPage == i ? 'active' : ''}">
                                                    <a class="page-link" href="?curPage=${i}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&read=${read}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            <c:if test="${pager.next}">
                                                <li class="page-item">
                                                    <a class="page-link" href="?curPage=${pager.endPage + 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}&read=${read}">다음</a>
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
		<script src="/js/notification/list.js"></script>
	</body>
</html>
