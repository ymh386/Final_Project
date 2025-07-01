const deleteUser = document.getElementById("deleteUser");

deleteUser.addEventListener('click', ()=>{
    if(confirm('정말로 탈퇴하시겠습니까?\n* 탈퇴 시 모든정보가 삭제되며 구독중인 구독권은 복구 불가합니다. *')) {
        // 모달 열기
        const modal = new bootstrap.Modal(document.getElementById('passwordModal'));
        modal.show();
    }
})

// 확인 버튼 클릭 시
document.getElementById('confirmDeleteBtn').addEventListener('click', () => {
    const password = document.getElementById('confirmPassword').value;
    const errorMsg = document.getElementById('errorMsg');

    // 비밀번호 검증 (AJAX 호출 또는 간단한 예시로 작성)
    let f = new FormData();
    f.append("password", password)
    fetch('./checkPassword', {
        method: 'POST',
        body: f
    })
    .then(r => r.json())
    .then(r => {
        console.log(r)
        if (r) {
            // 탈퇴 요청
            fetch('./deleteUser', {
                method: 'POST',
            }).then(() => {
                alert("회원 탈퇴가 완료되었습니다.");
                // 로컬스토리지나 쿠키에서 JWT 토큰 제거
                localStorage.removeItem("token"); // 또는
                sessionStorage.removeItem("token");

                // 또는 쿠키에 저장했다면
                document.cookie = "Authorization=; path=/; max-age=0";
                location.href = '/'; // 또는 홈으로 리다이렉트
            });
        } else {
            errorMsg.style.display = 'block';
        }
    });
});