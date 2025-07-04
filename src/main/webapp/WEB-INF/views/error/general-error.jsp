
<%-- general-error.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>시스템 오류</title>
    <style>
        .error-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-align: center;
        }
        .error-icon {
            font-size: 48px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 18px;
            margin-bottom: 20px;
            color: #333;
        }
        .error-details {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 3px;
            margin: 20px 0;
            text-align: left;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 3px;
            display: inline-block;
            margin: 5px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h2>시스템 오류가 발생했습니다</h2>
        <div class="error-message">
            <c:out value="${errorMessage}" default="알 수 없는 오류가 발생했습니다." />
        </div>
        
        <div class="error-details">
            <strong>요청 URL:</strong> <c:out value="${requestUrl}" /><br>
            <strong>발생 시간:</strong> <c:out value="${timestamp}" /><br>
            <c:if test="${not empty errorCode}">
                <strong>오류 코드:</strong> <c:out value="${errorCode}" /><br>
            </c:if>
        </div>
        
        <div>
            <a href="javascript:history.back()" class="btn">이전 페이지</a>
            <a href="/" class="btn">홈으로</a>
        </div>
    </div>
</body>
</html>