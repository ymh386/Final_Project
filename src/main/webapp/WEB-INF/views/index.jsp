<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Home</title>
</head>
<body>
  <h3>home</h3>
  
  <sec:authentication property="principal" var="user"/>
  
  <sec:authorize access="isAuthenticated()">
      <h2>${user.name}</h2>
      <h3>구독권 잔여 일자 : ${result} 일</h3>
      <a href="${pageContext.request.contextPath}/user/mypage">내 정보</a>
      <a href="${pageContext.request.contextPath}/subscript/list">구독</a>
      <a href="${pageContext.request.contextPath}/user/logout">로그아웃</a>
      <a href="${pageContext.request.contextPath}/schedule/page">일정관리</a>
      <sec:authorize access="hasRole('TRAINER')">
          <a href="${pageContext.request.contextPath}/attendance/page">근태관리</a>
      </sec:authorize>
      <sec:authorize access="hasRole('MEMBER')">
          <a href="${pageContext.request.contextPath}/reservation/book">수업예약</a>
      </sec:authorize>
  </sec:authorize>

  <sec:authorize access="!isAuthenticated()">
      <a href="${pageContext.request.contextPath}/user/join/join">회원가입</a>
      <a href="${pageContext.request.contextPath}/user/login/login">로그인</a>
  </sec:authorize>

  <sec:authorize access="hasRole('ADMIN')">
      <a href="${pageContext.request.contextPath}/admin/main">관리자</a>
  </sec:authorize>
  
  <div>
      <sec:authorize access="hasRole('ADMIN')">
          <a href="${pageContext.request.contextPath}/approval/formRegister">양식등록(관리자)</a>
      </sec:authorize>
      <a href="${pageContext.request.contextPath}/approval/addDocument">결재신청</a>
  </div>

  <div>
    <a href="${pageContext.request.contextPath}/board/index">게시판</a>
  </div>
</body>
</html>
