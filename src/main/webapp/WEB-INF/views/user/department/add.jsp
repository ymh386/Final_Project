<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
<head>
    <meta charset="UTF-8">
    <title>부서 생성</title>
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
                    <div class="card shadow-sm mx-auto" style="max-width: 600px;">
                        <div class="card-header bg-secondary text-white">
                            <h4 class="mb-0"><i class="bi bi-plus-circle"></i> 부서 생성</h4>
                        </div>
                        <div class="card-body">
                            <sec:authorize access="hasRole('ADMIN')">
                                <form action="./add" method="post" class="needs-validation" novalidate>
                                    <div class="mb-3">
                                        <label class="form-label">부서명</label>
                                        <input type="text" class="form-control" name="departmentName" required>
                                        <div class="invalid-feedback">부서명을 입력하세요.</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">부서 설명</label>
                                        <input type="text" class="form-control" name="description">
                                    </div>
                                    <button type="submit" class="btn btn-dark">
                                        <i class="bi bi-check-circle"></i> 생성
                                    </button>
                                    <a href="./list" class="btn btn-outline-secondary ms-2">
                                        <i class="bi bi-arrow-left-circle"></i> 목록으로
                                    </a>
                                </form>
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
    <script>
        (() => {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
