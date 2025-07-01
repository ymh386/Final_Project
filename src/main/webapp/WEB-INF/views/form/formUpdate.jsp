<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">
<head>
	<meta charset="UTF-8">
	<title>전자결재 양식 수정</title>
	<c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
	<script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
	<script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>

	<style>
        label {
            font-weight: 600;
        }
    </style>
</head>
<body class="sb-nav-fixed d-flex flex-column min-vh-100">
	<c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
	<div id="layoutSidenav" class="d-flex flex-grow-1">
		<c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
		<div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
			<main class="flex-grow-1">
				<div class="container py-4">
					

					<div class="card shadow-sm">
						<div class="card-body">
							<h2 class="mb-4">전자결재 양식 수정</h2>

							<!-- 작성 가이드 -->
							<div class="alert alert-secondary small mt-4 text-start">
								<strong>📌 작성 가이드</strong>
								<ul class="mb-1 ps-3">
									<li class="mb-2">
										<strong>결재란</strong>은 아래와 같이 작성해 주세요:
										<pre class="bg-light p-2 border rounded small mt-1"
											style="white-space:pre-wrap; word-break:break-word; text-align:left; font-size:12px;">
											&lt;table 
											border="1" cellpadding="1" cellspacing="0"
											style="float:right; margin-left:10px; text-align:center; width:300px;"&gt;
											&lt;thead&gt;
												&lt;tr&gt;
												&lt;th id="name_1"&gt;&nbsp;&lt;/th&gt;
												&lt;th id="name_2"&gt;&nbsp;&lt;/th&gt;
												&lt;th id="name_3"&gt;&nbsp;&lt;/th&gt;
												&lt;/tr&gt;
											&lt;/thead&gt;
											&lt;tbody&gt;
												&lt;tr&gt;
												&lt;td id="sign_1" rowspan="2"&gt;&nbsp;&lt;/td&gt;
												&lt;td id="sign_2" rowspan="2"&gt;&nbsp;&lt;/td&gt;
												&lt;td id="sign_3" rowspan="2"&gt;&nbsp;&lt;/td&gt;
												&lt;/tr&gt;
											&lt;/tbody&gt;
											&lt;/table&gt;
										</pre>
									</li>
									<li class="mb-2">
										<strong>휴가신청서</strong>는 제목을 반드시 아래처럼 작성해 주세요:
										<pre class="bg-light p-2 border rounded small mt-1" style="white-space:pre-wrap; word-break:break-word; text-align:left; font-size:12px;">
											&lt;div id="title" style="text-align:center"&gt;
											&lt;span style="font-size:18pt; font-family:'맑은 고딕'; color:#000"&gt;
												&lt;strong&gt;휴가신청서&lt;/strong&gt;
											&lt;/span&gt;
											&lt;/div&gt;
										</pre>
									</li>
									<li class="mb-2">
										<strong>휴가 종류 선택 영역</strong>은 아래와 같이 구성하고 ID를 aa1~aa4로 설정:
										<pre class="bg-light p-2 border rounded small mt-1" style="white-space:pre-wrap; word-break:break-word; text-align:left; font-size:12px;">
											&lt;div id="aa1"&gt;연차(&nbsp;&nbsp;&nbsp;)&lt;/div&gt;
											&lt;div id="aa2"&gt;훈련(&nbsp;&nbsp;&nbsp;)&lt;/div&gt;
											&lt;div id="aa3"&gt;병가(&nbsp;&nbsp;&nbsp;)&lt;/div&gt;
											&lt;div id="aa4"&gt;포상(&nbsp;&nbsp;&nbsp;)&lt;/div&gt;
										</pre>
									</li>
									<li class="mb-2">
										<strong>총 일수 입력</strong>은 아래와 같이 ID를 반드시 <code>h_caldate</code>로 설정:
										<pre class="bg-light p-2 border rounded small mt-1" style="white-space:pre-wrap; word-break:break-word; text-align:left; font-size:12px;">
											&lt;div id="h_caldate"&gt;( 1일 )&lt;/div&gt;
										</pre>
									</li>
								</ul>
							</div>


							<form action="./formUpdate" method="post">
								<input type="hidden" name="formId" value="${vo.formId}">
								<input type="hidden" name="categoryId" value="${vo.categoryId}">

								<div class="mb-3">
									<label for="formTitle" class="form-label">양식 제목</label>
									<input type="text" id="formTitle" name="formTitle" class="form-control" value="${vo.formTitle}" required>
								</div>

								<div class="mb-3">
									<label class="form-label">양식 내용</label>
									<textarea name="contentHtml" id="editor" rows="20" class="form-control">${vo.contentHtml}</textarea>
								</div>

								<button type="submit" class="btn btn-dark px-4">수정</button>
							</form>
						</div>
					</div>

					
				</div>
			</main>
			<c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		CKEDITOR.replace('editor', {
			extraPlugins: 'forms,tableresize',
			extraAllowedContent: 'td[id, contenteditable];th[id, contenteditable];img[src,style];',
			height: 1000
		});
	</script>
</body>
</html>
