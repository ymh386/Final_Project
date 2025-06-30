const sign = document.getElementById("sign");
const stamp = document.getElementById("stamp");
const signPad = document.getElementById("signPad");
const signatureForm = document.getElementById("signatureForm");
const imageData = document.getElementById("imageData");
const stampForm = document.getElementById("stampForm");


sign.addEventListener('click', () => {
    // 화면 초기화
    stampForm.innerHTML = '';
    signPad.innerHTML = '';

    // 부모 div: 중앙 정렬용
    const wrapper = document.createElement('div');
    wrapper.className = 'd-flex flex-column align-items-center';

    // Canvas 생성
    const canvas = document.createElement('canvas');
    canvas.setAttribute('id', 'signature-pad');
    canvas.setAttribute('width', '700'); // 가로 너비 넓힘
    canvas.setAttribute('height', '200');
    canvas.classList.add('border', 'rounded', 'mb-3', 'shadow-sm');

    // 버튼 그룹 생성
    const buttonGroup = document.createElement('div');
    buttonGroup.className = 'd-flex gap-2 justify-content-center';

    // 지우기 버튼
    const clearSign = document.createElement('button');
    clearSign.type = 'button';
    clearSign.className = 'btn btn-outline-secondary';
    clearSign.innerHTML = '<i class="bi bi-eraser-fill me-1"></i>지우기';

    // 저장 버튼
    const saveSign = document.createElement('button');
    saveSign.type = 'button';
    saveSign.className = 'btn btn-primary';
    saveSign.innerHTML = '<i class="bi bi-save-fill me-1"></i>저장';

    // 삽입
    wrapper.appendChild(canvas);
    buttonGroup.appendChild(clearSign);
    buttonGroup.appendChild(saveSign);
    wrapper.appendChild(buttonGroup);
    signPad.appendChild(wrapper);

    // 서명패드 초기화
    const signaturePad = new SignaturePad(canvas);

    // 이벤트 바인딩
    clearSign.addEventListener('click', () => signaturePad.clear());
    saveSign.addEventListener('click', () => {
        if (signaturePad.isEmpty()) {
            alert("서명을 입력해주세요.");
            return;
        }
        const dataURL = signaturePad.toDataURL("image/png");
        imageData.value = dataURL;
        signatureForm.submit();
    });
});


//도장 클릭 시
stamp.addEventListener('click', () => {
    // 화면 초기화
    stampForm.innerHTML = '';
    signPad.innerHTML = '';

    // 컨테이너 div
    const wrapper = document.createElement('div');
    wrapper.className = 'd-flex flex-column align-items-center gap-3';

    // 파일 업로드 input
    const stampFile = document.createElement('input');
    stampFile.setAttribute('type', 'file');
    stampFile.setAttribute('name', 'stampFile');
    stampFile.setAttribute('accept', 'image/*');
    stampFile.className = 'form-control w-50';

    // 업로드 버튼
    const uploadStamp = document.createElement('button');
    uploadStamp.setAttribute('type', 'submit');
    uploadStamp.className = 'btn btn-primary';
    uploadStamp.innerHTML = '<i class="bi bi-upload me-1"></i>도장 업로드';

    // 삽입
    wrapper.appendChild(stampFile);
    wrapper.appendChild(uploadStamp);
    stampForm.appendChild(wrapper);
});




