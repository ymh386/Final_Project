<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <sec:authorize access="hasRole('ADMIN')">
        <h2 id="title">부서별 회원 관리</h2>
    
        <button type="button" id="addUser">부서별 회원 추가하기</button>
        <button type="button" id="updateUser">부서별 회원 수정하기</button>
        <button type="button" id="deleteUser">부서별 회원 탈퇴하기</button>
        <button type="button" id="headUser">부서장 임명</button><br><br>
    
        <label>회원</label><br>
        <select id="userSelect" name="username">
            <option value="" selected>-- 회원 선택 --</option>
        </select><br><br>
    
        <label>부서</label><br>
        <select id="deptSelect" name="departmentId">
            <option id="deptSelected" value="" selected>-- 부서 선택 --</option>
        </select><br><br>
    
        <div id="utilBtn">
    
        </div>
    </sec:authorize>

    <sec:authorize access="!hasRole('ADMIN')">
        <h3>관리자만 이용 가능합니다.</h3>
    </sec:authorize>







    <script src="/js/department/userByDepartment.js"></script>
</body>
</html>