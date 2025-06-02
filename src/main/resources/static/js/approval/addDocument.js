
const formSelect = document.getElementById("formSelect");
const content = document.getElementById("content");

formSelect.addEventListener("change", ()=>{
    console.log(formSelect.value)
    fetch(`./getForm?categoryId=${formSelect.value}`)
    .then(r=>r.json())
    .then(r => {
        content.innerHTML = r.contentHtml
    })
})