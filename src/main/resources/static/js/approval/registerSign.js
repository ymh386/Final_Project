const sign = document.getElementById("sign");
const stamp = document.getElementById("stamp");
const signPad = document.getElementById("signPad");
const signatureForm = document.getElementById("signatureForm");
const imageData = document.getElementById("imageData");
const stampForm = document.getElementById("stampForm");


//서명 클릭 시
sign.addEventListener('click', ()=>{
    //화면 초기화
    stampForm.innerHTML = '';
    signPad.innerHTML = '';

    //canvas생성
    const canvas = document.createElement('canvas');
    canvas.setAttribute('id', 'signature-pad');
    canvas.setAttribute('width', '400');
    canvas.setAttribute('height', '200');
    canvas.style.border = '1px solid #000';

    //클릭시 서명패드 클리어시키는 지우기 버튼 생성
    const clearSign = document.createElement('button');
    clearSign.innerText = '지우기'

    //클릭시 서명패드에 등록된 서명 서버로 보내기
    const saveSign = document.createElement('button');
    saveSign.innerText = '저장'
    signPad.append(canvas)
    signPad.append(clearSign)
    signPad.append(saveSign)

    //지우기버튼 눌렀을 때
    clearSign.addEventListener('click', ()=>{
        clearSingature();
    })
    //저장버튼 눌렀을 때
    saveSign.addEventListener('click', ()=>{
        saveSignature();
    })

    //서명패드 생성
    const signaturePad = new SignaturePad(canvas);

    //서명패드 클리어 함수
    function clearSingature() {
    signaturePad.clear();
    }

    //작성한 서명 서버로보내는 함수
    function saveSignature() {
    if (signaturePad.isEmpty()) {
        alert("서명을 입력해주세요.");
        return;
    }
    //서명패드의 작성된 데이터를 Base64형태로 만들어서 form Element안에 넣기
    const dataURL = signaturePad.toDataURL("image/png");
    imageData.value = dataURL;
    signatureForm.submit();
    }

    
})

//도장 클릭 시
stamp.addEventListener('click', ()=>{
    //화면 초기화
    stampForm.innerHTML = '';
    signPad.innerHTML = '';

    //파일 불러오기
    const stampFile = document.createElement('input');
    stampFile.setAttribute('type', 'file');
    stampFile.setAttribute('name', 'stampFile');
    stampFile.setAttribute('accept', 'image/*');

    //등록한 이미지파일 서버로 보내는 버튼 생성
    const uploadStamp = document.createElement('button');
    uploadStamp.setAttribute('type', 'submit');
    uploadStamp.innerText = '도장 업로드';

    //위에서 만든 거 넣기
    stampForm.append(stampFile)
    stampForm.append(uploadStamp)
})



