<%@ page language="java" contentType="text/html; charset=UTF-8"
       pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비품 고장 신고 시스템</title>
    <style>
        table { border-collapse: collapse; width: 100%; margin-bottom: 1em; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background: #f0f0f0; }
        .form-table th { width: 120px; background: none; border: none; text-align: right; padding-right: 10px; }
        .form-table td { border: none; padding: 4px 8px; }
        .message { color: green; margin-bottom: 1em; }
    </style>
</head>
<body>
    <h1>비품 고장 신고 시스템</h1>

    <c:if test="${not empty message}">
        <div class="message">${message}</div>
    </c:if>

    <sec:authorize access="isAuthenticated()">
        <h2>비품 고장 신고</h2>
        <form action="/equipment/report" method="post">
            <table class="form-table">
                <tr>
                    <th>비품 선택</th>
                    <td>
                        <select name="equipmentId" required>
                            <option value="">-- 비품 선택 --</option>
                            <c:forEach items="${equipmentList}" var="equipment">
                                <option value="${equipment.equipmentId}">
                                    #${equipment.equipmentId} ${equipment.name}
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>트레이너</th>
                    <td>
                        <sec:authentication property="name"/>
                        <input type="hidden" name="username"
                               value="<sec:authentication property="name"/>"/>
                    </td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td>
                        <textarea name="description" rows="4" cols="50"></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center;">
                        <button type="submit">신고 접수</button>
                    </td>
                </tr>
            </table>
        </form>
    </sec:authorize>
    <sec:authorize access="!isAuthenticated()">
        <p>로그인이 필요합니다. <a href="/login">로그인</a></p>
    </sec:authorize>

    <h2>신고 내역</h2>
    <c:choose>
        <c:when test="${empty faultReports}">
            <p>신고 내역이 없습니다.</p>
        </c:when>
        <c:otherwise>
            <table>
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
                            <td>${report.reportDateStr}</td>
                            <td>${report.faultStatus}</td>
                            <td>${report.resolvedAtStr}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</body>
</html>
