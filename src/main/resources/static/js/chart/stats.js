
function onScopeChange(scope) {
    //부서 드롭다운 영역
  const dept = document.getElementById("deptSelectContainer");
  //직원 드롭다운 영역
  const user = document.getElementById("userSelectContainer");

  // 숨김/표시 처리
  if (scope === "dept") {
    //부서만 보이고 직원은 숨김
    dept.style.display = "block";
    user.style.display = "none";
  } else if (scope === "user") {
    //부서, 직원 모두 표시
    dept.style.display = "block";
    user.style.display = "block";
  } else {
    //둘 다 숨김(필터 없음)
    dept.style.display = "none";
    user.style.display = "none";
  }

  // 자동 새로고침 제거
  // document.getElementById("filterForm").submit(); ← 제거
}

//부서 선택 드롭다운이 변경될 때 호출되는 함수
function onDeptChange() {
    //scope(범위가 user가 아닐 경우 함수 종료)
  const scope = document.querySelector("select[name='scope']").value;
  if (scope !== "user") return;

  //선택된 부서 ID와 직원 드롭다운 요소 가져옴
  const deptId = document.getElementById("deptSelect").value;
  const userSelect = document.getElementById("userSelect");

  //로딩 길때 보여줄 메세지
  userSelect.innerHTML = "<option>불러오는 중...</option>";

  fetch(`./usersOfDepartment?departmentId=${deptId}`)
    .then(r => r.json())
    .then(r => {
      userSelect.innerHTML = "<option value=''>선택</option>";
      //받아온 직원리스트 반복시키기
      r.forEach(user => {
        //각 사용자에 대해 옵션 요소를 만들구 userSelect에 추가
        const opt = document.createElement("option");
        opt.value = user.username;
        opt.text = user.name + '(' + user.username + ')';
        userSelect.appendChild(opt);
      });
    })
    .catch(err => {
      userSelect.innerHTML = "<option>불러오기 실패</option>";
      console.error("직원 불러오기 오류:", err);
    });
}

//페이지 처음 로드 시 이전 선택값 기준으로 필드 표시
window.addEventListener("DOMContentLoaded", () => {
    const selectedScope = "<c:out value='${scope}' default='all'/>";
    onScopeChange(selectedScope);
});