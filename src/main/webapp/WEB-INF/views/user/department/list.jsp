<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
<head>
    <meta charset="UTF-8">
    <title>부서 정보</title>
    <c:import url="/WEB-INF/views/templates/header.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="sb-nav-fixed d-flex flex-column min-vh-100">
    <c:import url="/WEB-INF/views/templates/topbar.jsp" />
    <div id="layoutSidenav" class="d-flex flex-grow-1">
        <c:import url="/WEB-INF/views/templates/sidebar.jsp" />
        <div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
            <main class="flex-grow-1">
                <div class="container mt-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-secondary text-white d-flex justify-content-between align-items-center">
                            <h4 class="mb-0"><i class="bi bi-diagram-3"></i> 부서 정보</h4>
                            <div>
                                <a class="btn btn-sm btn-outline-light me-2" href="./add">
                                    <i class="bi bi-plus-circle"></i> 부서 생성
                                </a>
                                <a class="btn btn-sm btn-outline-warning" href="./user">
                                    <i class="bi bi-people"></i> 부서별 회원 관리
                                </a>
                            </div>
                        </div>
                        <div class="card-body">
                            <sec:authorize access="hasRole('ADMIN')">
                                <c:if test="${not empty ar}">
                                    <div class="table-responsive shadow-sm rounded">
                                        <table class="table table-hover align-middle text-center">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th scope="col">부서번호</th>
                                                    <th scope="col">부서명</th>
                                                    <th scope="col">부서 요약</th>
                                                    <th scope="col">수정</th>
                                                    <th scope="col">삭제</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="a" items="${ar}">
                                                    <tr>
                                                        <td>${a.departmentId}</td>
                                                        <td class="text-start">${a.departmentName}</td>
                                                        <td class="text-start">${a.description}</td>
                                                        <td><a class="btn btn-sm btn-outline-dark" href="./update?departmentId=${a.departmentId}"><i class="bi bi-pencil"></i></a></td>
                                                        <td><a class="btn btn-sm btn-outline-danger" href="./delete?departmentId=${a.departmentId}"><i class="bi bi-trash"></i></a></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                                <c:if test="${empty ar}">
                                    <div class="alert alert-light border text-center mt-4" role="alert">
                                        <i class="bi bi-exclamation-circle"></i> 조회된 부서가 없습니다.
                                    </div>
                                </c:if>
                            </sec:authorize>
                            <sec:authorize access="!hasRole('ADMIN')">
                                <div class="alert alert-warning text-center mt-4" role="alert">
                                    <i class="bi bi-lock-fill"></i> 관리자만 접근 가능한 페이지입니다.
                                </div>
                            </sec:authorize>
                        </div>
                    </div>
                </div>
            </main>
            <c:import url="/WEB-INF/views/templates/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>