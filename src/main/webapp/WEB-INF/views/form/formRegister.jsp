<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
	<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
		<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
		<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
		<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
	</head>
	<body class="sb-nav-fixed d-flex flex-column min-vh-100">
		<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
		<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
			<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
                <main class="flex-grow-1">
                    <div class="container">
							<!-- contents -->
						<h2>전자결재 양식 등록</h2>
                        <form action="./formRegister" method="post">
                            <label>양식 제목</label><br>
                            <input type="text" name="formTitle" required><br><br>
                            

                            <label>내용</label><br>
                            <textarea name="contentHtml" id="editor"></textarea><br><br>
                            
                            <button type="submit">등록</button>

                        </form> 
	
	





					<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
					</div>
				</main>
			</div>
		</div>
					
	
	
	
	
		<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
		</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        CKEDITOR.replace('editor',{
            extraPlugins: 'forms,tableresize',
            extraAllowedContent: 'td[id, contenteditable];th[id, contenteditable];img[src,style];',
            height: 1000
        });
        CKEDITOR.instances['editor'].setData('*결재란은 최대3개까지</br>*결재란의 결재자이름칸에 id속성을 name_1, name_2, name_3 형식으로 넣기!</br>*결재란의 서명칸에 id속성을 sign_1, sign_2, sign_3 형식으로 넣기!')
    </script>
	</body>
</html>