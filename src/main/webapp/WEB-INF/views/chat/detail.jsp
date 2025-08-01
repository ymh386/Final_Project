<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>채팅창</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

  <style>
    .chat-footer {
      border-top: 1px solid #ddd;
      position: sticky;
      bottom: 0;
      background: #f8f9fa;
      z-index: 100;
    }

    #msgInput {
      height: 40px; /* 버튼과 높이 맞춤 */
    }

    #chatForm button {
      height: 40px; /* 입력창과 버튼 높이 맞춤 */
    }

    form {
      margin: 0; /* form 기본 margin 제거 */
    }

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
    .member .badge { 
      display: none; 
    }
    
    .member.online .badge { 
      display: inline-block; 
    }

    .date-badge {
      background: #f1f0f0;
      margin: 0.5rem 0;
      padding: 0.25rem 0.75rem;
      border-radius: 10px;
      font-size: 0.875rem;
      color: #666;
    }
    </style>
</head>
<body>
  <sec:authentication property="principal" var="user"/>
  <input hidden id="host" value="${map.host}">
  <div class="modal fade" id="staticBackdrop3" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="staticBackdropLabel">친구 초대</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <c:forEach items="${map.friend}" var="frn">
              <form action="/chat/invite" method="post">
                <a href="#" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between py-3">
                  <input hidden name="roomId" value="${map.room.roomId}">
                  <input hidden name="user" value="${user.username}">
                  <div class="d-flex align-items-center">
                  <img src="/img/default.png" 
                    class="rounded-circle me-3" 
                    width="48" height="48" 
                    alt="avatar">
                  <div>
                      <div class="fw-bold">${frn}</div>
                      <input hidden name="username" value="${frn}">
                  </div>
                  </div>
                  <div class="text-end">
                    <button type="submit" class="btn btn-primary-outline">
                      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-circle" viewBox="0 0 16 16" style="display: block;">
                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                        <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                      </svg>
                    </button>
                  </div>
                </a>
              </form>
          </c:forEach>
        </div>
      </div>
    </div>
  </div>
  <form action="/chat/rename" method="post">
    <div class="modal fade" id="staticBackdrop2" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="staticBackdropLabel">채팅방 이름 수정</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="input-group mb-3">
              <input hidden id="rId" name="roomId" value="${map.room.roomId}">
              <input type="text" class="form-control" placeholder="${map.room.roomName}" name="roomName" aria-label="Username" aria-describedby="basic-addon1">
            </div>
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">수정</button>
          </div>
        </div>
      </div>
    </div>
  </form>

  <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="staticBackdropLabel">채팅 참여 목록</h1>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
        <c:forEach items="${map.members}" var="mem">
              <form method="post">
                <form method="post">
                  <a href="#" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between py-3">
                    <input hidden name="roomId" value="${mem.roomId}">
                    <div class="d-flex align-items-center">
                    <c:if test="${mem.sns eq null and mem.fileName ne 'default'}">
                    	<img src="/files/user/${mem.fileName}"
                         id="senderimg"
                    		 class="rouned-circle me-3"
                    		 width="48" height="48"
                    		 alt="avatar">
                    </c:if>
                    <c:if test="${mem.sns ne null}">
                    	<img src="${mem.fileName}"
                         id="senderimg"
                    		 class="rouned-circle me-3"
                    		 width="48" height="48"
                    		 alt="avatar">
                    </c:if>
                    <c:if test="${mem.sns eq null and mem.fileName eq 'default'}">
	                    <img src="/img/default.png"
                         id="senderimg" 
	                      class="rounded-circle me-3" 
	                      width="48" height="48" 
	                      alt="avatar">
                    </c:if>
                    <div>
                      <c:if test="${user.username ne mem.username}">
                        <div class="fw-bold">${mem.username}</div>
                      </c:if>
                      <c:if test="${user.username eq mem.username}">
                        <div class="fw-bold">${mem.username} (나)</div>
                      </c:if>
                        <input hidden name="username" value="${mem.username}">
                        <input hidden name="createdBy" value="${mem.username}">
                    </div>
                    </div>
                    <div class="text-end">
                    <c:if test="${user.username eq map.host and user.username ne mem.username}">
                      <button formaction="/chat/changeHost" type="submit" class="btn btn-outline-primary">방장 변경</button>
                      <button formaction="/chat/kick" type="submit" class="btn btn-outline-danger">강퇴</button>
                    </c:if>
                    <c:forEach items="${map.notFriend}" var="nfri">
                      <c:if test="${mem.username eq nfri.user2}">
                        <button formaction="/friend/suggestList" type="submit" class="btn btn-primary-outline">
                          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-circle" viewBox="0 0 16 16" style="display: block;">
                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                            <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                          </svg>
                        </button>
                      </c:if>
                    </c:forEach>
                    </div>
                  </a>
                </form>
              </form>
        </c:forEach>
        </div>
      </div>
    </div>
  </div>
  <div class="chat-wrapper" style="display: flex; flex-direction: column; height: 100vh;">
    <form action="/chat/out" method="post">
      <div class="chat-header" style="display: flex; justify-content: space-between; align-items: center; height: 47px;">
        <div style="display: flex; align-items: center;">
          <strong style="display: inline-block; margin-right: 5px;">${map.room.roomName}</strong>
          <c:if test="${user.username eq map.host}">
            <button type="button" class="btn btn-primary-outline" style="padding-right: 6px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop2">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-fill" viewBox="0 0 16 16" style="display: block;">
                <path d="M12.854.146a.5.5 0 0 0-.707 0L10.5 1.793 14.207 5.5l1.647-1.646a.5.5 0 0 0 0-.708zm.646 6.061L9.793 2.5 3.293 9H3.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.207zm-7.468 7.468A.5.5 0 0 1 6 13.5V13h-.5a.5.5 0 0 1-.5-.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.5-.5V10h-.5a.5.5 0 0 1-.175-.032l-.179.178a.5.5 0 0 0-.11.168l-2 5a.5.5 0 0 0 .65.65l5-2a.5.5 0 0 0 .168-.11z"/>
              </svg>
            </button>
          </c:if>
        </div>
        <input hidden name="username" value="${user.username}">
        <input hidden name="roomId" value="${map.room.roomId}">
        <div>

          <button type="button" class="btn btn-primary-outline" style="padding-right: 6px;"  data-bs-toggle="modal" data-bs-target="#staticBackdrop3">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-circle" viewBox="0 0 16 16" style="display: block;">
              <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
              <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
            </svg>
          </button>
          <button type="button" class="btn btn-primary-outline" style="padding-right: 6px;"  data-bs-toggle="modal" data-bs-target="#staticBackdrop">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-card-text" viewBox="0 0 16 16" style="display: block;">
              <path d="M14.5 3a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-13a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5zm-13-1A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2z"/>
              <path d="M3 5.5a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9a.5.5 0 0 1-.5-.5M3 8a.5.5 0 0 1 .5-.5h9a.5.5 0 0 1 0 1h-9A.5.5 0 0 1 3 8m0 2.5a.5.5 0 0 1 .5-.5h6a.5.5 0 0 1 0 1h-6a.5.5 0 0 1-.5-.5"/>
            </svg>
          </button>
          <c:if test="${user.username eq map.host}">
            <button type="submit" class="btn btn-primary-outline" id="outRoom" style="padding-right: 6px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop4" >
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-door-open-fill" viewBox="0 0 16 16" style="display: block;">
                <path d="M1.5 15a.5.5 0 0 0 0 1h13a.5.5 0 0 0 0-1H13V2.5A1.5 1.5 0 0 0 11.5 1H11V.5a.5.5 0 0 0-.57-.495l-7 1A.5.5 0 0 0 3 1.5V15zM11 2h.5a.5.5 0 0 1 .5.5V15h-1zm-2.5 8c-.276 0-.5-.448-.5-1s.224-1 .5-1 .5.448.5 1-.224 1-.5 1"/>
              </svg>
            </button>
          </c:if>
          <c:if test="${user.username ne map.host}">
            <button type="submit" class="btn btn-primary-outline" id="outRoom" style="padding-right: 6px;" >
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-door-open-fill" viewBox="0 0 16 16" style="display: block;">
                <path d="M1.5 15a.5.5 0 0 0 0 1h13a.5.5 0 0 0 0-1H13V2.5A1.5 1.5 0 0 0 11.5 1H11V.5a.5.5 0 0 0-.57-.495l-7 1A.5.5 0 0 0 3 1.5V15zM11 2h.5a.5.5 0 0 1 .5.5V15h-1zm-2.5 8c-.276 0-.5-.448-.5-1s.224-1 .5-1 .5.448.5 1-.224 1-.5 1"/>
              </svg>
            </button>
          </c:if>

        </div>
        
        <input hidden id="getRoomId" data-room-id="${map.room.roomId}" value="${map.room.roomId}">
      </div>
    </form>
    
    <div class="chat-body" id="chatContent" style="flex: 1; overflow-y: auto;">
      <input hidden id="sender" value="${user.username}">
      <c:forEach var="msg" items="${map.msg}" varStatus="status">
        <!-- 1) 오늘 VO 의 java.sql.Date 를 "yyyy-MM-dd" 문자열로 포맷해서 변수에 저장 -->
        <fmt:formatDate value="${msg.date}" pattern="yyyy-MM-dd" var="thisDate"/>

        <!-- 2) 이전 VO 의 date 도 같은 방식으로 포맷 -->
        <c:if test="${!status.first}">
          <fmt:formatDate value="${map.msg[status.index-1].date}" pattern="yyyy-MM-dd" var="prevDate"/>
        </c:if>

        <!-- 3) 첫 메시지이거나 날짜가 바뀌었으면 배지 추가 -->
        <c:if test="${status.first or thisDate ne prevDate}">
          <li class="list-group-item date-badge text-center">
            <small>${thisDate}</small>
          </li>
        </c:if>
        <c:choose>
          <c:when test="${msg.senderId == user.username}">
            <input hidden id="createdAt" name="createdAt" value="${msg.createdAt}">
            <input hidden name="messageId" value="${msg.messageId}">
            <div class="d-flex justify-content-end align-items-end mb-2">
              <div class="d-flex flex-column align-items-end me-2">
                <div class="small text-muted">${msg.createdAt}</div>
              </div>
              <div class="bg-primary text-dark rounded px-3 py-2 shadow-sm" style="max-width: 60%;">
                <c:choose>
                  <c:when test="${msg.messageType == 'IMAGE'}">
                    <img 
                      src="/files/chat/${msg.mediaUrl}" 
                      alt="첨부 이미지" 
                      style="max-width:100%; border-radius:.5rem"
                    />
                  </c:when>
                  <c:otherwise>                
                    ${msg.contents}
                  </c:otherwise>
                </c:choose>                    
              </div>
            </div>
          </c:when>

          <c:otherwise>
      <div class="d-flex flex-column align-items-start mb-1">
        <input hidden name="messageId" value="${msg.messageId}">
        <div class="small text-muted mb-1 fw-bold member" data-sender-id="${msg.senderId}">${msg.senderId}<span class="badge">🟢</span></div>

        <div class="d-flex align-items-end">
        <c:if test="${map.img[status.index] eq 'default'}">
          <img 
            src="${pageContext.request.contextPath}/img/${map.img[status.index]}.png" 
            alt="avatar" 
            class="rounded-circle me-2" 
            width="32" height="32"
          />        
        </c:if>
        <c:if test="${map.img[status.index] ne 'default'}">
          <img 
            src="${map.img[status.index]}" 
            alt="avatar" 
            class="rounded-circle me-2" 
            width="32" height="32"
          />
        </c:if>

          <!-- ② 말풍선 안에 텍스트 or 이미지 분기 -->
          <div class="bg-white border rounded px-3 py-2 shadow-sm" style="max-width: 60%;">
            <c:choose>
              <c:when test="${msg.messageType == 'IMAGE'}">
                <img 
                  src="/files/chat/${msg.mediaUrl}" 
                  alt="첨부 이미지" 
                  style="max-width:100%; border-radius:.5rem"
                />
              </c:when>
              <c:otherwise>
                ${msg.contents}
              </c:otherwise>
            </c:choose>
          </div>

          <!-- ③ 보낸 시간 -->
          <div class="d-flex flex-column align-items-start ms-2">
            <div class="small text-muted">${msg.createdAt}</div>
          </div>
        </div>
      </div>
          </c:otherwise>
        </c:choose>
      </c:forEach>
       <span id="bottom"></span>
    </div>

      <div class="chat-footer d-flex align-items-center gap-2 p-2" style="border-top: 1px solid #ddd; position: sticky; bottom: 0; background: #f8f9fa; z-index: 100;">
        <form style="flex: 0 0 auto; margin: 0;" id="imgForm" enctype="multipart/form-data">
          <label for="fileInput" class="btn btn-outline-secondary mb-0 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
            <i class="bi bi-image"></i>
            </label>
            <input type="file" id="fileInput" accept="image/*" style="display: none;" multiple />
            
            <div id="fileModal" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%, -50%);
                background:white; border-radius:10px; box-shadow:0 0 10px rgba(0,0,0,0.2); padding:20px; width:320px; z-index:1000;">
              <h5>파일 전송</h5>
              <div id="previewContainer" style="max-height:300px; overflow-y:auto; margin-bottom:10px;">
                <!-- 선택한 이미지 썸네일 목록이 여기에 표시됨 -->
              </div>
              <button id="sendBtn">전송</button>
              <button id="cancelBtn">취소</button>
            </div>
            <div id="modalBackdrop" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh;
              background:rgba(0,0,0,0.3); z-index:900;"></div>
        </form>

        <form id="chatForm" class="d-flex align-items-center gap-2 flex-grow-1" enctype="multipart/form-data" style="margin: 0;">
          <input type="text" id="msgInput" style="width: 84%;" class="form-control" placeholder="메시지 입력" autocomplete="off" />

          <button type="submit" class="btn btn-primary px-3">전송</button>

        </form>
      </div>
      

  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1.5.1/dist/sockjs.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
  <script>
    window.onload = function () {
      const bottom = document.getElementById("bottomMarker");
      if (bottom) {
        bottom.scrollIntoView({ behavior: "auto" }); // 또는 "smooth"
      }
    };
  </script>
		<script>
		window.baseUrl = '${pageContext.request.contextPath}';
		</script>
    <script src="/js/chat/chat.js"></script>
</body>
</html>
