<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>채팅창</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
    }

    .chat-wrapper {
      height: 100%;
      display: flex;
      flex-direction: column;
    }

    .chat-header {
      padding: 10px;
      background-color: #f8f9fa;
      border-bottom: 1px solid #ccc;
    }

    .chat-body {
      flex: 1;
      padding: 10px;
      overflow-y: auto;
      background-color: #fff;
    }

    .chat-footer {
      padding: 10px;
      border-top: 1px solid #ccc;
      background-color: #f8f9fa;
    }
  </style>
</head>
<body>
  <sec:authentication property="principal" var="user"/>
  <div class="chat-wrapper">
    <div class="chat-header">
      <strong>1:1 채팅 시작</strong>
    </div>

    <div class="chat-body" id="chatContent">
      <c:if test="${empty list}">
        <div class="d-flex justify-content-center align-items-center" 
        style="height: 60vh;">
          <h1 class="text-muted">친구가 없습니다ㅠㅠㅠ 불쌍해라</h1>
        </div>
      </c:if>
      <ul class="nav nav-tabs">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="./chat">1:1</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="./room">채팅방</a>
          <input hidden name="roomName" value="test">
        </li>
      </ul>
      <c:forEach var="l" items="${list}">
        <form>
          <a href="#" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between py-3">
            <div class="d-flex align-items-center">
            <img src="/img/default.png" 
              class="rounded-circle me-3" 
              width="48" height="48" 
              alt="avatar">
            <div>
                <div class="fw-bold">${l.user2}</div>
                <input hidden id="user2" name="user2" value="${l.user2}">
                <input hidden name="user1" value="${user.username}">
            </div>
            </div>
            <div class="text-end">
              <button type="button" onclick="createSingleChat('${l.user2}')" class="btn btn-outline-primary">채팅 시작</button>
            </div>
          </a>
        </form>
      </c:forEach>	
    </div>
  </div>
		<script>
		window.baseUrl = '${pageContext.request.contextPath}';
		</script>  
	<script src="/js/chat/list.js"></script>   
</body>
</html>
