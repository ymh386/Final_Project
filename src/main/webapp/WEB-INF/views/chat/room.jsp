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
      <strong>그룹 채팅 시작</strong>
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
          <a class="nav-link" aria-current="page" href="./chat">1:1</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" href="./room">채팅방</a>
        </li>
      </ul>
      <c:forEach var="l" items="${list}">
        <form action="/chat/makeSingleRoom" method="post">
          <a href="#" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between py-3">
            <div class="d-flex align-items-center">
            <img src="/img/default.png" 
              class="rounded-circle me-3" 
              width="48" height="48" 
              alt="avatar">
            <div>
                <div class="fw-bold">${l.user2}</div>
                <input hidden name="user2" value="${l.user2}">
                <input hidden name="user1" value="${user.username}">
            </div>
            </div>
            <div class="text-end">
              <input class="form-check-input user-checkbox" type="checkbox" value="${l.user2}" id="checkDefault">
            </div>
          </a>
        </form>
      </c:forEach>	
    </div>

    <div class="chat-footer">
        <div class="d-flex justify-content-end">
         <button class="btn btn-primary" id="createBtn" type="button">채팅방 생성</button>
        </div>
    </div>
  </div>
	<script src="/js/chat/chat.js"></script> 
</body>
</html>
