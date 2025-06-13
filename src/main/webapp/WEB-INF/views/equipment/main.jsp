<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비품 고장 신고 시스템</title>
</head>
<body>
    <h1>비품 고장 신고 시스템</h1>

    <c:if test="${not empty message}">
        <div>${message}</div>
    </c:if>

    <!-- 비품 선택 드롭다운 -->
    <h2>비품 고장 신고</h2>
    <form action="/equipment/report" method="post">
        <label>비품 선택:
            <select name="equipmentId" required>
                <option value="">-- 비품 선택 --</option>
                <c:forEach items="${equipmentList}" var="equipment">
                    <option value="${equipment.equipmentId}">
                        #${equipment.equipmentId} ${equipment.name}
                    </option>
                </c:forEach>
            </select>
        </label><br/>
        <label>트레이너명:
            <input type="text" name="username" required />
        </label><br/>
        <label>내용:
            <textarea name="description"></textarea>
        </label><br/>
        <button type="submit">신고 접수</button>
    </form>

    <!-- 신고 내역 -->
    <h2>신고 내역</h2>
    <c:choose>
        <c:when test="${empty faultReports}">
            <p>신고 내역이 없습니다.</p>
        </c:when>
        <c:otherwise>
            <table border="1">
                <thead>
                    <tr>
                        <th>신고번호</th>
                        <th>비품명</th>
                        <th>신고일시</th>
                        <th>상태</th>
                        <th>처리일시</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${faultReports}" var="report">
                        <tr>
                            <td>#${report.reportId}</td>
                            <td>${report.equipmentName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty report.reportDate}">
                                        ${report.reportDate.format(
                                            java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")
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
                                            java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")
                                        )}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</body>
</html>
