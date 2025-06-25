<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Google Fonts & Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Orbitron:wght@700&family=Bebas+Neue&display=swap" rel="stylesheet">

<style>
body {
    font-family: 'Montserrat', 'Orbitron', 'Bebas Neue', Arial, sans-serif;
}

.sports-topbar { 
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    right: 0 !important;
    height: 64px !important;
    border-bottom: 4px solid #ffe600 !important;
    margin-top: 0 !important;
    box-shadow: none !important;
    z-index: 1100 !important;
  }

.sports-topbar {
    width: 100%;
    background: #18191d;
    color: #ffe600;
    display: flex;
    align-items: center;
    padding: 0 2.2rem;
    height: 64px;
    justify-content: space-between;
    border-bottom: 4px solid #ffe600;
    position: relative;
    z-index: 1002;
}

.sports-logo {
    font-family: 'Orbitron', 'Bebas Neue', Arial, sans-serif;
    font-size: 2.2rem;
    font-weight: bold;
    letter-spacing: 2.5px;
    color: #ffe600;
    text-shadow: 1px 1px 0 #232326;
    text-decoration: none;
}

.sports-actions {
    display: flex;
    align-items: center;
    gap: 1.2rem;
    position: relative;
}

.sports-sub-info {
    color: #ffe600;
    font-size: 1.08em;
    font-weight: 500;
    margin-right: 10px;
}

.sports-sub-info .btn {
    margin-left: 4px;
    margin-right: 2px;
    font-size: 0.98em;
    padding: 2px 11px;
}

.sports-notify-wrap {
    position: relative;
    margin-right: 4px;
}

.sports-notify-btn {
    background: none;
    border: none;
    color: #ffe600;
    font-size: 1.55em;
    position: relative;
    cursor: pointer;
    padding: 4px 9px;
    outline: none;
    transition: color .15s, transform .12s;
}

.sports-notify-btn:hover i {
    color: #fff338;
    transform: scale(1.08);
}

.sports-notify-badge {
    position: absolute;
    top: 2px;
    right: 7px;
    background: #e0252d;
    color: #fff;
    border-radius: 50%;
    padding: 0 7px;
    font-size: 0.75em;
    font-weight: bold;
    min-width: 19px;
    text-align: center;
    line-height: 1.3;
    display: inline-block;
}

.sports-notify-list {
    position: absolute;
    right: 0;
    top: 44px;
    background: #232326;
    color: #fff;
    border: 1.7px solid #ffe600;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.14);
    width: 290px;
    display: none;
    z-index: 1003;
    padding: 8px 0;
    animation: dropdown-fadein .18s;
    max-height: 400px;
    overflow-y: auto;
}

.sports-notify-list li {
    padding: 10px 20px;
    border-bottom: 1px solid #35353b;
    font-size: 0.97em;
}

.sports-notify-list li:last-child {
    border-bottom: none;
}

.sports-notify-list li:hover {
    background: #191919;
    cursor: pointer;
}

.sports-profile-btn {
    background: #ffe600;
    color: #232326;
    border: none;
    border-radius: 50%;
    width: 41px;
    height: 41px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.8em;
    margin-left: 6px;
    cursor: pointer;
    box-shadow: 0 1px 7px rgba(0, 0, 0, 0.08);
    transition: background .16s, box-shadow .14s;
    user-select: none;
}

.sports-profile-btn:hover {
    background: #fff338;
}

/* 프로필 드롭다운 */
.sports-actions .profileList {
    position: absolute;
    top: 50px;
    right: 0;
    background: #232326;
    border: 1.5px solid #ffe600;
    border-radius: 10px;
    min-width: 220px;
    padding: 8px 16px; /* 전체 컨테이너 좌우 패딩 */
    box-shadow: 0 8px 18px rgba(0, 0, 0, 0.12);
    font-family: 'Montserrat', 'Orbitron', 'Bebas Neue', Arial, sans-serif;
    color: #fff;
    display: none;
    z-index: 1003;
    overflow: hidden;
}

