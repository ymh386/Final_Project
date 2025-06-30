<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>부서별 회원 관리</title>
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
                <div class="container py-4" style="max-width: 720px;">

                    <sec:authorize access="hasRole('ADMIN')">
                        <h2 class="mb-4"><i class="bi bi-people-fill"></i> <span id="title">부서별 회원 관리</span></h2>

                        <div class="mb-4 d-flex flex-wrap gap-2">
                            <button type="button" id="addUser" class="btn btn-outline-primary flex-grow-1 flex-sm-grow-0" style="min-width: 140px;">
                                <i class="bi bi-person-plus"></i> 회원 추가하기
                            </button>
                            <button type="button" id="updateUser" class="btn btn-outline-primary flex-grow-1 flex-sm-grow-0" style="min-width: 140px;">
                                <i class="bi bi-pencil-square"></i> 회원 수정하기
                            </button>
                            <button type="button" id="deleteUser" class="btn btn-outline-danger flex-grow-1 flex-sm-grow-0" style="min-width: 140px;">
                                <i class="bi bi-person-dash"></i> 회원 탈퇴하기
                            </button>
                            <button type="button" id="headUser" class="btn btn-outline-warning flex-grow-1 flex-sm-grow-0" style="min-width: 140px;">
                                <i class="bi bi-award"></i> 부서장 임명
                            </button>
                        </div>

                        <form id="userDeptForm" class="mb-4">
                            <div class="mb-3">
                                <label for="userSelect" class="form-label">회원 선택</label>
                                <select id="userSelect" name="username" class="form-select">
                                    <option value="" selected>-- 회원 선택 --</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="deptSelect" class="form-label">부서 선택</label>
                                <select id="deptSelect" name="departmentId" class="form-select">
                                    <option id="deptSelected" value="" selected>-- 부서 선택 --</option>
                                </select>
                            </div>
                        </form>

                        <div id="utilBtn" class="d-flex gap-2"></div>
                    </sec:authorize>

                    <sec:authorize access="!hasRole('ADMIN')">
                        <div class="alert alert-warning text-center" role="alert">
                            <i class="bi bi-lock-fill"></i> 관리자만 이용 가능합니다.
                        </div>
                    </sec:authorize>

                </div>
            </main>
            <c:import url="/WEB-INF/views/templates/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/department/userByDepartment.js"></script>
</body>
</html>
