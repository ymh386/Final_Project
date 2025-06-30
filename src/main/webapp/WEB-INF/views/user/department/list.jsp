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
                            <sec:authorize access="hasRole('ADMIN')">
                                <h2>부서정보</h2>
                                

                                <c:if test="${not empty ar}">

                                    <table class="table table-hover table-bordered">
                                        <thead class="table-dark">
                                            <tr>
                                                <th scope="col">부서번호</th>
                                                <th scope="col">부서명</th>
                                                <th scope="col">부서 요약</th>
                                                <th scope="col"></th>
                                                <th scope="col"></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="a" items="${ar}">
                                                <tr class="table-row">
                                                    <th scope="row">${a.departmentId}</th>
                                                    <td>${a.departmentName}</td>
                                                    <td>${a.description}</td>
                                                    <td><a class="btn btn-outline-dark" href="./update?departmentId=${a.departmentId}">수정</a></td>
                                                    <td><a href="./delete?departmentId=${a.departmentId}" class="btn btn-outline-dark">삭제</a></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:if>
                                <c:if test="${empty ar}">
                                    <h3>조회된 부서가 없습니다.</h3>
                                </c:if>

                                <a class="btn btn-dark" href="./add">부서 생성</a>
                                <a class="btn btn-warning" href="./user">부서별 회원 관리</a>
                            </sec:authorize>
                        
                            <sec:authorize access="!hasRole('ADMIN')">
                                <h3>관리자만 이용 가능합니다.</h3>
                            </sec:authorize>
                        </div>




					</div>
				</main>
                <c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
        
					
	    
	
	
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>