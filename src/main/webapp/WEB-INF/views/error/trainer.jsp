<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>구독권 필요</title>
  <style>
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
    }
    .denied-container {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
      text-align: center;
      margin: 0;
    }

    .img-wrapper {
      position: relative;
      display: inline-block;
    }
    .img-wrapper a img {
      display: block;
      width: 350px;      /* 딱 맞춘 크기 */
      height: auto;
      cursor: pointer;
    }
    /* 이미지 안쪽에 들어가는 힌트 */
    .img-wrapper .hint-inside {
      position: absolute;
      bottom: 16px;      /* 이미지 바닥에서 16px 위에 */
      left: 50%;
      transform: translateX(-50%);
      font-size: 1rem;
      color: #4B5563;
      white-space: nowrap;
      pointer-events: none;  /* 클릭이 이미지로 전달되게 */
    }

    .denied-container h2 {
      margin-top: 20px;
      font-size: 1.5rem;
      color: #374151;
    }
    .denied-container p {
      margin: 8px 0 0;
      font-size: 1rem;
      color: #4B5563;
    }
  </style>
</head>
<body>
  <div class="denied-container">
    <div class="img-wrapper">
      <a href="${pageContext.request.contextPath}/">
        <img src="${pageContext.request.contextPath}/img/deniedtrainer.png"/>
      </a>
      <!-- 이미지 내부에 위치한 힌트 -->
      <div class="hint-inside">이미지를 클릭하면 홈으로 이동됩니다</div>
    </div>
  </div>
</body>
</html>
