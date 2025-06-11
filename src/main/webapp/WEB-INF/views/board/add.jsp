<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>새 게시글 등록</title>
  <style>
    table { width:600px; border-collapse: collapse; margin:20px auto; }
    th, td { padding:8px; border:1px solid #ddd; }
    th { background:#f9f9f9; width:120px; }
    textarea { width:100%; }
    #secretRow { display:none; }
    .actions { text-align:right; margin-top:16px; }
    .actions button, .actions a { margin-left:8px; }
  </style>
</head>
<body>
  <h2 style="text-align:center;">새 게시글 등록</h2>

  <form action="<c:url value='/board/add'/>"
        method="post" enctype="multipart/form-data"
        style="max-width:600px; margin:0 auto;">

    <table>
      <tr>
        <th>제목</th>
        <td><input type="text" name="boardTitle" required /></td>
      </tr>
      <tr>
        <th>카테고리</th>
        <td>
          <select name="category" id="categorySelect">
            <option value="1">일반게시판</option>
            <option value="2">Q&amp;A</option>
          </select>
        </td>
      </tr>
      <tr>
        <th>내용</th>
        <td><textarea name="boardContents" rows="10" required></textarea></td>
      </tr>
      <tr>
        <th>첨부파일</th>
        <td>
          <input type="file" name="files" multiple />
          <p style="color:#666; margin-top:4px;">최대 5개까지 업로드 가능합니다.</p>
        </td>
      </tr>
      <!-- Q&A 선택 시에만 보이는 비밀글 옵션 -->
      <tr id="secretRow">
        <th>비밀글</th>
        <td>
          <label>
            <input type="checkbox" name="isSecret" value="1" />
            비밀글로 등록
          </label><br/>
          <input type="password" name="secretPassword" placeholder="비밀번호 입력(필수)" />
        </td>
      </tr>
    </table>

    <div class="actions">
      <button type="submit">등록</button>
      <a href="<c:url value='/board/index'/>">취소</a>
    </div>
  </form>

  <script>
    (function(){
      var sel = document.getElementById('categorySelect');
      var secretRow = document.getElementById('secretRow');
      function toggleSecret() {
        secretRow.style.display = (sel.value === '2') ? '' : 'none';
      }
      // 초기 호출
      toggleSecret();
      // 드롭다운 변경 시마다 호출
      sel.addEventListener('change', toggleSecret);
    })();
  </script>
</body>
</html>
