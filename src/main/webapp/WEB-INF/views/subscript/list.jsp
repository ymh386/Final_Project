<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
	<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	  <!-- 1) Toss JS SDK 로드 -->
  <sec:authentication property="principal" var="user"/>
  <script src="https://js.tosspayments.com/v1"></script>
    <script>
    // 2) 서버에서 전달한 client key 를 받아 초기화
    const tossPayments = TossPayments('${tossClientKey}');
    
    const origin = window.location.origin;
    
    const context = '${pageContext.request.contextPath}'
    
    // 3) 버튼 클릭 시 팝업 열기
    function openBillingPopup(subscriptionId) {
      tossPayments.requestBillingAuth('카드', {
        customerKey: '${user.username}',  // 로그인한 유저 ID
        successUrl:  origin + context + '/subscript/success?subscriptionId='+subscriptionId,
        failUrl:     origin + context + '/subscript/failure'
      });
    }
  </script>
		<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
		
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
		<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
		<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
	</head>
	<body class="sb-nav-fixed d-flex flex-column min-vh-100">
		<style>
					/* 메인 콘텐츠 영역 스타일 - 탑바, 사이드바 공간 확보 */
		#layoutSidenav_content {
			margin-left: 240px; /* 사이드바 너비 */
			margin-top: 64px;   /* 탑바 높이 */
			padding: 1rem;
			min-height: calc(100vh - 64px);
			box-sizing: border-box;
			background: #fff;
		}
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h2 {
            margin-bottom: 20px;
        }
        #buttons {
            margin-bottom: 20px;
        }
        #buttons button {
            padding: 10px 20px;
            margin-right: 10px;
            font-size: 16px;
            cursor: pointer;
        }
        #subList {
            width: 100%;
            border-collapse: collapse;
        }
        #subList th, #subList td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }
        #subList th {
            background-color: #f4f4f4;
        }
        .disabled {
            background-color: #ddd;
            color: #666;
            cursor: not-allowed;
        }	
		</style>
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
                    <div class="container">
						<div class="container mt-4">
							<!-- contents -->
							   <h2>구독 상품</h2>
								<table border="1" cellpadding="8" id="subList">
									<tr><th>상품명</th><th>기간(일)</th><th>가격</th><th>설명</th><th>구독</th></tr>
									<c:forEach var="sub" items="${plans}">
									<tr>
										<td>${sub.subscriptionName}</td>
										<td>${sub.days}</td>
										<td>${sub.price}원</td>
										<td>${sub.subscriptionContents}</td>
										<td>
										<button type="button" class="btn btn-primary"
												onclick="openBillingPopup(${sub.subscriptionId})">
											구독하기
										</button>
										</td>
									</tr>
									</c:forEach>
								</table>
						




						</div>
					
					</div>
				</main>
				<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
					
	
	
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>