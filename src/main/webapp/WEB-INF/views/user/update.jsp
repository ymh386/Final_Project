<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
        <a href="/">home</a>
	<sec:authentication property="principal" var="user"/>
             <form:form modelAttribute="userVO" cssClass="user" method="post" enctype="multipart/form-data">
             
             	<div class="form-group">
                     <form:input cssClass="form-control form-control-user" id="password"
                         path="password" vale="${user.password}" placeholder="password" type="password" />
                 </div>
                 
                 <div class="form-group">
                     <form:input cssClass="form-control form-control-user" id="name"
                         path="name" vale="${user.name}" placeholder="name" />
                 </div>
                 
                 <div class="form-group">
                     <form:input cssClass="form-control form-control-user" id="phone"
                         path="phone" value="${user.phone}" placeholder="phone" />
                 </div>		
                 
                 <div class="form-group">
                     <form:input cssClass="form-control form-control-user" id="email"
                         path="email" value="${user.email}" placeholder="email" />
                         <div>
                     		<form:errors path="email"></form:errors>
                     	</div> 			                                        
                 </div>
                 
                 <div class="form-group">
                 	
                     <input type="date" class="form-control form-control-user" id="birth"
                         name="birth" value="${user.birth}">
                   	<div>
                     	<form:errors path="birth"></form:errors>
                     </div> 
                 </div>	
                 <hr>
                 <button type="submit">수정</button>
             </form:form>

</body>
</html>