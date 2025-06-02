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
    <form action="/users/login" method="post">
        <input type="text" name="username">
        <input type="password" name="password">
        <button type="submit">login</button>
    </form>

</body>
</html>