const notificationBtn = document.getElementById("notificationButton");
const badge = document.getElementById("notificationBadge");
const notificationList = document.getElementById("notificationList");
const username = document.getElementById("notification").getAttribute("data-username");



//topic/notify/{username} 구독
function connectStomp() {
    // 이미 연결된 경우 아무것도 하지 않음
    if (window.stompClient && window.stompClient.connected) {
        console.log("이미 소켓에 연결됨");
        return;
    }
    

  const socket = new SockJS('/ws-chat');
  window.stompClient = Stomp.over(socket);

  window.stompClient.connect({}, function () {
    window.stompClient.subscribe('/topic/notify/' + username, function (message) {
      const notification = JSON.parse(message.body);
      
    //채팅메세지는 제외
    if(notification.notificationType != 'N0'){
        addNotification(notification); // 실시간 알림 추가
    }
      
      showToast(notification)
      notificationSound()
    });
  });
}

// 종 버튼 클릭 -> 알림 불러오기
notificationBtn.addEventListener('click', ()=>{
    
    fetch("/notification/unread")
    .then(r => r.json())
    .then(r => {
        renderNotificationList(r);
    })
})

//알림목록 렌더링
function renderNotificationList(r) {
    notificationList.innerHTML='';

    if(r.length === 0) {
        notificationList.innerHTML = '<li class="dropdown-item text-muted">새로운 알림이 없습니다</li>';
        return;
    }

    r.forEach(n => {
        

        const li = document.createElement("li");
        li.className = "dropdown-item d-flex align-items-start gap-2 border-bottom py-2";

        li.innerHTML = `
        <i class="bi bi-info-circle-fill text-primary mt-1"></i>
        <div class="flex-grow-1">
            <a href="${n.linkUrl}" onclick="readNotification(event, '${n.linkUrl}', ${n.notificationId})"
            class="text-decoration-none text-dark fw-bold d-block">
            ${n.notificationTitle}
            </a>
            <p>${n.message.replace(/\n/g, "<br>")}</p>
            <small class="text-muted">${getRelativeTime(n.createdAt)} · ${n.senderVO?.name || '알 수 없음'}</small>
        </div>
        `;
        li.addEventListener('click', (e)=>{
            readNotification(e, n.linkUrl, n.notificationId)
         })
        notificationList.append(li);

    })
}

 // 실시간 알림 추가
function addNotification(notification) {
    

    notificationList.innerHTML='';
    const list = document.getElementById("notificationList");

    const li = document.createElement("li");
    li.className = "dropdown-item d-flex align-items-start gap-2 border-bottom py-2";

    li.innerHTML = `
      <i class="bi bi-info-circle-fill text-primary mt-1"></i>
      <div class="flex-grow-1">
        <a href="${notification.linkUrl}" onclick="readNotification(event, '${notification.linkUrl}', ${notification.notificationId})"
           class="text-decoration-none text-dark fw-bold d-block">
          ${notification.notificationTitle}
        </a>
        <p>${notification.message.replace(/\n/g, "<br>")}</p>
        <small class="text-muted">${getRelativeTime(notification.createdAt)} · ${notification.senderVO?.name || '알 수 없음'}</small>
      </div>
    `;
    li.addEventListener('click', (e) => {
        readNotification(e, notification.linkUrl, notification.notificationId)
    })
    list.append(li);
    updateBadgeCount(1);
}

// 읽음 처리
function readNotification(event, linkUrl, notificationId) {
    event.preventDefault();
    let f = new FormData();
    f.append("notificationId", notificationId)
    fetch('/notification/read', { 
        method: 'POST',
        body: f
    })
    .then(r=>r.json())
    .then(r => {
        if(r > 0){
            event.target.closest("li").remove();
            updateBadgeCount(-1);
            window.location.href = linkUrl;
        }else {
            alert("읽기 실패")
        }
    });
}

// 뱃지 숫자 갱신
function updateBadgeCount(change) {
    let count = parseInt(badge.textContent) || 0;
    count += change;
    if (count <= 0) {
    badge.style.display = "none";
    } else {
    badge.textContent = count;
    badge.style.display = "inline-block";
    }
}

// 초기 알림 수 불러오기 + 소켓 연결
window.addEventListener("load", () => {
    fetch("/notification/unreadCount")
        .then(r => r.json())
        .then(r => {
        if (r > 0) {
            badge.textContent = r;
            badge.style.display = "inline-block";
        } else {
            badge.style.display = "none";
        }
        });

    connectStomp(); // 소켓 연결 시작
});

//시간(몇분 전) 불러오기
function getRelativeTime(timestamp) {
  const now = new Date();
  const past = new Date(timestamp);
  const diff = Math.floor((now - past) / 1000); // 초 단위 차이

  if (diff < 60) return '방금 전';
  if (diff < 3600) return `${Math.floor(diff / 60)}분 전`;
  if (diff < 86400) return `${Math.floor(diff / 3600)}시간 전`;
  if (diff < 2592000) return `${Math.floor(diff / 86400)}일 전`;
  if (diff < 31536000) return `${Math.floor(diff / 2592000)}개월 전`;
  return `${Math.floor(diff / 31536000)}년 전`;
}

//토스트형 실시간 알림 팝업 호출
function showToast(notification) {
    const toastId = `toast-${Date.now()}`; // 고유 ID

    const toast = document.createElement("div");
    toast.className = "toast align-items-center text-bg-dark border-0 show mb-2";
    toast.id = toastId;
    toast.role = "alert";
    toast.innerHTML = `
        <div class="d-flex flex-column">
            <div class="toast-header bg-dark text-white">
                <strong class="me-auto">${notification.senderVO?.name || '알 수 없음'}</strong>
                <small class="text-white-50 ms-2">${notification.notificationTitle}</small>
                <button type="button" class="btn-close btn-close-white ms-2 mb-1" data-bs-dismiss="toast" aria-label="Close"></button>
            </div><hr>
            <div class="toast-body">
                <a href="${notification.linkUrl}" class="text-white text-decoration-none">

                    ${notification.message.replace(/\n/g, "<br>")}

                </a><br>
            </div>
        </div>
    `;

    document.getElementById("toastContainer").appendChild(toast);

    // 자동 제거 (5초 후)
    setTimeout(() => {
        toast.classList.remove("show");
        toast.addEventListener("transitionend", () => toast.remove());
    }, 5000);
}

//알림소리 재생
function notificationSound() {
    const sound = document.getElementById("notificationSound");
    if (sound) {
        sound.play().catch(e => {
            // 보통 사용자 상호작용 없으면 일부 브라우저에서 막히기도 함
            console.log("알림소리 재생 실패:", e);
        })
    }
}