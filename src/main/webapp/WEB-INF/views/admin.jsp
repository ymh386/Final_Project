<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
<style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h2 {
            margin-bottom: 20px;
    }
    #buttons {
        margin-bottom: 20px;
    }
    #buttons button {
        padding: 10px 20px;
        margin-right: 10px;
        font-size: 16px;
        cursor: pointer;
    }
    #stateList {
        width: 100%;
        border-collapse: collapse;
    }
    #stateList th, #stateList td {
        border: 1px solid #ccc;
        padding: 8px;
        text-align: center;
    }
    #stateList th {
        background-color: #f4f4f4;
    }
    .disabled {
        background-color: #ddd;
        color: #666;
        cursor: not-allowed;
    }
</style>
</head>


<body class="sb-nav-fixed d-flex flex-column min-vh-100">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
                    <div class="container">
							<!-- contents -->

                        <h1>ADMIN</h1>
                        <h2>승인 대기 리스트</h2>
                        <table id="stateList">
                            <thead>
                                <tr>
                                    <th>유저ID</th>
                                    <th>상태</th>
                                    <th>승인</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${userList}" var="u">
                                    <tr>
                                        <form action="/admin/updateState?username=${u.username}" method="post">
                                            <td>${u.username}</td>
                                            <td>승인 필요</td>
                                            <td><button type="submit">승인</button></td>
                                        </form>
                                    </tr>
                        </c:forEach>
                            </tbody>
                        </table>
                        <button class="btn btn-outline-dark" id="submit" type="submit">승인</button><br>
                        
                        <a href="./auditLog/list" class="btn btn-dark">감사 기록 보러가기</a>   
                        <a href="/user/department/list" class="btn btn-dark">부서 관리</a>  
                        <a href="/approval/admin/formList" class="btn btn-dark">결재양식 관리</a>  
                        <a href="/chart/admin/stats" class="btn btn-dark">통계/차트</a>  



                        





					
					</div>
				</main>
                <c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
			</div>
		</div>
					
	
	
	
	
        <script src="/js/admin.js"></script>
	    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	</body>
</html>