<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전자결재 양식 등록</title>
    <c:import url="/WEB-INF/views/templates/header.jsp" />
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
    <c:import url="/WEB-INF/views/templates/topbar.jsp" />
    <div id="layoutSidenav" class="d-flex flex-grow-1">
        <c:import url="/WEB-INF/views/templates/sidebar.jsp" />
        <div id="layoutSidenav_content" class="d-flex flex-column flex-grow-1">
            <main class="flex-grow-1">
                <div class="container py-4">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h3 class="mb-4"><i class="bi bi-journal-plus"></i> 전자결재 양식 등록</h3>

                            <!-- 가이드 -->
                            <div class="alert alert-secondary small mb-4 text-start">
                                <strong>📌 작성 가이드</strong><br>
								<ul class="mb-1 ps-3">
									<li class="mb-2"><strong>결재란</strong>은 되도록 아래의 형식으로 작성해 주세요:<br>
									<pre class="bg-light p-2 border rounded small mt-1"  style="white-space:pre-wrap; word-break:break-word; font-size:12px; text-align:left;">
								&lt;table align="right" border="1" cellpadding="1" cellspacing="0" style="text-align:center; width:300px"&gt;
								&lt;thead&gt;
									&lt;tr&gt;
									&lt;th contenteditable="false" id="name_1" scope="col"&gt;&nbsp;&lt;/th&gt;
									&lt;th contenteditable="false" id="name_2" scope="col"&gt;&nbsp;&lt;/th&gt;
									&lt;th contenteditable="false" id="name_3" scope="col"&gt;&nbsp;&lt;/th&gt;
									&lt;/tr&gt;
								&lt;/thead&gt;
								&lt;tbody&gt;
									&lt;tr&gt;
									&lt;td id="sign_1" rowspan="2" style="height:50px;"&gt;&nbsp;&lt;/td&gt;
									&lt;td id="sign_2" rowspan="2"&gt;&nbsp;&lt;/td&gt;
									&lt;td id="sign_3" rowspan="2"&gt;&nbsp;&lt;/td&gt;
									&lt;/tr&gt;
								&lt;/tbody&gt;
								&lt;/table&gt;
									</pre>
									</li>

									<li class="mb-2"><strong>휴가신청서</strong>의 경우 제목은 반드시 아래처럼 작성해야 합니다: <code>id="title"</code> 필수
									<pre class="bg-light p-2 border rounded small mt-1" style="white-space:pre-wrap; word-break:break-word; font-size:12px; text-align:left;">
								&lt;div id="title" style="text-align:center"&gt;
								&lt;span style="font-size:18pt; font-family:'맑은 고딕'; color:#000"&gt;
									&lt;strong&gt;휴가신청서&lt;/strong&gt;
								&lt;/span&gt;
								&lt;/div&gt;
									</pre>
									</li>

									<li class="mb-2"><strong>휴가 종류</strong>는 반드시 아래와 같이 id를 지정해 주세요:
									<pre class="bg-light p-2 border rounded small mt-1" style="white-space:pre-wrap; word-break:break-word; font-size:12px; text-align:left;">
								&lt;div id="aa1"&gt;연차(&nbsp;&nbsp;&nbsp;)&lt;/div&gt;
								&lt;div id="aa2"&gt;훈련(&nbsp;&nbsp;&nbsp;)&lt;/div&gt;
								&lt;div id="aa3"&gt;병가(&nbsp;&nbsp;&nbsp;)&lt;/div&gt;
								&lt;div id="aa4"&gt;포상(&nbsp;&nbsp;&nbsp;)&lt;/div&gt;
									</pre>
									</li>

									<li class="mb-2"><strong>휴가 일수</strong>는 아래처럼 <code>id="h_caldate"</code>로 작성하세요:
									<pre class="bg-light p-2 border rounded small mt-1" style="white-space:pre-wrap; word-break:break-word; font-size:12px; text-align:left;">
								&lt;div id="h_caldate"&gt;( 1일 )&lt;/div&gt;
									</pre>
									</li>
								</ul>
                            </div>

                            <!-- 등록 폼 -->
                            <form action="./formRegister" method="post">
                                <div class="mb-3">
                                    <label for="formTitle" class="form-label">양식 제목</label>
                                    <input type="text" class="form-control" name="formTitle" id="formTitle" placeholder="예: 출장신청서" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">양식 내용</label>
                                    <textarea name="contentHtml" id="editor"></textarea>
                                </div>

                                <div class="text-end">
                                    <button type="submit" class="btn btn-outline-primary">
                                        <i class="bi bi-check-circle"></i> 등록하기
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
            <c:import url="/WEB-INF/views/templates/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        CKEDITOR.replace('editor', {
            extraPlugins: 'forms,tableresize',
            extraAllowedContent: 'td[id, contenteditable];th[id, contenteditable];img[src,style];',
            height: 1000
        });
        CKEDITOR.instances['editor'].setData(
            '*결재란은 최대 3개까지<br>*결재자 이름칸 → id="name_1~3"<br>*서명란 → id="sign_1~3"'
        );
    </script>
</body>
</html>
