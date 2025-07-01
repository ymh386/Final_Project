<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 선택</title>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/themes/default/style.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/jstree@3.3.15/dist/jstree.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
    <script src="https://cdn.ckeditor.com/4.22.1/full-all/ckeditor.js"></script>
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

        .join-wrapper {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 2rem;
            z-index: 1;
            position: relative;
            flex-wrap: wrap;
        }

        .card {
            background-color: rgba(0, 0, 0, 0.6);
            color: white;
            border-radius: 0.75rem;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
            width: 18rem;
        }

        .card-title, .card-text {
            color: white;
        }

        .btn-primary {
            background-color: #222;
            border-color: #444;
        }

        .btn-primary:hover {
            background-color: #333;
            border-color: #555;
        }

        .card-img-top {
            border-top-left-radius: 0.75rem;
            border-top-right-radius: 0.75rem;
        }

        @media (max-width: 768px) {
            .join-wrapper {
                flex-direction: column;
                padding: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="join-wrapper">
        <!-- 일반 회원 카드 -->
        <div class="card text-center">
            <img src="/img/member.png" class="card-img-top" alt="일반회원 이미지">
            <div class="card-body">
                <h5 class="card-title">일반 회원 가입</h5>
                <p class="card-text">일반 회원으로 가입하세요.</p>
                <a href="/user/join/memberJoin" class="btn btn-primary">가입</a>
            </div>
        </div>

        <!-- 트레이너 카드 -->
        <div class="card text-center">
            <img src="/img/trainer.png" class="card-img-top" alt="트레이너 이미지">
            <div class="card-body">
                <h5 class="card-title">트레이너 가입</h5>
                <p class="card-text">트레이너, 강사, 코치 전용</p>
                <a href="/user/join/trainerJoin" class="btn btn-primary">가입</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
