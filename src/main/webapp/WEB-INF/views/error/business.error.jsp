<%-- business-error.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>처리 오류</title>
    <style>
        .error-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ffc107;
            border-radius: 5px;
            text-align: center;
            background-color: #fff3cd;
        }
        .error-icon {
            font-size: 48px;
            color: #856404;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 18px;
            margin-bottom: 20px;
            color: #856404;
        }
        .btn {
            background-color: #ffc107;
            color: #212529;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 3px;
            display: inline-block;
            margin: 5px;
        }
        .btn:hover {
            background-color: #e0a800;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h2>처리 중 오류가 발생했습니다</h2>
        <div class="error-message">
            <c:out value="${errorMessage}" />
        </div>
        
        <c:if test="${not empty errorCode}">
            <p><strong>오류 코드:</strong> <c:out value="${errorCode}" /></p>
        </c:if>
        
        <div>
            <a href="javascript:history.back()" class="btn">이전 페이지</a>
            <a href="/" class="btn">홈으로</a>
        </div>
    </div>
</body>
</html>