<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비품 목록 관리</title>
    <style>
      table { border-collapse: collapse; width: 100%; }
      th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
      th { background: #f0f0f0; }
    </style>
</head>
<body>
    <h1>비품 목록 관리</h1>

    <c:if test="${not empty message}">
        <div style="color: green;">${message}</div>
    </c:if>

    <!-- 검색 폼을 테이블 형식으로 배치 -->
    <h2>검색</h2>
    <form action="/equipment/list" method="get">
      <table>
        <tr>
          <th>비품명</th>
          <td><input type="text" name="search" value="${param.search}" /></td>
          <th>상태</th>
          <td>
            <select name="status">
              <option value="">전체</option>
              <option value="정상"   ${param.status=='정상'   ?'selected':''}>정상</option>
              <option value="점검중" ${param.status=='점검중' ?'selected':''}>점검중</option>
              <option value="고장"   ${param.status=='고장'   ?'selected':''}>고장</option>
            </select>
          </td>
          <th>위치</th>
          <td>
            <select name="location">
              <option value="">전체</option>
              <c:forEach items="${locations}" var="loc">
                <option value="${loc}" ${param.location==loc?'selected':''}>${loc}</option>
              </c:forEach>
            </select>
          </td>
          <td><button type="submit">검색</button></td>
        </tr>
      </table>
    </form>

    <!-- 검색 결과 테이블 -->
    <h2>비품 목록</h2>
    <c:choose>
      <c:when test="${empty equipmentList}">
        <p>등록된 비품이 없습니다.</p>
      </c:when>
      <c:otherwise>
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>이름</th>
              <th>위치</th>
              <th>상태</th>
              <th>설명</th>
              <th>최종점검</th>
              <th>등록일</th>
              <th>관리</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${equipmentList}" var="equipment">
              <tr>
                <td>${equipment.equipmentId}</td>
                <td>${equipment.name}</td>
                <td>${equipment.location}</td>
                <td>${equipment.status}</td>
                <td>${equipment.description}</td>
                <td>${equipment.lastMaintenanceAtStr}</td>
                <td>${equipment.createdAtStr}</td>
                <td>
                  <button onclick="editEquipment(${equipment.equipmentId})">수정</button>
                  <button onclick="updateMaintenance(${equipment.equipmentId})">점검</button>
                  <button onclick="deleteEquipment(${equipment.equipmentId})">삭제</button>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
</body>
</html>
