CKEDITOR.replace('editor', {
    // toolbar: [],               // 툴바 제거
    removePlugins: 'elementspath', // 하단 요소 경로 제거
    resize_enabled: false,         // 크기 조절 막기
    height: 1000,
    allowedContent: true
  });
const formSelect = document.getElementById("formSelect");
const content = document.getElementById("content");
const documentForm = document.getElementById("documentForm");
const addLine = document.getElementById("addToApprovalLine");

//등록된 결재자 수 나타내기위함
let count = 0;

//폼 양식을 바꾸면 그 양식으로 새로 렌더링
formSelect.addEventListener("change", ()=>{
    fetch(`./getForm?formId=${formSelect.value}`)
    .then(r=>r.json())
    .then(r => {
        CKEDITOR.instances['editor'].setData(r.contentHtml);
        //결재자를 미리 등록해놨을 경우 결재란 렌더링시키기
        renderApprovalList();
    }).catch(e=>{
        console.log(e)
    })

    
})

// 서버에서 가져온 조직도 -> user와 department조인 -> fetch로 조인후 데이터 넣기
document.addEventListener('DOMContentLoaded', () => {
    fetch('/approval/getLine')
        .then(r => r.json())
        .then(data => {
            //id가 line인 div태그에 트리형식 리스트 뿌리기
            $('#line').jstree({
                core: {
                    data: data //어떤 데이터를
                },
                plugins: ['checkbox'] //체크박스 형식으로
            });
        });
});

const approvalLine = []; //JSON형식(서버로보낼) 객체들 저장

//폼 submit시 이벤트 처리
documentForm.addEventListener('submit', ()=>{
    //name속성은 서버로 갈 시 불필요하기 때문에 제거
    approvalLine.forEach(user=>{
        delete user.name;
    })
    //결재라인의 JSON데이터를 문자열로 바꾸고 서버러 보냄
    document.getElementById("approvalLineJson").value = JSON.stringify(approvalLine);
})



//직렬방식용(jsp에 체크박스 만들어서 병렬방식도 고려(DB에 type컬럼도 추가))
//클릭 시 조직도에서 체크된사람들 결재라인에 등록
addLine.addEventListener("click", ()=>{
  const selected = $('#line').jstree(true).get_checked(true); //트리에서 체크된것들

    //결재자 추가 시 현재 결재자수 + 선택 결재자수
    count = approvalLine.length + selected.length * 1;

    let step = 1 //approvalStep에 넣을 값 

  //결재자수는 3개까지 가능
  if(count <= 3){
      //체크된 것들 중 하나 꺼내기
      selected.forEach(s => {
        if (s.data && s.data.username) { //data에 값이 있고, data.username값이 있냐?
            const username = s.data.username;
            const name = s.data.name;
    
            //결재자 추가
            addApprover(username, name, step);
    
            // step = step+1; //병렬결재용
    
            //추가된 결재자 렌더링
            renderApprovalList();
        }
      });
  }else {
    alert("최대 3명까지 가능합니다.")
  }

  console.log(approvalLine);
});

//결재라인에 해당 결재자 추가
function addApprover(username, name, step) {
    //중복 방지
    if (approvalLine.find(u => u.approverId === username)) return;
    
    approvalLine.push({
        approverId: username,
        name: name,
        approvalStep: step //결재순서
        // type: 'sequential' //나중에 병렬구조도 만들 때 사용
    });
}

//결재라인에서 해당 결재자 제거
function removeApprover(username) {
    //파라미터로 받은 username과 approvalLine의 approverId와 일치하는 인덱스 번호를 찾음
    const index = approvalLine.findIndex(u => u.approverId === username);
    if (index > -1) {
        //해당 인덱스번호로부터 1개의 객체 제거
        approvalLine.splice(index, 1);
        //제거 후 count를 현재 길이로
        count = approvalLine.length;
    }

    //결재란의 이름 제거
    const editorDocument = CKEDITOR.instances.editor.document;
    approver = editorDocument.getById('name_' + (approvalLine.length+1).toString())
    if (approver){
        approver.setText('');
    }

    //제거된 후 결재라인 재 렌더링
    renderApprovalList();
}

//위로 한칸 이동(앞순으로 이동)
function moveUp(index) {
    //맨 위면 그대로 return
    if (index <= 0) return;
    [approvalLine[index - 1], approvalLine[index]] = [approvalLine[index], approvalLine[index - 1]];
    renderApprovalList();
}

//아래로 한칸 이동(뒷순으로 이동)
function moveDown(index) {
    //맨 아래면 그대로 return
    if (index >= approvalLine.length - 1) return;
    [approvalLine[index + 1], approvalLine[index]] = [approvalLine[index], approvalLine[index + 1]];
    renderApprovalList();
}

//결재라인에 한 명 추가 시 렌더링
function renderApprovalList() {
    const ul = document.getElementById('selectedApprovers');
    ul.innerHTML = '';

    //에디터 내 결재란 위치에 이름 반영
    const editorDocument = CKEDITOR.instances.editor.document;

    //렌더링 될 때 마다 결재란 초기화
    approvalLine.forEach((idx)=>{
        approver = editorDocument.getById('name_' + (idx+1).toString())
        if (approver){
            approver.setText('');
        }
    })
    
    //렌더링시 현재 적용된 결재자만큼 결재란 기입
    approvalLine.forEach((user, idx) => {
        approver = editorDocument.getById('name_' + (idx+1).toString())
        console.log(approver)
        if (approver){
            approver.setText(user.name);
        }
    })

    approvalLine.forEach((user, idx) => {
        //리스트 만들고
        const li = document.createElement('li');
        li.dataset.username = user.approverId;
        li.textContent = `${user.name}`;
        //앞순번 이동버튼
        const btnUp = document.createElement('button');
        btnUp.textContent = '▲';
        btnUp.addEventListener('click', ()=>moveUp(idx));
        //뒷순번 이동버튼
        const btnDown = document.createElement('button');
        btnDown.textContent = '▼';
        btnDown.addEventListener('click', ()=>moveDown(idx));
        //삭제 버튼
        const btnRemove = document.createElement('button');
        btnRemove.textContent = '🗑️';
        btnRemove.addEventListener('click', ()=>removeApprover(user.approverId));
        //만든 버튼들 추가
        li.appendChild(btnUp);
        li.appendChild(btnDown);
        li.appendChild(btnRemove);
        //만든 리스트 추가
        ul.appendChild(li);
    })
}
