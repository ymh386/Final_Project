<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지 - 비품 고장 신고 관리</title>
</head>
<body>

<h1>관리자 페이지 - 비품 고장 신고 관리</h1>

<c:if test="${not empty message}">
    <div>
        ${message}
    </div>
</c:if>

<h2>미처리 신고 현황</h2>
<c:choose>
    <c:when test="${empty pendingReports}">
        <p>처리 대기 중인 신고가 없습니다.</p>
    </c:when>
    <c:otherwise>
        <table border="1">
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
                        <td>
                            <c:choose>
                                <c:when test="${not empty report.reportDate}">
                                    ${report.reportDate.format(
                                        java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                                    )}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${empty report.description}">
                                상세 내용 없음
                            </c:if>
                            <c:if test="${not empty report.description}">
                                ${report.description}
                            </c:if>
                        </td>
                        <td>${report.faultStatus}</td>
                        <td>
                            <button onclick="updateStatus(${report.reportId}, '처리중')">처리중</button>
                            <button onclick="resolveReport(${report.reportId}, ${report.equipmentId})">완료</button>
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
        <p>신고 내역이 없습니다.</p>
    </c:when>
    <c:otherwise>
        <table border="1">
            <thead>
                <tr>
                    <th>신고번호</th>
                    <th>비품명</th>
                    <th>위치</th>
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
                        <td>${report.equipmentLocation}</td>
                        <td>${report.username}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty report.reportDate}">
                                    ${report.reportDate.format(
                                        java.time.format.DateTimeFormatter.ofPattern("MM-dd HH:mm")
                                    )}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${report.faultStatus}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty report.resolvedAt}">
                                    ${report.resolvedAt.format(
                                        java.time.format.DateTimeFormatter.ofPattern("MM-dd HH:mm")
                                    )}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${report.faultStatus != '처리완료'}">
                                <button onclick="updateStatus(${report.reportId}, '처리중')">처리중</button>
                                <button onclick="resolveReport(${report.reportId}, ${report.equipmentId})">완료</button>
                            </c:if>
                            <c:if test="${report.faultStatus == '처리완료'}">
                                완료됨
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:otherwise>
</c:choose>

<form id="statusUpdateForm" action="/equipment/updateStatus" method="post" style="display:none;">
    <input type="hidden" name="reportId" id="statusReportId" />
    <input type="hidden" name="faultStatus" id="statusValue" />
</form>
<form id="resolveForm" action="/equipment/resolve" method="post" style="display:none;">
    <input type="hidden" name="reportId" id="resolveReportId" />
    <input type="hidden" name="equipmentId" id="resolveEquipmentId" />
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
