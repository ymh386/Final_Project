<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
<head>
    <meta charset="UTF-8">
    <title>감사 로그</title>
    <c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="sb-nav-fixed d-flex flex-column min-vh-100">
    <c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
    <div id="layoutSidenav" class="d-flex flex-grow-1">
        <c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
        <div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
            <main class="flex-grow-1">
                <div class="container">
                    <div class="container mt-4">
                        <div class="card shadow-sm">
                            <div class="card-header bg-secondary text-white d-flex justify-content-between align-items-center">
                                <h4 class="mb-0">감사 로그 관리</h4>
                                <a href="./excel?searchField=${pager.searchField}&searchWord=${pager.searchWord}" class="btn btn-sm btn-success">
                                    ⬇ 엑셀 다운로드
                                </a>
                            </div>
                            <div class="card-body">
                                <!-- 검색/필터 폼 -->
                                <form method="get" class="row row-cols-lg-auto g-3 align-items-center mb-4">
                                    <div class="col">
                                        <select name="searchField" class="form-select form-select-sm">
                                            <option value="username" ${pager.searchField eq 'username' ? 'selected' : ''}>사용자</option>
                                            <option value="ACTION_TYPE" ${pager.searchField eq 'ACTION_TYPE' ? 'selected' : ''}>행위</option>
                                            <option value="IP_ADDRESS" ${pager.searchField eq 'IP_ADDRESS' ? 'selected' : ''}>IP주소</option>
                                        </select>
                                    </div>
                                    <div class="col">
                                        <input type="text" name="searchWord" class="form-control form-control-sm" value="${pager.searchWord}" placeholder="검색어 입력">
                                    </div>
                                    <div class="col">
                                        <button type="submit" class="btn btn-sm btn-dark">
                                            <i class="bi bi-search"></i> 검색
                                        </button>
                                    </div>
                                </form>

                                <!-- 테이블 출력 -->
                                <c:if test="${not empty ar}">
                                    <div class="table-responsive shadow-sm rounded">
                                        <table class="table table-hover align-middle text-center">
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
                                                        <td class="text-start" style="white-space: pre-line;">${log.description}</td>
                                                        <td>${log.createdAt}</td>
                                                        <td>${log.ipAddress}</td>
                                                        <td class="text-start"><small>${log.userAgent}</small></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>

                                <!-- 결과 없음 -->
                                <c:if test="${empty ar}">
                                    <div class="alert alert-secondary text-center mt-4" role="alert">
                                        조회된 감사 로그가 없습니다.
                                    </div>
                                </c:if>

                                <!-- 페이지네이션 -->
                                <nav class="mt-4">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${pager.prev}">
                                            <li class="page-item">
                                                <a class="page-link" href="?curPage=${pager.startPage - 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}">이전</a>
                                            </li>
                                        </c:if>
                                        <c:forEach var="i" begin="${pager.startPage}" end="${pager.endPage}">
                                            <li class="page-item ${pager.curPage == i ? 'active' : ''}">
                                                <a class="page-link" href="?curPage=${i}&searchField=${pager.searchField}&searchWord=${pager.searchWord}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <c:if test="${pager.next}">
                                            <li class="page-item">
                                                <a class="page-link" href="?curPage=${pager.endPage + 1}&searchField=${pager.searchField}&searchWord=${pager.searchWord}">다음</a>
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