.sports-actions .profileList h6 {
    color: #ffe600;
    font-size: 1.1em;
    font-weight: bold;
    padding: 10px 0; /* 위아래 패딩만 */
    margin: 0 0 10px 0;
    border-bottom: 1px solid #ffe600;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.sports-actions .profileItem {
    display: block;
    background: #ffe600;
    color: #18191d;
    font-weight: 600;
    border-radius: 6px;
    padding: 10px 0; /* 좌우 패딩은 컨테이너에서 이미 주었으므로 없앰 */
    margin: 6px 0; /* 위아래 간격만 */
    text-align: center;
    text-decoration: none;
    transition: background .13s, color .13s;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.sports-actions .profileItem:hover {
    background: #fff338;
    color: #232326;
}

@keyframes dropdown-fadein {
    from {
        opacity: 0;
        transform: translateY(-16px);
    }

    to {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>

<div class="sports-topbar">
    <a href="/" class="sports-logo">SPORTS CLUB</a>
    <sec:authentication property="principal" var="user"></sec:authentication>

    <div class="sports-actions">
        <sec:authorize access="isAuthenticated()">
            <sec:authorize access="!hasRole('TRAINER')">
                <div class="sports-sub-info">
                    구독권 잔여 일자 : ${remainDay} 일
                    <sec:authorize access="hasAuthority('CANCEL')">
                        <a class="btn btn-light" href="/subscript/restart">구독 재개</a>
                    </sec:authorize>
                    <sec:authorize access="hasAuthority('APPROVE')">
                        <a class="btn btn-light" href="/subscript/cancel">구독 취소</a>
                    </sec:authorize>
                    <c:if test="${remainDay eq 0}">
                        <a class="btn btn-light" href="/subscript/list">구독</a>
                    </c:if>
                </div>
            </sec:authorize>

            <!-- 알림 아이콘 -->
            <div id="notification" data-username="${user.username}" class="sports-notify-wrap">
                <button id="notificationButton" class="sports-notify-btn" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-bell"></i>
                    <span id="notificationBadge" class="sports-notify-badge" style="display:none;">0</span>
                </button>
                <!-- 드롭다운 전체: div로 묶고 ul은 내부 리스트용 -->
                <div class="dropdown-menu dropdown-menu-end p-0" style="width: 300px;">
                    <!-- 스크롤 되는 알림 리스트 -->
                    <ul id="notificationList" class="list-unstyled m-0" style="max-height: 350px; overflow-y: auto;">
                    <!-- 여기에 JS로 <li><a class="dropdown-item">...</a></li> 추가 -->
                    </ul>
                    
                    <!-- 항상 하단 고정되는 버튼 -->
                    <div class="border-top text-center bg-white">
                    <a href="/notification/list" class="btn btn-outline-dark d-block">알림함 이동</a>
                    </div>
                </div>
            </div>
            

            <!-- Toast Container(실시간 알림 팝업) -->
            <div id="toastContainer" class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1055;"></div>
        </sec:authorize>

        <!-- 프로필 드롭다운 -->
        <li class="nav-item dropdown" style="list-style:none; position: relative;">
            <button id="profileButton" class="sports-profile-btn" type="button" aria-haspopup="true" aria-expanded="false" aria-controls="profileDropdown">
                <i class="bi bi-person-circle"></i>
            </button>
            <ul id="profileDropdown" class="dropdown-menu dropdown-menu-end profileList" aria-labelledby="profileButton" role="menu">
                <sec:authorize access="isAuthenticated()">
                    <h6 title="${user.name}님, 환영합니다!">${user.name}님, 환영합니다!</h6>
                    <li><a class="dropdown-item profileItem" href="/user/mypage">내 정보</a></li>
                    <li><a class="dropdown-item profileItem" href="/user/logout">로그아웃</a></li>
                    <li><a class="dropdown-item profileItem" href="/schedule/page">일정</a></li>
                    <sec:authorize access="hasRole('TRAINER')">
                        <li><a class="dropdown-item profileItem" href="${pageContext.request.contextPath}/attendance/page">근태관리</a></li>
                        <li><a class="dropdown-item profileItem" href="${pageContext.request.contextPath}/equipment/main">비품 신고</a></li>
                    </sec:authorize>
                    <sec:authorize access="hasRole('MEMBER')">
                        <li><a class="dropdown-item profileItem" href="${pageContext.request.contextPath}/reservation/book">수업예약</a></li>
                    </sec:authorize>
                    <sec:authorize access="hasRole('ADMIN')">
                        <li><a class="dropdown-item profileItem" href="/admin/main">관리자</a></li>
                        <li><a class="dropdown-item profileItem" href="${pageContext.request.contextPath}/equipment/admin">비품 관리</a></li>
                    </sec:authorize>
                </sec:authorize>
                <sec:authorize access="!isAuthenticated()">
                    <li><a class="dropdown-item profileItem" href="/user/join/join">회원가입</a></li>
                    <li><a class="dropdown-item profileItem" href="/user/login/login">로그인</a></li>
                </sec:authorize>
            </ul>
        </li>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<audio id="notificationSound" src="/sound/notification.wav" preload="auto"></audio>
<script src="/js/notification/notification.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const profileBtn = document.getElementById('profileButton');
    const profileDropdown = document.getElementById('profileDropdown');

    profileBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        if (profileDropdown.style.display === 'block') {
            profileDropdown.style.display = 'none';
            profileBtn.setAttribute('aria-expanded', 'false');
        } else {
            profileDropdown.style.display = 'block';
            profileBtn.setAttribute('aria-expanded', 'true');
        }
    });

    document.body.addEventListener('click', function() {
        profileDropdown.style.display = 'none';
        profileBtn.setAttribute('aria-expanded', 'false');
    });
});
</script>
