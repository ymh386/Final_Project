<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
<head>
    <meta charset="UTF-8">
    <title>양식 목록 - 관리자 전용</title>
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
                                <h4 class="mb-0"><i class="bi bi-files"></i> 양식 목록</h4>
                                <a href="./formRegister" class="btn btn-sm btn-dark">
                                    <i class="bi bi-plus-circle"></i> 양식 등록
                                </a>
                            </div>
                            <div class="card-body">
                                <sec:authorize access="hasRole('ADMIN')">
                                    <c:if test="${not empty ar}">
                                        <div class="table-responsive shadow-sm rounded">
                                            <table class="table table-hover align-middle text-center">
                                                <thead class="table-dark">
                                                    <tr>
                                                        <th scope="col">양식번호</th>
                                                        <th scope="col">양식이름</th>
                                                        <th scope="col">제작일시</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="a" items="${ar}">
                                                        <tr class="table-row" style="cursor:pointer;" onclick="location.href='./formDetail?formId=${a.formId}'">
                                                            <td>${a.formId}</td>
                                                            <td class="text-start">${a.formTitle}</td>
                                                            <td>${a.createdAt}</td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty ar}">
                                        <div class="alert alert-light border text-center mt-4" role="alert">
                                            <i class="bi bi-exclamation-circle"></i> 조회된 양식이 없습니다.
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
                </div>
            </main>
            <c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
        </div>
    </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
