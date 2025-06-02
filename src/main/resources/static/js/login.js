

console.log("폼 제출 이벤트 연결됨");

document.getElementById("loginForm").addEventListener("submit", function () {
  console.log("로그인 제출됨");

  const username = document.getElementById("username").value;
  const remember = document.getElementById("rememberId").checked;

  console.log("입력한 아이디:", username);
  console.log("아이디 저장 체크 여부:", remember);

  if (remember) {
    document.cookie = "rememberId=" + encodeURIComponent(username) + "; path=/; max-age=2592000";
  } else {
    document.cookie = "rememberId=; path=/; max-age=0";
  }
  
});


window.addEventListener("DOMContentLoaded", function () {
  const cookies = document.cookie.split("; ");
  for (let cookie of cookies) {
    if (cookie.startsWith("rememberId=")) {
      const savedId = decodeURIComponent(cookie.split("=")[1]);
      console.log("저장된 아이디:", savedId);
      document.getElementById("username").value = savedId;
      document.getElementById("rememberId").checked = true;
    }
  }
});

  window.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("loginForm");
    const checkbox = document.getElementById("autoLogin");
    const hiddenInput = document.getElementById("autoFlag");

    console.log("✅ 스크립트 로드됨");
    console.log("폼:", form);
    console.log("체크박스:", checkbox);
    console.log("히든값:", hiddenInput);

    if (!form || !checkbox || !hiddenInput) {
      console.error("❌ 요소를 찾을 수 없습니다. ID 확인 필요");
      return;
    }

    form.addEventListener("submit", function (e) {
      console.log("🟢 폼 제출 이벤트 발생");
      console.log("체크박스 체크 상태:", checkbox.checked);
      hiddenInput.value = checkbox.checked ? "true" : "false";
      console.log("히든 값으로 설정된 값:", hiddenInput.value);
    });
  });


