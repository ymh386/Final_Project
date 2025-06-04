<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<body>

    <a href="/">home</a>
	<h3>login</h3>
    <ul class="nav nav-tabs">
        <li class="nav-item">
            <a class="nav-link active" aria-current="page" href="./login">member</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="./trainerLogin">trainer</a>
        </li>
    </ul>
    <form id="loginForm" action="/users/login" method="post">
        <div>
            <input type="text" name="username" id="username">
        </div>
        <input type="password" name="password"><br>
        <input name="loginType" type="hidden" value="member">
        <input id="autoLogin" type="checkbox"><label>자동 로그인</label>
        <input id="autoFlag" name="auto" type="hidden" value="false">
        <input id="rememberId" type="checkbox"><label>id 저장</label><br>
  		<a href="/oauth2/authorization/kakao?redirect=">Kakao로 로그인</a>
        <a href="/oauth2/authorization/google?redirect=">Google로 로그인</a><br>
        <button type="submit">login</button>
    </form>

<script src="/js/login.js"></script>
</body>
</html>