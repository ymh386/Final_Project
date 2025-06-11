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
	<body class="sb-nav-fixed bg-dark">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content">
                <main>
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-5">
                                <div class="card shadow-lg border-0 rounded-lg mt-5">
                                    <div class="card-header"><h3 class="text-center font-weight-light my-4">Login</h3></div>
                                    <div class="card-body">
										    <ul class="nav nav-tabs">
												<li class="nav-item">
													<a class="nav-link" aria-current="page" href="./login">member</a>
												</li>
												<li class="nav-item">
													<a class="nav-link active" href="./trainerLogin">trainer</a>
												</li>
											</ul>
										    <form id="loginForm" action="/users/login" method="post">
											<div class="form-floating mb-3">
												<input class="form-control"  type="text" name="username" id="username">
												<label for="inputEmail">아이디</label>
											</div>
											<div class="form-floating mb-3">
                                                <input class="form-control" id="inputPassword" name="password" type="password" placeholder="Password">
                                                <label for="inputEmail">Password</label>
                                            </div>
											<c:if test="${not empty param.error}">
												<p>${param.error}</p>
											</c:if>
											<input name="loginType" type="hidden" value="trainer">
											<input id="autoLogin" type="checkbox"><label for="inputEmail">자동 로그인</label>
											<input id="autoFlag" name="auto" type="hidden" value="false">
											<input id="rememberId" type="checkbox"><label> id 저장</label><br>
											<a href="/oauth2/authorization/kakao?redirect=trainer"><img src="/img/kakao.png"></a>
											<a href="/oauth2/authorization/google?redirect=trainer"><img src="/img/1x.png"></a><br>
											<div style="margin: 10px auto;">
												<button style="width: 400px; margin-bottom: 10px;" class="btn btn-dark d-block mx-auto" type="submit">login</button>
												<button style="width: 400px;" class="btn btn-dark d-block mx-auto" type="submit">join</button>
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