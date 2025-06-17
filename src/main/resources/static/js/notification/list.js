const trs = document.getElementsByClassName("trs");

for(const tr of trs) {
    tr.addEventListener('click', ()=>{
        const notificationId = tr.getAttribute("data-id");
        const linkUrl = tr.getAttribute("data-link");
        let f = new FormData();
        f.append("notificationId", notificationId)

        fetch("./read", {
            method: "POST",
            body: f
        })
        .then(r => r.json())
        .then(r => {
            if(r > 0) {
                location.href = linkUrl
            }else {
                alert("읽기 실패")
            }
        })
        
    })
}