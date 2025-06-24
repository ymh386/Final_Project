<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비품 고장 신고 시스템</title>
<style>
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {
	font-family: 'Helvetica Neue', Arial, sans-serif;
	background: #f5f7fa;
	color: #333;
	margin: 20px;
}

h2, h1 {
	margin-bottom: 20px;
	color: #2c3e50;
	font-size: 2rem;
}

table {
	border-collapse: collapse;
	width: 100%;
	background: #fff;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
	margin-bottom: 30px;
}

th, td {
	border: 1px solid #e0e6ed;
	padding: 12px 8px;
	text-align: center;
}

th {
	background: #34495e;
	color: #fff;
	font-weight: 500;
	font-size: 0.9rem;
}

td {
	font-size: 0.85rem;
	color: #2c3e50;
}

.msg {
	color: #27ae60;
	margin-bottom: 15px;
	padding: 10px;
	background: #d4edda;
	border: 1px solid #c3e6cb;
	border-radius: 4px;
}

a.button {
	margin-top: 15px;
	margin-right: 10px;
	display: inline-block;
	padding: 10px 20px;
	background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
	color: #fff;
	text-decoration: none;
	border-radius: 6px;
	font-size: 0.95rem;
	font-weight: 500;
	transition: all 0.2s ease;
	box-shadow: 0 4px 8px rgba(37, 117, 252, 0.3);
}

a.button:hover {
	background: linear-gradient(135deg, #5a09b8 0%, #1f65e0 100%);
	box-shadow: 0 6px 12px rgba(31, 101, 224, 0.4);
	transform: translateY(-2px);
}

form textarea, form select {
	width: 100%;
	padding: 8px;
	border: 1px solid #ccc;
	border-radius: 4px;
}

form button {
	margin-top: 10px;
	padding: 10px 20px;
	background: #27ae60;
	color: #fff;
	border: none;
	border-radius: 4px;
	font-size: 0.9rem;
	cursor: pointer;
}

form button:hover {
	background: #219150;
}

.pagination {
	text-align: center;
	margin-top: 36px;
}

.pagination a, .pagination strong {
	display: inline-block;
	margin: 0 6px;
	padding: 10px 14px;
	border-radius: 4px;
	font-size: 0.9rem;
	transition: background 0.2s ease;
}

.pagination a {
	color: #3498db;
	text-decoration: none;
}

.pagination a:hover {
	background: #ecf6fc;
}

.pagination strong {
	background: #3498db;
	color: #fff;
}

.page-info {
	text-align: center;
	margin-top: 10px;
	color: #7f8c8d;
	font-size: 0.9rem;
}
</style>
</head>
<body>
	<h1>비품 고장 신고 시스템</h1>

	<c:if test="${not empty message}">
		<div class="msg">${message}</div>
	</c:if>

	<sec:authorize access="isAuthenticated()">
		<h2>고장 신고 작성</h2>
		<form action="/equipment/report" method="post">
			<table>
				<tr>
					<th>시설 선택</th>
					<td><select id="facilitySelect">
							<option value="">-- 시설 선택 --</option>
							<c:forEach items="${facilityList}" var="facility">
								<option value="${facility.facilityId}">${facility.name}</option>
							</c:forEach>
					</select></td>
				</tr>

				<tr>
					<th>비품 선택</th>
					<td><select name="equipmentId" id="equipmentSelect" required>
							<option value="">-- 시설을 먼저 선택하세요 --</option>
					</select></td>
				</tr>

				<tr>
					<th>트레이너</th>
					<td><sec:authentication property="name" /><input type="hidden"
						name="username" value="<sec:authentication property='name'/>" /></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea name="description" rows="4"></textarea></td>
				</tr>
				<tr>
					<td colspan="2"><button type="submit">신고 접수</button></td>
				</tr>
			</table>
		</form>
	</sec:authorize>

	<sec:authorize access="!isAuthenticated()">
		<p>
			로그인이 필요합니다. <a href="/login">로그인</a>
		</p>
	</sec:authorize>

	<h2>신고 내역</h2>
	<c:choose>
		<c:when test="${empty faultReports}">
			<p>신고 내역이 없습니다.</p>
		</c:when>
		<c:otherwise>
			<table>
				<tr>
					<th>신고번호</th>
					<th>비품명</th>
					<th>신고일시</th>
					<th>상태</th>
					<th>처리일시</th>
				</tr>
				<c:forEach items="${faultReports}" var="report">
					<tr>
						<td>#${report.reportId}</td>
						<td>${report.equipmentName}</td>
						<td>${report.reportDateStr}</td>
						<td>${report.faultStatus}</td>
						<td>${report.resolvedAtStr}</td>
					</tr>
				</c:forEach>
			</table>

			<c:if test="${pager.totalPage > 1}">
				<div class="pagination">
					<c:if test="${pager.prev}">
						<a href="?page=${pager.startPage - 1}">&laquo; 이전</a>
					</c:if>

					<c:forEach var="i" begin="${pager.startPage}"
						end="${pager.lastPage}">
						<c:choose>
							<c:when test="${i == pager.curPage}">
								<strong>${i}</strong>
							</c:when>
							<c:otherwise>
								<a href="?page=${i}">${i}</a>
							</c:otherwise>
						</c:choose>
					</c:forEach>

					<c:if test="${pager.next}">
						<a href="?page=${pager.lastPage + 1}">다음 &raquo;</a>
					</c:if>
				</div>

				<div class="page-info">총 ${pager.totalCount}건 중
					${pager.curPage}/${pager.totalPage} 페이지</div>
			</c:if>
		</c:otherwise>
	</c:choose>
	
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(function() {
    $('#facilitySelect').change(function() {
      const facilityId = $(this).val();
      const $equipmentSelect = $('#equipmentSelect');
      $equipmentSelect.empty();

      if (!facilityId) {
        $equipmentSelect.append('<option value="">-- 시설을 먼저 선택하세요 --</option>');
        return;
      }

      $.ajax({
        url: '${pageContext.request.contextPath}/equipment/by-facility/' + facilityId,
        method: 'GET',
        dataType: 'json',
        success: function(data) {
          let options = '<option value="">-- 비품 선택 --</option>';
          data.forEach(function(item) {
        	    options += '<option value="' + item.equipmentId + '">' + item.name + '</option>';
          });
          $equipmentSelect.html(options);
        },
        error: function() {
          alert('비품 목록을 불러오지 못했습니다.');
        }
      });
    });
  });
</script>
	
</body>
</html>
