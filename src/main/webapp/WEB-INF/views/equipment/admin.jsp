<%@ page language="java" contentType="text/html; charset=UTF-8"
       pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지 – 비품 고장 신고 관리</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1, h2 { margin-bottom: 0.5em; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 1.5em; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f5f5f5; }
        .no-data { padding: 20px; color: #666; }
        .btn { padding: 4px 10px; margin-right: 4px; cursor: pointer; }
        .btn-process { background: #4CAF50; color: white; border: none; }
        .btn-complete { background: #2196F3; color: white; border: none; }
    </style>
</head>
<body>

<h1>관리자 페이지 – 비품 고장 신고 관리</h1>

<c:if test="${not empty message}">
    <div style="margin-bottom:1em; color: green;">${message}</div>
</c:if>

<h2>미처리 신고 현황</h2>
<c:choose>
    <c:when test="${empty pendingReports}">
        <div class="no-data">처리 대기 중인 신고가 없습니다.</div>
    </c:when>
    <c:otherwise>
        <table>
            <thead>
                <tr>
                    <th>신고번호</th>
                    <th>비품명</th>
                    <th>신고자</th>
                    <th>신고일시</th>
                    <th>고장내용</th>
                    <th>상태</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${pendingReports}" var="report">
                    <tr>
                        <td>#${report.reportId}</td>
                        <td>${report.equipmentName}</td>
                        <td>${report.username}</td>
                        <td>${report.reportDateStr}</td>
                        <td>
                            <c:choose>
                                <c:when test="${empty report.description}">–</c:when>
                                <c:otherwise>${report.description}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${report.faultStatus}</td>
                        <td>
                            <button class="btn btn-process"
                                    onclick="updateStatus(${report.reportId}, '처리중')">
                                처리중
                            </button>
                            <button class="btn btn-complete"
                                    onclick="resolveReport(${report.reportId}, ${report.equipmentId})">
                                완료
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:otherwise>
</c:choose>

<h2>전체 신고 내역</h2>
<c:choose>
    <c:when test="${empty allReports}">
        <div class="no-data">신고 내역이 없습니다.</div>
    </c:when>
    <c:otherwise>
        <table>
            <thead>
                <tr>
                    <th>신고번호</th>
                    <th>비품명</th>
                    <th>신고자</th>
                    <th>신고일시</th>
                    <th>상태</th>
                    <th>처리일시</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${allReports}" var="report">
                    <tr>
                        <td>#${report.reportId}</td>
                        <td>${report.equipmentName}</td>
                        <td>${report.username}</td>
                        <td>${report.reportDateStr}</td>
                        <td>${report.faultStatus}</td>
                        <td>${report.resolvedAtStr}</td>
                        <td>
                            <c:choose>
                                <c:when test="${report.faultStatus != '처리완료'}">
                                    <button class="btn btn-process"
                                            onclick="updateStatus(${report.reportId}, '처리중')">
                                        처리중
                                    </button>
                                    <button class="btn btn-complete"
                                            onclick="resolveReport(${report.reportId}, ${report.equipmentId})">
                                        완료
                                    </button>
                                </c:when>
                                <c:otherwise>완료됨</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:otherwise>
</c:choose>

<form id="statusUpdateForm" action="/equipment/updateStatus" method="post" style="display:none;">
    <input type="hidden" name="reportId" id="statusReportId"/>
    <input type="hidden" name="faultStatus" id="statusValue"/>
</form>
<form id="resolveForm" action="/equipment/resolve" method="post" style="display:none;">
    <input type="hidden" name="reportId" id="resolveReportId"/>
    <input type="hidden" name="equipmentId" id="resolveEquipmentId"/>
</form>

<script>
function updateStatus(reportId, status) {
    if (confirm('신고 상태를 "' + status + '"로 변경하시겠습니까?')) {
        document.getElementById('statusReportId').value = reportId;
        document.getElementById('statusValue').value = status;
        document.getElementById('statusUpdateForm').submit();
    }
}
function resolveReport(reportId, equipmentId) {
    if (confirm('이 신고를 처리 완료하시겠습니까?')) {
        document.getElementById('resolveReportId').value = reportId;
        document.getElementById('resolveEquipmentId').value = equipmentId;
        document.getElementById('resolveForm').submit();
    }
}
</script>

</body>
</html>
