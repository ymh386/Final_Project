CKEDITOR.replace('editor');
const formSelect = document.getElementById("formSelect");
const content = document.getElementById("content");


formSelect.addEventListener("change", ()=>{
    console.log(formSelect.value)
    fetch(`./getForm?categoryId=${formSelect.value}`)
    .then(r=>r.json())
    .then(r => {
        console.log(r);
        CKEDITOR.instances['editor'].setData(r.contentHtml);
        
    })
})