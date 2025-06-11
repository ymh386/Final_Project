const addUser = document.getElementById("addUser");
const updateUser = document.getElementById("updateUser");
const deleteUser = document.getElementById("deleteUser");
const userSelect = document.getElementById("userSelect");
const deptSelect = document.getElementById("deptSelect");
const deptSelected = document.getElementById("deptSelected");
const utilBtn = document.getElementById("utilBtn");
const headUser = document.getElementById("headUser");

const title = document.getElementById("title");

//부서별 회원 추가기능
addUser.addEventListener('click', ()=>{

    clearUI();

    title.innerHTML = '부서별 회원 관리(추가)'
    
    fetch("./getUsers?check=0")
    .then(r => r.json())
    .then(r=>{

        getUsersAndDepts(r.users, r.departments)

    }).catch(e => {
        console.log(e)
    })

    //추가 버튼
    const addBtn = document.createElement('button');
    addBtn.innerHTML = '추가'
    utilBtn.append(addBtn)

    addBtn.addEventListener('click', ()=>{
        if(userSelect.value != '' && deptSelect.value != ''){
            updateDepartment()
        }else {
            alert("회원과 부서를 선택해주세요.")
        }
    })

})

//부서별 회원 수정 기능
updateUser.addEventListener('click', ()=>{

    clearUI();

    title.innerHTML = '부서별 회원 관리(수정)'

    fetch("./getUsers?check=1")
    .then(r => r.json())
    .then(r=>{

       getUsersAndDepts(r.users, r.departments)
        
    }).catch(e => {
        console.log(e)
    })

    //수정버튼
    const updateBtn = document.createElement('button');
    updateBtn.innerHTML = '수정'
    utilBtn.append(updateBtn)

    updateBtn.addEventListener('click', ()=>{
        if(userSelect.value != '' && deptSelect.value != ''){
            updateDepartment()
        }else {
            alert("회원과 부서를 선택해주세요.")
        }
    })
})

//부서별 회원 탈퇴 기능
deleteUser.addEventListener('click', ()=>{

    clearUI();

    title.innerHTML = '부서별 회원 관리(탈퇴)'

    fetch("./getUsers?check=1")
    .then(r => r.json())
    .then(r=>{
        let users = r.users
        for(let user of users) {
            const option = document.createElement('option');
            option.value = user.username
            option.innerHTML = user.name
            userSelect.append(option)
            deptSelected.value = user.departmentVO.departmentId
            deptSelected.value = user.departmentVO.departmentName
        }
        //선택한 유저의 부서 자동 선택
        userSelect.addEventListener('change', ()=>{
            selectDeptByUser(users)
        })
        
    }).catch(e => {
        console.log(e)
    })

    //탈퇴버튼
    const deleteBtn = document.createElement('button');
    deleteBtn.innerHTML = '탈퇴'
    utilBtn.append(deleteBtn)

    deleteBtn.addEventListener('click', ()=>{
        if(userSelect.value != '' && deptSelect.value != ''){
            const f = new FormData();
            f.append("username", userSelect.value)
            fetch("./updateUser", {
                method:"POST",
                body: f
            })
            .then(r=>r.json())
            .then(r=>{
                if(r > 0) {
                    alert("완료되었습니다.")
                    location.href="./user"
                }
            }).catch(e => {
                alert("오류발생")
                location.href="./user"
            })
        }else {
            alert("회원과 부서를 선택해주세요.")
        }
    })
})

//부서장 임명 기능
headUser.addEventListener('click', ()=>{

    clearUI();

    title.innerHTML = '부서별 회원 관리(부서장 임명)'

    fetch("./getUsers?check=1")
    .then(r => r.json())
    .then(r=>{
        let users = r.users
        for(let user of users) {
            const option = document.createElement('option');
            option.value = user.username
            option.innerHTML = user.name
            userSelect.append(option)
            deptSelected.value = user.departmentVO.departmentId
            deptSelected.value = user.departmentVO.departmentName
        }
        //선택한 유저의 부서 자동 선택
        userSelect.addEventListener('change', ()=>{
            selectDeptByUser(users)
        })
        
    }).catch(e => {
        console.log(e)
    })

    //임명 버튼
    const headBtn = document.createElement('button');
    headBtn.innerHTML = '임명'
    utilBtn.append(headBtn)

    headBtn.addEventListener('click', ()=>{
        if(userSelect.value != '' && deptSelect.value != ''){
            const f = new FormData();
            f.append("username", userSelect.value)
            f.append("departmentId", deptSelect.value)
            fetch("./updateHead", {
                method:"POST",
                body: f
            })
            .then(r=>r.json())
            .then(r=>{
                if(r > 0) {
                    alert("완료되었습니다.")
                    location.href="./user"
                }
            }).catch(e => {
                alert("오류발생")
                location.href="./user"
            })
        }else {
            alert("회원과 부서를 선택해주세요.")
        }
    })
})

//유저정보, 부서정보 가져오기
function getUsersAndDepts (users, depts) {
        for(let user of users) {
            const option = document.createElement('option');
            option.value = user.username
            option.innerHTML = user.name
            userSelect.append(option)
        }
        for(let dept of depts) {
            const option = document.createElement('option');
            option.value = dept.departmentId
            option.innerHTML = dept.departmentName
            deptSelect.append(option)
        }
}


//회원의 부서정보 업데이트
function updateDepartment () {
    const f = new FormData();
    f.append("username", userSelect.value)
    f.append("departmentId", deptSelect.value)
    fetch("./updateUser", {
        method:"POST",
        body: f
    })
    .then(r=>r.json())
    .then(r=>{
        if(r > 0) {
            alert("완료되었습니다.")
            location.href="./user"
        }
    }).catch(e => {
        alert("오류발생")
        location.href="./user"
    })
}

//선택한 유저의 부서 자동 선택
function selectDeptByUser (users) {
    let selectedUsername = userSelect.value

    let selectedUser = users.find(user => user.username === selectedUsername)

    if (selectedUser && selectedUser.departmentVO) {
        deptSelected.innerHTML = selectedUser.departmentVO.departmentName;
        deptSelected.value = selectedUser.departmentVO.departmentId;
    } else {
        deptSelected.innerHTML = "부서 없음";
        deptSelected.value = "";
    }
}

//UI초기화
function clearUI() {
    // userSelect: 기본 옵션만 남기고 제거
    while (userSelect.options.length > 1) {
        userSelect.remove(1);
    }

    // deptSelect: 기본 옵션만 남기고 제거
    while (deptSelect.options.length > 1) {
        deptSelect.remove(1);
    }

    // 부서 선택 내용 초기화
    deptSelected.innerHTML = '-- 부서 선택 --';
    deptSelected.value = '';

    // 버튼 영역 비우기
    utilBtn.innerHTML = '';
}

