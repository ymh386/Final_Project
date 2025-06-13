const uploadSign = document.getElementById("uploadSign");
const appOrRej = document.getElementById("appOrRej");
const rejection = document.getElementById("rejection");

const documentId = document.getElementById("documentId");
const writerId = document.getElementById("writerId");
const approvalId = document.getElementById("approvalId");

let result = 0;

uploadSign.addEventListener("click", ()=>{

    //버튼 중복 클릭 방지
    if(uploadSign.disabled) return;
    uploadSign.disabled = true; // 버튼 비활성화

    fetch("./getSign")
    .then(r => r.json()).catch(e => {
        alert("서명 또는 도장을 등록해주세요.")
        location.href="./registerSign"
    })
    .then(r => {
        let sign1 = document.getElementById("sign_1");
        let sign2 = document.getElementById("sign_2");
        let sign3 = document.getElementById("sign_3");
        let signatureUrl = "/files/userSignature/" + r.fileName

        const signImg = makeSign(signatureUrl);

        if(r != null) {
            if(!sign1.querySelector("img")) {
                sign1.append(signImg);
                result = 1
            }else if(!sign2.querySelector("img")){
                sign2.append(signImg);
                result = 1
            }else if(!sign3.querySelector("img")){
                sign3.append(signImg);
                result = 1
            }
        }else {
            alert("서명 또는 도장을 등록해주세요.")
            location.href="./registerSign"
        }

        if(result > 0) {
            approve = document.createElement("button");
            approve.classList.add("btn");
            approve.setAttribute("id", "approve");
            approve.innerHTML = "승인";
            appOrRej.append(approve);
            rejection.remove();

            approve.addEventListener('click', ()=>{
                //현재 approvalId의 진행상태를 'AS1'로 변경 후 
                //approvalId를 parent로 하는 데이터의 진행상태를 'AS0'
                //승인 완료 시 해당 문서 html 결재란에 서명렌더링
                //모든 해당 documentId를 갖는 approval의 진행상태가 'AS1'이된 경우 해당document의 진행상태도 'D1'
                if(r != null) {
                    const f = new FormData();
                    f.append("approvalId", approvalId.value)
                    f.append("documentId", documentId.value)
                    f.append("contentHtml", document.getElementById("contentHtml").innerHTML)
                    //승인인지 반려인지 구분용(1 이면 승인)
                    f.append("type", 1)


                    fetch("./appOrRej", {
                        method : "POST",
                        body : f
                    })
                    .then(r2 => r2.json())
                    .then(r2 => {

                        if(r != null && r2 > 0){
                            alert("승인완료")
                            location.href="./list"
                        } else{
                            alert("승인실패")
                            location.reload();
                        }
                    }).catch(e => {
                        console.log(e)
                        alert("오류발생")
                    })
                }else {
                    alert("서명/도장을 기입해주세요")
                }
            })
        }  
    })
})

rejection.addEventListener('click', ()=>{
    //현재 approvalId의 진행상태를 'AS2'로 변경 후 
    //approver에 하나라도 상태가 'AS2'이면 document의 상태를 'D2'로 변경
    const f = new FormData();
    f.append("documentId", documentId.value)
    f.append("approvalId", approvalId.value)
    //승인인지 반려인지 구분(0 이면 반려)
    f.append("type", 0)

    fetch('./appOrRej', {
        method : "POST",
        body : f
    })
    .then(r => r.json())
    .then(r=>{

        if(r > 0) {
            alert("반려완료")
            location.href="./list"
        }else {
            alert("반려실패")
            location.reload()
        }
    }).catch(e => {
        alert("오류발생")
    })

})




//서명 또는 도장 이미지태그 만들기
function makeSign(signatureUrl) {
    const signImg = document.createElement("img");
    signImg.setAttribute("src", signatureUrl);
    signImg.setAttribute("width", "50");
    signImg.setAttribute("height", "50");

    return signImg;
}
