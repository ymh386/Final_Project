const sign = document.getElementById("sign");
const stamp = document.getElementById("stamp");
const signPad = document.getElementById("signPad");
const signatureForm = document.getElementById("signatureForm");
const imageData = document.getElementById("imageData");
const stampForm = document.getElementById("stampForm");



sign.addEventListener('click', ()=>{
    stampForm.innerHTML = '';
    signPad.innerHTML = '';
    const canvas = document.createElement('canvas');
    canvas.setAttribute('id', 'signature-pad');
    canvas.setAttribute('width', '400');
    canvas.setAttribute('height', '200');
    canvas.style.border = '1px solid #000';
    const clearSign = document.createElement('button');
    clearSign.innerText = '지우기'
    const saveSign = document.createElement('button');
    saveSign.innerText = '저장'
    signPad.append(canvas)
    signPad.append(clearSign)
    signPad.append(saveSign)

    clearSign.addEventListener('click', ()=>{
        clearSingature();
    })
    saveSign.addEventListener('click', ()=>{
        saveSignature();
    })

    const signaturePad = new SignaturePad(canvas);

    function clearSingature() {
    signaturePad.clear();
    }

    function saveSignature() {
    if (signaturePad.isEmpty()) {
        alert("서명을 입력해주세요.");
        return;
    }
    const dataURL = signaturePad.toDataURL("image/png");
    imageData.value = dataURL;
    signatureForm.submit();
    }

    
})

stamp.addEventListener('click', ()=>{
    stampForm.innerHTML = '';
    signPad.innerHTML = '';
    const stampFile = document.createElement('input');
    stampFile.setAttribute('type', 'file');
    stampFile.setAttribute('name', 'stampFile');
    stampFile.setAttribute('accept', 'image/*');
    // stampFile.setAttribute(required);
    const uploadStamp = document.createElement('button');
    uploadStamp.setAttribute('type', 'submit');
    uploadStamp.innerText = '도장 업로드';
    stampForm.append(stampFile)
    stampForm.append(uploadStamp)
})



