const notificationBtn = document.getElementById("notificationButton");
const badge = document.getElementById("notificationBadge");
const notificationList = document.getElementById("notificationList");
const username = document.getElementById("notification").getAttribute("data-username");

let stompClient = null;

//topic/notify/{username} 구독
function connectStomp() {
    // 이미 연결된 경우 아무것도 하지 않음
    if (stompClient && stompClient.connected) {
        console.log("이미 소켓에 연결됨");
        return;
    }

  const socket = new SockJS('/ws-chat');
  stompClient = Stomp.over(socket);

  stompClient.connect({}, function () {
    stompClient.subscribe('/topic/notify/' + username, function (message) {
      const notification = JSON.parse(message.body);
      addNotification(notification); // 실시간 알림 추가
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
        console.log(n)
        const li = document.createElement("li");
        li.className = "dropdown-item d-flex align-items-start gap-2 border-bottom py-2";

        li.innerHTML = `
        <i class="bi bi-info-circle-fill text-primary mt-1"></i>
        <div class="flex-grow-1">
            <a href="${n.linkUrl}" onclick="readNotification(event, '${n.linkUrl}', ${n.notificationId})"
            class="text-decoration-none text-dark fw-bold d-block">
            ${n.message}
            </a>
            <small class="text-muted">${getRelativeTime(n.createdAt)}</small>
            <small class="text-muted">${n.senderVO.name}</small>
        </div>
        `;
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
          ${notification.message}
        </a>
        <small class="text-muted">${getRelativeTime(notification.createdAt)}</small>
        <small class="text-muted">${notification.senderVO.name}</small>
      </div>
    `;
    list.prepend(li);
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