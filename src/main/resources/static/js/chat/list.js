const myUsername = document.getElementById("senderId");
function makeChat() {
window.open(
`${window.baseUrl}/chat/chat`,
'_blank',
'width=500,height=700,left=100,top=100,resizable=no'
);
}

function makeRoom() {
window.open(
`${window.baseUrl}/`,
'_blank',
'width=500,height=700,left=100,top=100,resizable=no'
);
}

function openChatRoom(roomId) {
  const badge = document.querySelector(`#chat-list-item-${roomId} .unread`);
  if (badge){
    badge.remove();
  }
    window.open(
    `${window.baseUrl}/chat/detail/`+roomId,
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
  
  function connectList() {
    console.log("WebSocket 연결 시도")

    const socket = new SockJS('/ws-chat');
    const listClient = Stomp.over(socket);
    listClient.connect({}, () => {
    // 리스트 갱신용 토픽 구독
    listClient.subscribe('/topic/chat/list', msg => {
        console.log("바디"+msg.body);
      const { roomId, message, createdAt, senderId} =
          JSON.parse(msg.body);

      const item = document.querySelector(`#chat-list-item-${roomId}`);
      if (!item) return;
      item.querySelector('.last-message').innerText=message;
      item.querySelector('.chat-time').innerText=createdAt;
      if (senderId==myUsername.value){

      }
      else if (senderId != myUsername.value) {
        const badge = item.querySelector('.unread');
        if (!badge) {
          const span = document.createElement('span');
          span.className ='badge bg-danger rounded-pill unread';
          span.innerText = '1';
          item.querySelector('.text-end').appendChild(span);
        } else {
          const old = parseInt(badge.innerText,10) || 0;
          badge.innerText = old + 1;
          badge.style.display='inline-block';
        }
      }
      
    });
  })
}



window.onload = function() {
  connectList();
}