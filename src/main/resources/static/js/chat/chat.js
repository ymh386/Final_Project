const user2 = document.getElementById("user2");
const getRoomId = document.getElementById("getRoomId");
const sender = document.getElementById("sender");
const outRoom = document.getElementById("outRoom");
const host = document.getElementById("host");
let roomId = getRoomId.value;
const senderimg = document.getElementById("senderimg");
const fileInput = document.getElementById('fileInput');
const fileModal = document.getElementById('fileModal');
const previewContainer = document.getElementById('previewContainer');
const modalBackdrop = document.getElementById('modalBackdrop');
const sendBtn = document.getElementById('sendBtn');
const cancelBtn = document.getElementById('cancelBtn');
const src = senderimg.getAttribute("src");

let online = [];
let chatSub, presenceSub;
let selectedFiles = [];

// 파일 선택창 열기 (예: 이미지 아이콘 클릭 시)
function openFileDialog() {
  fileInput.click();
}

// 파일 선택 후 이벤트
fileInput.addEventListener('change', (e) => {
  selectedFiles = Array.from(e.target.files);
  if (selectedFiles.length > 0) {
    showPreview(selectedFiles);
    showModal();
  }
});

// 미리보기 생성
function showPreview(files) {
  previewContainer.innerHTML = '';
  files.forEach(file => {
    const reader = new FileReader();
    reader.onload = (ev) => {
      const img = document.createElement('img');
      img.id='media';
      img.src = ev.target.result;
      img.style.width = '100%';
      img.style.marginBottom = '10px';

      const filename = document.createElement('input');
      filename.id='filename';
      filename.type='hidden';
      filename.value=file.name;
      previewContainer.appendChild(img);
      previewContainer.appendChild(filename);
    };
    reader.readAsDataURL(file);
  });
}

// 모달 열기
function showModal() {
  fileModal.style.display = 'block';
  modalBackdrop.style.display = 'block';
}

// 모달 닫기
function closeModal() {
  fileModal.style.display = 'none';
  modalBackdrop.style.display = 'none';
  fileInput.value = ''; // 선택 초기화
  selectedFiles = [];
  previewContainer.innerHTML = '';
}

// 전송 버튼 클릭
sendBtn.addEventListener('click', () => {

  sendImg(selectedFiles[0]);
  console.log('선택된 파일 전송:', selectedFiles[0].name);
  closeModal();
});

// 취소 버튼 클릭
cancelBtn.addEventListener('click', () => {
  closeModal();
});

// 모달 백그라운드 클릭 시 모달 닫기
modalBackdrop.addEventListener('click', () => {
  closeModal();
});


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
        online = JSON.parse(message.body);
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

  function sendImg(file) {

    console.log("sendImg 함수 진입")
    
    const formData = new FormData();

    formData.append('file', file);

    fetch('/chat/uploadImg', {
      method: 'POST',
      body: formData,
    })
    .then(res => res.json())
    .then(data => {
      sendFile(data.uploaded);
    })
    .catch(console.error)
  }
  
  function sendFile(url) {
    console.log("sendFile 함수 진입")
    const payload = {
      roomId:roomId,
      senderId: username1,
      mediaUrl: url,
      contents: "사진을 보냈습니다.",
      messageType: "IMAGE"
    };
    window.stompClient.send("/app/chat.sendFile", {}, JSON.stringify(payload));
    document.getElementById("media").setAttribute("src", "");
  }


function showMessage(msg) {
    const chatBox = document.getElementById("chatContent");
    const msgDiv = document.createElement("div");
    if (msg.senderId === username1) {
      if (msg.messageType === 'TEXT'){
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
            <div class="d-flex justify-content-end align-items-end mb-2">
            <input hidden name="contents" value="${msg.contents}">
            <input hidden name="createdAt" value="${msg.createdAt}">
                <div class="small text-muted ms-2" style="padding-right: 10px;">${msg.createdAt}</div>
                <div class="bg-primary text-dark rounded px-3 py-2 shadow-sm" style="max-width: 60%;">
                  <img 
                    src="/files/chat/${msg.mediaUrl}" 
                    alt="첨부 이미지" 
                    style="max-width:100%; border-radius:.5rem"
                  />
                </div>
            </div>
        `;
      }
    } else {
      if (msg.messageType === 'TEXT'){
        msgDiv.innerHTML = `
            <div class="d-flex flex-column align-items-start mb-1">
            <input hidden name="createdAt" value="${msg.createdAt}">
                <div class="small text-muted mb-1 member" data-sender-id='${msg.senderId}'>${msg.senderId}<span class="badge">🟢</span></div>
                <div class="d-flex align-items-end">
                  <img 
                    src="${src}" 
                    alt="avatar" 
                    class="rounded-circle me-2" 
                    width="32" height="32"
                  />
                    <div class="bg-white border rounded px-3 py-2 shadow-sm">
                      ${msg.contents}
                    </div>
                    <div class="small text-muted me-2" style="padding-left: 10px;">${msg.createdAt}</div>
                </div>
            </div>
        `;
      } else {
                msgDiv.innerHTML = `
            <div class="d-flex flex-column align-items-start mb-1">
            <input hidden name="createdAt" value="${msg.createdAt}">
                <div class="small text-muted mb-1 member" data-sender-id='${msg.senderId}'>${msg.senderId}<span class="badge">🟢</span></div>
                <div class="d-flex align-items-end">
                  <img 
                    src="${src}" 
                    alt="avatar" 
                    class="rounded-circle me-2" 
                    width="32" height="32"
                  />
                    <div class="bg-white border rounded px-3 py-2 shadow-sm">
                      <img 
                        src="/files/chat/${msg.mediaUrl}" 
                        alt="첨부 이미지" 
                        style="max-width:100%; border-radius:.5rem"
                      />
                    </div>
                    <div class="small text-muted me-2" style="padding-left: 10px;">${msg.createdAt}</div>
                </div>
            </div>
        `;
      }
    }
    chatBox.appendChild(msgDiv);
    chatBox.scrollTop = chatBox.scrollHeight;

    renderOnline(online);
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
