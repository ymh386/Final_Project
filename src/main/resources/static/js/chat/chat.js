const createBtn = document.getElementById("createBtn");

function makeChat() {
window.open(
'http://localhost/chat/chat',
'_blank',
'width=500,height=700,left=100,top=100,resizable=no'
);
}

function makeRoom() {
window.open(
'http://localhost/',
'_blank',
'width=500,height=700,left=100,top=100,resizable=no'
);
}

function openChatRoom() {
    window.open(
    '/',
    '_blank',
    'width=500,height=700,left=100,top=100,resizable=no'
    );
}

document.addEventListener("DOMContentLoaded", ()=>{
    createBtn.addEventListener("click", createGroupChat);
});

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
    //location.href = `/chat/room/view/${data.roomId}`;
  })
  .catch(err => {
    console.error(err);
    alert("오류가 발생했습니다.");
  });
}
