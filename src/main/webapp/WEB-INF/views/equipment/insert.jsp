<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
	<head>
	<meta charset="UTF-8">
	<title>비품 등록</title>
		<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
		
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
		<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
		<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
        <style>
            /* 비품 등록 폼을 위한 스타일 추가 */
            body { /* 이 부분은 전체 body에 적용되므로, 템플릿의 다른 스타일에 따라 조절이 필요할 수 있습니다. */
                font-family: Arial, sans-serif;
                /* padding: 40px; */ /* 템플릿의 container-fluid px-4와 중복되거나 충돌할 수 있으므로 주석 처리 */
                background-color: #f9f9f9; /* 템플릿의 배경색과 조화롭게 조절 */
            }

            .form-container {
                max-width: 500px;
                margin: auto; /* 좌우 중앙 정렬 */
                background: #fff;
                padding: 30px;
                border: 1px solid #ccc;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05); /* 약간의 그림자 추가로 입체감 부여 */
            }

            .form-container h2 {
                text-align: center;
                margin-bottom: 25px; /* 제목 아래 여백 증가 */
                color: #333;
            }

            label {
                display: block;
                margin: 15px 0 5px;
                font-weight: bold;
                color: #555;
            }

            input[type="text"], input[type="datetime-local"], select, textarea {
                width: 100%;
                padding: 10px;
                box-sizing: border-box;
                border: 1px solid #ddd; /* 테두리 색상 조정 */
                border-radius: 4px; /* 테두리 둥글게 */
                margin-bottom: 10px; /* 각 입력 필드 아래 여백 추가 */
            }

            input[type="text"]:focus, select:focus, textarea:focus {
                border-color: #007bff; /* 포커스 시 테두리 색상 변경 */
                outline: none; /* 기본 아웃라인 제거 */
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25); /* 포커스 시 그림자 추가 */
            }

            button {
                margin-top: 25px; /* 버튼 위 여백 증가 */
                width: 100%;
                padding: 12px;
                background-color: #007bff;
                color: white;
                font-size: 17px; /* 폰트 크기 약간 키움 */
                border: none;
                border-radius: 5px; /* 버튼 둥글게 */
                cursor: pointer;
                transition: background-color 0.3s ease; /* 호버 효과 부드럽게 */
            }

            button:hover {
                background-color: #0056b3;
            }
        </style>
	</head>
	<body class="sb-nav-fixed d-flex flex-column min-vh-100">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
                    <div class="container" style="margin-top:150px;">
						<div class="container mt-4">
							<div class="form-container">
                                <h2>비품 등록</h2>
                                <form action="${pageContext.request.contextPath}/equipment/insert" method="post">
                                    <label for="name">비품명 *</label> 
                                    <input type="text" id="name" name="name" required> 
                                    
                                    <label for="description">설명</label>
                                    <textarea id="description" name="description" rows="3"></textarea>

                                    <label for="facilityId">시설 선택</label> 
                                    <select id="facilityId" name="facilityId" required>
                                        <option value="">-- 시설 선택 --</option>
                                        <c:forEach items="${facilities}" var="facility">
                                            <option value="${facility.facilityId}">${facility.name}</option>
                                        </c:forEach>
                                    </select> 
                                    
                                    <label for="status">현재 상태 *</label> 
                                    <select id="status" name="status" required>
                                        <option value="정상">정상</option>
                                        <option value="점검중">점검중</option>
                                        <option value="고장">고장</option>
                                    </select>

                                    <button type="submit">등록</button>
                                </form>
                            </div>
						</div>
					</div>
				</main>
				<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
					
	
	
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>