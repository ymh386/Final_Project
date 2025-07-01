<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body {
            background: url('/img/main.jpg') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            position: relative;
            color: white;
        }

        body::before {
            content: "";
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0, 0, 0, 0.4);
            z-index: 0;
        }

        .login-wrapper {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            z-index: 1;
        }

        .login-card {
            width: 100%;
            max-width: 400px;
            background-color: rgba(0, 0, 0, 0.6);
            border-radius: 0.75rem;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
            padding: 1.5rem;
            color: white;
        }

        .login-card .card-body {
            padding: 1rem 0.5rem;
        }

       	.form-floating > label {
			color: rgba(255, 255, 255, 0.6);
			transition: color 0.3s ease, transform 0.3s ease;
		}

		/* input에 포커스되면 라벨 색상 선명하게, 위치와 크기 조정 */
		.form-floating > input:focus + label,
		.form-floating > input:not(:placeholder-shown) + label {
			color: rgba(255, 255, 255, 0.9) !important;
			opacity: 1 !important;
			transform: translateY(-1.5rem) scale(0.85);
			/* 위로 올리고 크기 줄이기 (기본 Bootstrap 스타일 맞춤) */
		}
		.form-floating > label::before,
		.form-floating > label::after {
			display: none !important;
		}

        .form-control {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

		.form-control:focus {
			background-color: rgba(255, 255, 255, 0.1); /* 클릭해도 같은 배경 유지 */
			color: white;
			border-color: rgba(255, 255, 255, 0.3);
			box-shadow: none; /* Bootstrap 기본 테두리 효과 제거 */
		}

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .form-check-label,
        .small,
        .nav-link,
        .text-muted {
            color: rgba(255, 255, 255, 0.75) !important;
        }

        .nav-tabs .nav-link.active {
            background-color: #343a40;
            color: white;
            border-color: transparent transparent white;
        }

        .nav-tabs .nav-link {
            color: rgba(255, 255, 255, 0.6);
        }

        .btn-dark, .btn-outline-dark {
            background-color: #222;
            color: white;
            border-color: #444;
        }

        .btn-outline-dark:hover {
            background-color: #333;
            color: white;
        }

        .alert-danger {
            background-color: rgba(255, 0, 0, 0.2);
            color: white;
            border: none;
        }
    </style>
</head>
<body>
    <div class="login-wrapper">
        <div class="card login-card shadow-sm">
            <div class="text-center mb-3" style="padding:0; margin:0;">
                <img src="/img/logo.png" alt="로고" style="height: 60px; width: 100%; padding: 0; margin: 0; display: block;" />
            </div>
            <div class="card-body">
                <ul class="nav nav-tabs mb-3 justify-content-center">
                    <li class="nav-item">
                        <a class="nav-link active" href="/user/login/login">일반회원</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/user/login/trainerLogin">트레이너</a>
                    </li>
                </ul>

                <form id="loginForm" action="/users/login" method="post" class="needs-validation" novalidate>
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control" name="username" id="username" placeholder=" " required />
                        <label for="username">아이디</label>
                        <div class="invalid-feedback">아이디를 입력해주세요.</div>
                    </div>

                    <div class="form-floating mb-3">
                        <input type="password" class="form-control" name="password" id="inputPassword" placeholder=" " required />
                        <label for="inputPassword">비밀번호</label>
                        <div class="invalid-feedback">비밀번호를 입력해주세요.</div>
                    </div>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger py-2">${param.error}</div>
                    </c:if>

                    <input name="loginType" type="hidden" value="member" />

                    <div class="form-check mb-2">
                        <input id="autoLogin" type="checkbox" class="form-check-input" />
                        <label for="autoLogin" class="form-check-label">자동 로그인</label>
                        <input id="autoFlag" name="auto" type="hidden" value="false" />
                    </div>

                    <div class="form-check mb-3">
                        <input id="rememberId" type="checkbox" class="form-check-input" />
                        <label class="form-check-label">ID 저장</label>
                    </div>

                    <div class="d-flex justify-content-between mb-3">
                        <a href="/user/findId" class="small text-decoration-none">아이디 찾기</a>
                        <a href="/user/findPwByEmail" class="small text-decoration-none">비밀번호 찾기</a>
                    </div>

                    <button type="submit" class="btn btn-dark w-100 mb-2">로그인</button>
                    <a href="/user/join/join" class="btn btn-outline-dark w-100">회원가입</a>
                </form>

                <div class="text-center mt-4">
                    <p class="mb-2">SNS 간편 로그인</p>
                    <div class="d-flex justify-content-center gap-3">
                        <a href="/oauth2/authorization/kakao?redirect=">
                            <img src="/img/kakao.png" alt="카카오 로그인" />
                        </a>
                        <a href="/oauth2/authorization/google?redirect=">
                            <img src="/img/1x.png" alt="구글 로그인" />
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (() => {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
