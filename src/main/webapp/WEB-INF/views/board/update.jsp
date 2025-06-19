<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f7f7fb; margin: 0; }
        .container { max-width: 600px; margin: 60px auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 14px rgba(0,0,0,.09); padding: 40px 32px 32px 32px; }
        h2 { margin-bottom: 22px; color: #20307a; }
        label { display: block; margin-top: 22px; margin-bottom: 8px; font-weight: 500; }
        input[type="text"], textarea {
            width: 100%; padding: 12px; border: 1px solid #d4d4e0; border-radius: 6px;
            font-size: 15px; background: #fafbfe; transition: border 0.2s;
        }
        input[type="text"]:focus, textarea:focus { border: 1.2px solid #2663eb; outline: none; }
        textarea { height: 160px; resize: vertical; }
        .button-row { margin-top: 32px; text-align: right; }
        button, .cancel-btn {
            background: #2663eb; color: #fff; border: none;
            border-radius: 5px; padding: 10px 30px; font-size: 15px;
            margin-left: 8px; cursor: pointer; font-weight: 500; box-shadow: 0 1px 3px rgba(38,99,235,0.07);
            transition: background 0.18s;
        }
        button:hover, .cancel-btn:hover { background: #1d51bc; }
        .cancel-btn { background: #aeb3c1; color: #fff; text-decoration: none; }
        .cancel-btn:hover { background: #7b7f8a; }
        .info { color: #888; font-size: 13px; margin-top: 4px; }
    </style>
</head>
<body>
<div class="container">
    <h2>게시글 수정</h2>
    <form action="${pageContext.request.contextPath}/board/update" method="post" enctype="multipart/form-data">
        <input type="hidden" name="boardNum" value="${board.boardNum}" />
        <label for="boardTitle">제목</label>
        <input type="text" id="boardTitle" name="boardTitle" value="${board.boardTitle}" required />
        
        <label for="boardContents">내용</label>
        <textarea id="boardContents" name="boardContents" required>${board.boardContents}</textarea>
        
        <!-- 파일 첨부(선택) -->
        <label for="files">첨부파일 (선택, 여러 개 가능)</label>
        <input type="file" name="files" id="files" multiple />
        <div class="info">기존 파일은 수정시 유지됩니다.</div>
        
        <!-- 비밀글 체크/패스워드(선택) -->
        <label style="margin-top:18px;">
            <input type="checkbox" name="isSecret" value="true" <c:if test="${board.isSecret}">checked</c:if> />
            비밀글로 설정
        </label>
        <div class="info">비밀글일 경우 비밀번호를 입력하세요.</div>
        <input type="text" name="secretPassword" placeholder="비밀글 비밀번호" value="${board.secretPassword}" style="margin-top:6px;" />
        
        <div class="button-row">
            <button type="submit">수정</button>
            <a href="${pageContext.request.contextPath}/board/detail?boardNum=${board.boardNum}" class="cancel-btn">취소</a>
        </div>
    </form>
</div>
</body>
</html>
