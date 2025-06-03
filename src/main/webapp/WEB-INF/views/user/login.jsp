<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h3>login</h3>
    <form id="loginForm" action="/users/login" method="post">
        <div>
            <input type="text" name="username" id="username">
        </div>
        <input type="password" name="password"><br>
        <input id="autoLogin" type="checkbox"><label>자동 로그인</label>
        <input id="autoFlag" name="auto" type="hidden" value="false">
        <input id="rememberId" type="checkbox"><label>id 저장</label><br>
        <a href="/oauth2/authorization/google">Google로 로그인</a>
        <button type="submit">login</button>
    </form>

<script src="/js/login.js"></script>
</body>
</html>