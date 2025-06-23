const user2 = document.getElementById("user2");
const getRoomId = document.getElementById("getRoomId");
const sender = document.getElementById("sender");
const outRoom = document.getElementById("outRoom");
const host = document.getElementById("host");
let roomId = getRoomId.value;


document.getElementById("chatForm").addEventListener("submit", function(e) {
    e.preventDefault();
    sendMessage();
});
let hostId=host.value;
console.log(hostId)
console.log(sender.value)
if (hostId != sender.value){
  outRoom.addEventListener('click', async ()=>{
      await fetch(`${window.baseUrl}/chat/out`, { method: 'POST' });
      if (window.opener && !window.opener.closed) {
        alert('채팅방을 퇴장하였습니다.');
        window.opener.location.reload();
      }
  
      window.close();
  })
}


    var username1 = sender.value;
    console.log(username1)

  function connect() {
    // 이미 연결된 경우 아무것도 하지 않음
    if (window.stompClient && window.stompClient.connected) {
        console.log("이미 소켓에 연결됨");
        return;
    }
    

    console.log("WebSocket 연결 시도")
    const socket = new SockJS("/ws-chat");
    console.log("WebSocket 연결 완료")
    window.stompClient = Stomp.over(socket);
    window.stompClient.connect({}, function (frame) {
      console.log("Connected: " + frame);

      // 메시지 수신 구독
      window.stompClient.subscribe(`/topic/chat/${roomId}`, function (message) {
        const msg = JSON.parse(message.body);
        showMessage(msg);
      });

      window.stompClient.subscribe(`/topic/chat/${roomId}/presence`, function (message) {
        const online = JSON.parse(message.body);
        console.log(online)
        renderOnline(online);
      })
    });
  }

  function renderOnline (online) {
    console.log("렌더링 함수 진입")
    document.querySelectorAll('.member').forEach(el => {
      const name = el.dataset.senderId;
      el.classList.toggle('online', online.includes(name));
    })
  }

  function sendMessage() {
    
    const content = document.getElementById("msgInput").value;


    const payload = {
      roomId: roomId,
      senderId: username1,
      contents: content,
      messageType: "TEXT"
    };
    window.stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(payload));
    document.getElementById("msgInput").value="";
  }


function showMessage(msg) {
    const chatBox = document.getElementById("chatContent");
    const msgDiv = document.createElement("div");
    if (msg.senderId === username1) {
        msgDiv.innerHTML = `
            <div class="d-flex justify-content-end align-items-end mb-2">
            <input hidden name="contents" value="${msg.contents}">
            <input hidden name="createdAt" value="${msg.createdAt}">
                <div class="small text-muted ms-2" style="padding-right: 10px;">${msg.createdAt}</div>
                <div class="bg-primary text-dark rounded px-3 py-2 shadow-sm" style="max-width: 60%;">
                    ${msg.contents}
                </div>
            </div>
        `;
    } else {
        msgDiv.innerHTML = `
            <div class="d-flex flex-column align-items-start mb-1">
            <input hidden name="createdAt" value="${msg.createdAt}">
                <div class="small text-muted mb-1">${msg.senderId}</div>
                <div class="d-flex align-items-end">
                    <div class="bg-white border rounded px-3 py-2 shadow-sm">${msg.contents}</div>
                    <div class="small text-muted me-2" style="padding-left: 10px;">${msg.createdAt}</div>
                </div>
            </div>
        `;
    }
    chatBox.appendChild(msgDiv);
    chatBox.scrollTop = chatBox.scrollHeight;
}

function scrollToBottom() {
  const marker = document.getElementById("bottom");
  if (marker) {
    marker.scrollIntoView({ behavior: "auto", block: "end" });
  }
}

window.onload = function() {
  connect();
  scrollToBottom();
}
