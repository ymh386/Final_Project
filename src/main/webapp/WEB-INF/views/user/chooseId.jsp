<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
	<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
		<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
	</head>
	<body class="sb-nav-fixed bg-dark d-flex flex-column min-vh-100">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content">
                <main class="flex-fill d-flex justify-content-center align-items-start">
                    <div class="container">
                        <div class="row vh-100 justify-content-center">
                            <div class="col-lg-5 d-flex">
                                <div class="card shadow-lg border-0 rounded-lg flex-fill">
                                    <div class="card-header"><h3 class="text-center font-weight-light my-4">비밀번호 찾기</h3></div>
                                    <div class="card-body">									
											<h5 class="text-center font-weight-light my-4">해당 회원의 임시 비밀번호를 발송합니다.</h5>
										    <form id="findPwForm" action="/user/findPw" method="post">
												<input hidden name="phone" value="${phone}">
												<ul class="list-group list-group-flush">
													<c:forEach var="id" items="${users}">
														<li class="list-group-item d-flex justify-content-between">
															<label>
															<input type="radio" name="username" value="${id.username}" required />
															${id.username}
														</label>
													</li>
												</c:forEach>
												</ul>
											<c:if test="${not empty param.error}">
												<p>${param.error}</p>
											</c:if>
											<div style="margin: 10px auto;">
												<button style="width: 400px; margin-top: 10px; margin-bottom: 10px;" class="btn btn-dark d-block mx-auto" type="submit">발송</button>
											</div>
											
										</form>
                                    </div>
                                    <c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
	
	
	
	
		</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="/js/login.js"></script>
	</body>
</html>