<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>ADMIN</h1>
	    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h2 {
            margin-bottom: 20px;
        }
        #buttons {
            margin-bottom: 20px;
        }
        #buttons button {
            padding: 10px 20px;
            margin-right: 10px;
            font-size: 16px;
            cursor: pointer;
        }
        #stateList {
            width: 100%;
            border-collapse: collapse;
        }
        #stateList th, #stateList td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        #stateList th {
            background-color: #f4f4f4;
        }
        .disabled {
            background-color: #ddd;
            color: #666;
            cursor: not-allowed;
        }
    </style>
	
	<h2>승인 대기 리스트</h2>
        <table id="stateList">
            <thead>
                <tr>
                    <th>유저ID</th>
                    <th>상태</th>
                    <th>승인</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${userList}" var="u">
                    <tr>
                        <form action="/admin/updateState?username=${u.username}" method="post">
                            <td>${u.username}</td>
                            <td>승인 필요</td>
                            <td><button type="submit">승인</button></td>
                        </form>
                    </tr>
        </c:forEach>
            </tbody>
        </table>
        <button id="submit" type="submit">승인</button>
<script src="/js/admin.js"></script>
</body>
</html>