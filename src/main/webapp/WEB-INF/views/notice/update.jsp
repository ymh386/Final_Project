<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>공지사항 수정</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f9f9f9; margin: 20px; }
    .container { max-width: 600px; margin: auto; background: #fff; padding: 20px; border-radius: 6px; box-shadow: 0 0 8px rgba(0,0,0,0.1); }
    h1 { margin-bottom: 24px; }
    label { display: block; margin-bottom: 6px; font-weight: bold; }
    input[type="text"], textarea {
      width: 100%;
      padding: 10px;
      margin-bottom: 16px;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 1rem;
      box-sizing: border-box;
      resize: vertical;
    }
    button {
      padding: 10px 24px;
      background-color: #3498db;
      border: none;
      color: white;
      font-size: 1rem;
      border-radius: 4px;
      cursor: pointer;
      font-weight: bold;
      transition: background-color 0.2s ease;
    }
    button:hover {
      background-color: #2980b9;
    }
    .btn-cancel {
      background-color: #aaa;
      margin-left: 12px;
    }
    .btn-cancel:hover {
      background-color: #888;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>공지사항 수정</h1>
    <form action="${pageContext.request.contextPath}/notice/update" method="post">
      <input type="hidden" name="boardNum" value="${detail.boardNum}" />
      
      <label for="boardTitle">제목</label>
      <input type="text" id="boardTitle" name="boardTitle" required maxlength="100" value="${detail.boardTitle}" />
      
      <label for="boardContents">내용</label>
      <textarea id="boardContents" name="boardContents" rows="10" required>${detail.boardContents}</textarea>
      
      <button type="submit">수정</button>
      <a href="${pageContext.request.contextPath}/notice/list" class="btn-cancel" style="text-decoration:none; padding:10px 24px; display:inline-block; border-radius:4px; color:#fff;">취소</a>
    </form>
  </div>
</body>
</html>
