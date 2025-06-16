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
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

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
  <div class="modal fade" id="staticBackdrop2" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="staticBackdropLabel">채팅방 이름 수정</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          ...
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary">수정</button>
        </div>
      </div>
    </div>
  </div>
  <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="staticBackdropLabel">채팅 참여 목록</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
        <c:forEach items="${members}" var="mem">
	        <c:if test="${mem.username ne user.username}">
            <form action="/chat/kick" method="post">
              <a href="#" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between py-3">
                <input hidden name="roomId" value="${mem.roomId}">
                <input hidden name="username" value="${mem.username}">
                <div class="d-flex align-items-center">
                <img src="/img/default.png" 
                  class="rounded-circle me-3" 
                  width="48" height="48" 
                  alt="avatar">
                <div>
                    <div class="fw-bold">${mem.username}</div>
                </div>
                </div>
                <div class="text-end">
                <c:if test="${user.username eq host}">
                  <button type="submit" class="btn btn-outline-danger">강퇴</button>
                </c:if>
                </div>
              </a>
            </form>
	        </c:if>
        </c:forEach>
        </div>
      </div>
    </div>
  </div>
  <div class="chat-wrapper">
    <form action="/chat/out" method="post">
      <div class="chat-header" style="display: flex; justify-content: space-between; align-items: center; height: 47px;">
        <div>
          <strong>${room.roomName}</strong>
          <c:if test="${user.username eq host}">
            <button type="button" class="btn btn-primary-outline" style="padding-right: 6px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop2">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-fill" viewBox="0 0 16 16">
                <path d="M12.854.146a.5.5 0 0 0-.707 0L10.5 1.793 14.207 5.5l1.647-1.646a.5.5 0 0 0 0-.708zm.646 6.061L9.793 2.5 3.293 9H3.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.207zm-7.468 7.468A.5.5 0 0 1 6 13.5V13h-.5a.5.5 0 0 1-.5-.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.5-.5V10h-.5a.5.5 0 0 1-.175-.032l-.179.178a.5.5 0 0 0-.11.168l-2 5a.5.5 0 0 0 .65.65l5-2a.5.5 0 0 0 .168-.11z"/>
              </svg>
            </button>
          </c:if>
        </div>
        <input hidden name="username" value="${user.username}">
        <input hidden name="roomId" value="${room.roomId}">
        <div>
          <button type="button" class="btn btn-primary-outline" style="padding-right: 6px;"  data-bs-toggle="modal" data-bs-target="#staticBackdrop">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-card-text" viewBox="0 0 16 16">
              <path d="M14.5 3a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2z"/>
              <path d="M3 5.5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5M3 8a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9A.5.5 0 0 1 3 8m0 2.5a.5.5 0 0 1 .5-.5h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5"/>
            </svg>
          </button>
          <button type="submit" class="btn btn-primary-outline" id="outRoom" style="padding-right: 6px;" >
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-door-open-fill" viewBox="0 0 16 16">
              <path d="M1.5 15a.5.5 0 0 0 0 1h13a.5.5 0 0 0 0-1H13V2.5A1.5 1.5 0 0 0 11.5 1H11V.5a.5.5 0 0 0-.57-.495l-7 1A.5.5 0 0 0 3 1.5V15zM11 2h.5a.5.5 0 0 1 .5.5V15h-1zm-2.5 8c-.276 0-.5-.448-.5-1s.224-1 .5-1 .5.448.5 1-.224 1-.5 1"/>
            </svg>
          </button>
        </div>
        
        <input hidden id="getRoomId" value="${room.roomId}">
      </div>
    </form>
    
    <div class="chat-body" id="chatContent">
      <input hidden id="sender" value="${user.username}">
      <c:forEach var="msg" items="${msg}">
        <c:choose>
          <c:when test="${msg.senderId == user.username}">
            <input hidden id="createdAt" name="createdAt" value="${msg.createdAt}">
            <div class="d-flex justify-content-end align-items-end mb-2">
              <div class="small text-muted ms-2" style="padding-right: 10px;">${msg.createdAt}</div>
              <div class="bg-primary text-dark rounded px-3 py-2 shadow-sm" style="max-width: 60%;">
                ${msg.contents}
              </div>
            </div>
          </c:when>

          <c:otherwise>
            <div class="d-flex flex-column align-items-start mb-1">
              <div class="small text-muted mb-1 fw-bold">${msg.senderId}</div>
              <div class="d-flex align-items-end">
                <div class="bg-white border rounded px-3 py-2 shadow-sm">${msg.contents}</div>
                <div class="small text-muted me-2" style="padding-left: 10px;">${msg.createdAt}</div>
              </div>
            </div>
          </c:otherwise>
        </c:choose>
      </c:forEach>
    </div>

      <div class="chat-footer bg-light border-top px-3 py-2 position-sticky bottom-0" style="z-index: 100;">
        <form id="chatForm" class="d-flex align-items-center gap-2" enctype="multipart/form-data">
          
          <label for="imageInput" class="btn btn-outline-secondary mb-0 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
            <i class="bi bi-image"></i>
          </label>
          <input type="file" id="imageInput" accept="image/*" hidden />

          <input type="text" id="msgInput" style="width: 74%;" class="form-control" placeholder="메시지 입력" autocomplete="off" />

          <button type="submit" class="btn btn-primary px-3">전송</button>

        </form>
      </div>
      

  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-…"crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.5.1/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
  <script src="/js/chat/chat.js"></script>
</body>
</html>
