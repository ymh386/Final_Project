<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기 - 전화번호</title>
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

        .container, .vh-100 {
            position: relative;
            z-index: 1;
        }

        .card {
            background-color: rgba(0, 0, 0, 0.6);
            color: white;
        }

        .card-header {
            background-color: transparent;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .form-floating > label {
            color: rgba(255, 255, 255, 0.6);
        }

        .form-floating > input {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .form-floating > input:focus {
            background-color: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.4);
            box-shadow: none;
            color: white;
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

        .btn-dark {
            background-color: #222;
            color: white;
            border-color: #444;
        }

        .btn-dark:hover {
            background-color: #333;
        }

        .nav-tabs .nav-link.active {
            background-color: #343a40;
            color: white;
            border-color: transparent transparent white;
        }

        .nav-tabs .nav-link {
            color: rgba(255, 255, 255, 0.6);
        }

        .alert {
            background-color: rgba(255, 0, 0, 0.2);
            color: white;
            border: none;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
    <main class="flex-fill d-flex justify-content-center align-items-center px-3">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-5">
                    <div class="card shadow-lg border-0 rounded-lg">
                        <div class="card-header">
                            <h3 class="text-center my-3">비밀번호 찾기</h3>
                        </div>
                        <div class="card-body">
                            <ul class="nav nav-tabs mb-3">
                                <li class="nav-item">
                                    <a class="nav-link" href="/user/findPwByEmail">이메일로 찾기</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link active" href="/user/findPwByPhone">전화번호로 찾기</a>
                                </li>
                            </ul>
                            <h5 class="text-center my-4">가입한 회원의 전화번호를 입력해주세요.</h5>
                            <form id="findPwForm" action="" method="post">
                                <div class="form-floating mb-3">
                                    <input class="form-control" type="text" name="phone" id="phone" placeholder=" " required />
                                    <label for="phone">전화번호('-' 생략)</label>
                                </div>
                                <c:if test="${not empty param.error}">
                                    <div class="alert py-2 text-center">${param.error}</div>
                                </c:if>
                                <div class="text-center">
                                    <button class="btn btn-dark w-100 mt-3" type="submit">발송</button>

                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
