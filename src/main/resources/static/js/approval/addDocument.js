CKEDITOR.replace('editor', {
    toolbar: [],               // 툴바 제거
    removePlugins: 'elementspath', // 하단 요소 경로 제거
    resize_enabled: false,         // 크기 조절 막기
    height: 600,
    allowedContent: true
  });
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