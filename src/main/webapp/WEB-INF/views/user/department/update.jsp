<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>부서 수정 - 관리자 전용</title>
    <c:import url="/WEB-INF/views/templates/header.jsp" />
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body class="sb-nav-fixed d-flex flex-column min-vh-100">
    <c:import url="/WEB-INF/views/templates/topbar.jsp" />
    <div id="layoutSidenav" class="d-flex flex-grow-1">
        <c:import url="/WEB-INF/views/templates/sidebar.jsp" />
        <div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
            <main class="flex-grow-1">
                <div class="container py-4">

                    <sec:authorize access="hasRole('ADMIN')">
                        <div class="card shadow-sm mx-auto" style="max-width: 600px;">
                            <div class="card-header bg-secondary text-white">
                                <h4 class="mb-0"><i class="bi bi-pencil-square"></i> 부서 수정</h4>
                            </div>
                            <div class="card-body">
                                <form action="./update" method="post" class="needs-validation" novalidate>
                                    <input type="hidden" name="departmentId" value="${vo.departmentId}" />
                                    
                                    <div class="mb-3">
                                        <label for="departmentName" class="form-label">부서명</label>
                                        <input type="text" class="form-control" id="departmentName" name="departmentName" value="${vo.departmentName}" required>
                                        <div class="invalid-feedback">
                                            부서명을 입력해주세요.
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="description" class="form-label">부서 설명</label>
                                        <input type="text" class="form-control" id="description" name="description" value="${vo.description}" required>
                                        <div class="invalid-feedback">
                                            부서 설명을 입력해주세요.
                                        </div>
                                    </div>

                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-lg"></i> 수정 완료
                                    </button>
                                    <a href="./list" class="btn btn-secondary ms-2">
                                        <i class="bi bi-x-lg"></i> 취소
                                    </a>
                                </form>
                            </div>
                        </div>
                    </sec:authorize>

                    <sec:authorize access="!hasRole('ADMIN')">
                        <div class="alert alert-warning mt-5 text-center" role="alert">
                            <i class="bi bi-lock-fill"></i> 관리자만 이용 가능합니다.
                        </div>
                    </sec:authorize>

                </div>
            </main>
            <c:import url="/WEB-INF/views/templates/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Bootstrap 5 폼 유효성 검사 활성화 스크립트
        (() => {
            'use strict'
            const forms = document.querySelectorAll('.needs-validation')
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html>
