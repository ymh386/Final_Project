const user2 = document.getElementById("user2");
const getRoomId = document.getElementById("getRoomId");
const sender = document.getElementById("sender");
const outRoom = document.getElementById("outRoom");

function makeChat() {
window.open(
'http://localhost:81/chat/chat',
'_blank',
'width=500,height=700,left=100,top=100,resizable=no'
);
}

function makeRoom() {
window.open(
'http://localhost:81/',
'_blank',
'width=500,height=700,left=100,top=100,resizable=no'
);
}

function openChatRoom(roomId) {
    window.open(
    'http://localhost:81/chat/detail/'+roomId,
    '_blank',
    'width=500,height=700,left=100,top=100,resizable=no'
    );
}

function createSingleChat(targetUsername) {
  fetch("/chat/makeChat", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ target: targetUsername })
  })
  .then(res => {
    if (!res.ok) throw new Error("1:1 채팅 생성 실패");
    return res.json();
  })
  .then(data => {
    openChatRoom(`${data.roomId}`);
    if (window.opener && !window.opener.closed) {
      window.opener.location.reload();
    }
  })
  .catch(err => {
    console.error(err);
    alert("오류가 발생했습니다.");
  });
}

function createGroupChat() {
    console.log("생성 시도")
  const selected = [];
  document.querySelectorAll(".user-checkbox:checked").forEach(cb => {
    selected.push(cb.value);
  });

  if (selected.length < 2) {
    alert("2명 이상 선택해주세요.");
    return;
  }

  fetch("/chat/makeRoom", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ users: selected })
  })
  .then(res => {
    if (!res.ok) throw new Error("채팅방 생성 실패");
    return res.json();
  })
  .then(data => {
    if (window.opener && !window.opener.closed) {
      window.opener.location.reload();
    }
    openChatRoom(`${data.roomId}`)
  })
  .catch(err => {
    console.error(err);
    alert("오류가 발생했습니다.");
  });
}

document.getElementById("chatForm").addEventListener("submit", function(e) {
    e.preventDefault();
    sendMessage();
});

outRoom.addEventListener('click', async ()=>{
    await fetch(`/chat/out`, { method: 'POST' });
    if (window.opener && !window.opener.closed) {
      alert('채팅방을 퇴장하였습니다.');
      window.opener.location.reload();
    }

    window.close();
})
  let roomId = getRoomId.value;
  const username1 = sender.value;

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
    });
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
