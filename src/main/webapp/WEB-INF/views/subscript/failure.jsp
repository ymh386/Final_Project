<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head><title>결제 실패</title></head>
<body>
<h1>결제 실패</h1>
<p>에러 코드: ${errorCode}</p>
<p>메시지: ${message}</p>
<a href="/subscript/list">돌아가기</a>
</body>
</html>
