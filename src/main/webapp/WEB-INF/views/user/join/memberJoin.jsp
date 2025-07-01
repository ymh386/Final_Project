<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>일반 회원 가입</title>

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

        .container {
            position: relative;
            z-index: 1;
        }

        .card {
            background-color: rgba(0, 0, 0, 0.6);
            color: white;
            border-radius: 0.75rem;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.4);
        }

        .card-header h3 {
            color: white;
        }

        .form-control {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            border-color: rgba(255, 255, 255, 0.4);
            box-shadow: none;
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

        .input-group-text {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            border-color: rgba(255, 255, 255, 0.2);
        }

        input[type="date"] {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            width: 100%;
            margin-bottom: 1rem;
        }

        input[type="date"]:focus {
            outline: none;
            box-shadow: none;
            border-color: rgba(255, 255, 255, 0.4);
            background-color: rgba(255, 255, 255, 0.1);
        }

		/* 달력 버튼만 흰색으로 */
		input[type="date"]::-webkit-calendar-picker-indicator {
			filter: invert(1);
		}
		input[type="date"]::-moz-focus-inner {
			filter: invert(1);
		}

        button.btn-dark {
            background-color: #222;
            border-color: #444;
        }

        button.btn-dark:hover {
            background-color: #333;
        }

        .text-danger {
            color: #ff9999;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-5">
                <div class="card shadow-lg border-0 rounded-lg">
                    <div class="card-header text-center">
                        <h3 class="font-weight-light my-3">회원 가입</h3>
                    </div>
                    <div class="card-body">
                        <form action="" method="post" enctype="multipart/form-data">
                            <div class="input-group mb-3">
                                <input type="file" class="form-control" name="img" id="inputGroupFile02">
                                <label class="input-group-text" for="inputGroupFile02">Upload</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input class="form-control" type="text" name="username" placeholder=" ">
                                <label for="inputEmail">아이디</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input class="form-control" name="password" type="password" placeholder=" ">
                                <label for="inputPassword">비밀번호</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input class="form-control" type="text" name="name" placeholder=" ">
                                <label for="inputName">이름</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input class="form-control" type="email" name="email" placeholder=" ">
                                <label for="inputEmail">이메일</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input class="form-control" type="text" name="phone" placeholder=" ">
                                <label for="inputPhone">휴대폰 번호</label>
                            </div>

                            <input type="date" name="birth" />

                            <c:if test="${not empty param.error}">
                                <p class="text-danger mt-2">${param.error}</p>
                            </c:if>

                            <div class="text-center mt-4">
                                <button class="btn btn-dark w-100" type="submit">가입</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
