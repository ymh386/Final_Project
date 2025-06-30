<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
	<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
		<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
		
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
		<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
		<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
	</head>
	<body class="sb-nav-fixed d-flex flex-column min-vh-100">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
                    <div class="container">
						<div class="container mt-4">
							<!-- contents -->

							  <h2>결제 결과</h2>

								<c:choose>
									<c:when test="${payment.paymentStatus == 'DONE'}">
									<p>🎉 결제가 정상 처리되었습니다!</p>
									<ul>
										<li>결제키: ${payment.paymentKey}</li>
										<li>금액: ${payment.amount}원</li>
										<li>결제 수단: ${payment.method}</li>
										<li>승인 일시: ${payment.approvedAt}</li>
										<!-- 구독 정보가 넘어왔다면 -->
										<li>구독 시작: ${payment.startDate}</li>
										<li>구독 만료: ${payment.endDate}</li>
									</ul>
									<a href="<c:url value='/'/>">메인으로 돌아가기</a>
									</c:when>
									<c:otherwise>
									<p>❌ 결제에 실패했습니다.</p>
									<p>사유: ${payment.failReason}</p>
									<a href="<c:url value='/subscript/list'/>">다시 시도하기</a>
									</c:otherwise>
								</c:choose>
						




						</div>
					
					</div>
				</main>
				<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
					
	
	
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>