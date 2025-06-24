<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비품 등록</title>
<style>
body {
	font-family: Arial, sans-serif;
	padding: 40px;
	background-color: #f9f9f9;
}

.form-container {
	max-width: 500px;
	margin: auto;
	background: #fff;
	padding: 30px;
	border: 1px solid #ccc;
	border-radius: 8px;
}

.form-container h2 {
	text-align: center;
	margin-bottom: 20px;
}

label {
	display: block;
	margin: 15px 0 5px;
	font-weight: bold;
}

input[type="text"], input[type="datetime-local"], select, textarea {
	width: 100%;
	padding: 10px;
	box-sizing: border-box;
}

button {
	margin-top: 20px;
	width: 100%;
	padding: 12px;
	background-color: #007bff;
	color: white;
	font-size: 16px;
	border: none;
	cursor: pointer;
}

button:hover {
	background-color: #0056b3;
}
</style>
</head>
<body>
	<div class="form-container">
		<h2>비품 등록</h2>
		<form action="${pageContext.request.contextPath}/equipment/insert"
			method="post">
			<label for="name">비품명 *</label> <input type="text" id="name"
				name="name" required> <label for="description">설명</label>
			<textarea id="description" name="description" rows="3"></textarea>

			<label for="facilityId">시설 선택</label> <select id="facilityId"
				name="facilityId" required>
				<option value="">-- 시설 선택 --</option>
				<c:forEach items="${facilities}" var="facility">
					<option value="${facility.facilityId}">${facility.name}</option>
				</c:forEach>
			</select> <label for="status">현재 상태 *</label> <select id="status"
				name="status" required>
				<option value="정상">정상</option>
				<option value="점검중">점검중</option>
				<option value="고장">고장</option>
			</select>

			<button type="submit">등록</button>
		</form>
	</div>
	
	<form action="${pageContext.request.contextPath}/equipment/main" method="get">
    <button type="submit" style="background-color: gray; margin-top: 10px;">메인으로 돌아가기</button>
</form>
	
	
	
</body>
</html>
