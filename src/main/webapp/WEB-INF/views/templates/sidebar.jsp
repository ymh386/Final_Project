<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<!-- 햄버거 메뉴 (모바일용) -->
<button class="sidebar-toggle" onclick="toggleSidebar()">
  <i class="bi bi-list"></i>
</button>

<!-- 🟨 사이드바 -->
<div class="club-sidebar" id="sidebar">
  <div class="sb-sidenav-menu">
    <div class="sb-sidenav-menu-heading">COMMUNITY</div>
    <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages" aria-expanded="false" aria-controls="collapsePages">
      <div class="sb-nav-link-icon"><i class="bi bi-journal-text"></i></div>
      게시판
      <div class="sb-sidenav-collapse-arrow"><i class="bi bi-chevron-down"></i></div>
    </a>
    <div class="collapse" id="collapsePages" aria-labelledby="headingTwo" data-bs-parent="#sidenavAccordion">
      <nav class="sb-sidenav-menu-nested nav accordion" id="sidenavAccordionPages">
        <a class="nav-link" href="/board/list">
          <div class="sb-nav-link-icon"><i class="bi bi-globe"></i></div>자유게시판
        </a>
        <a class="nav-link" href="/notice/list">
          <div class="sb-nav-link-icon"><i class="bi bi-info-circle-fill"></i></div>공지사항
        </a>
        <a class="nav-link" href="/qna/list">
          <div class="sb-nav-link-icon"><i class="bi bi-patch-question-fill"></i></div>QNA
        </a>
      </nav>
    </div>
    <a class="nav-link" href="/chat/list">
      <div class="sb-nav-link-icon"><i class="bi bi-chat-fill"></i></div>채팅
    </a>
    <a class="nav-link" href="/friend/list">
      <div class="sb-nav-link-icon"><i class="bi bi-people-fill"></i></div>친구
    </a>

    <div class="sb-sidenav-menu-heading">ADDONS</div>
    <a class="nav-link" href="charts.html">
      <div class="sb-nav-link-icon"><i class="bi bi-bar-chart-line-fill"></i></div>Charts
    </a>
    <a class="nav-link" href="tables.html">
      <div class="sb-nav-link-icon"><i class="bi bi-table"></i></div>Tables
    </a>

    <sec:authorize access="hasRole('TRAINER')">
      <div class="sb-sidenav-menu-heading">결재</div>
      <a class="nav-link" href="/approval/addDocument">
        <div class="sb-nav-link-icon"><i class="bi bi-folder-fill"></i></div>결재신청
      </a>
    </sec:authorize>
  </div>
  <div class="sb-sidenav-footer">
    <div class="small">Logged in as:</div>
    <span style="font-family:'Bebas Neue',sans-serif;letter-spacing:0.02em;">SPORTS CLUB</span>
  </div>
</div>

<!-- ✅ 스타일 -->
<style>
:root {
  --club-yellow: #ffe600;
  --club-sidebar: #23232a;
}

.sidebar-toggle {
  display: none;
  position: fixed;
  top: 10px;
  left: 10px;
  z-index: 9999;
  background: var(--club-yellow);
  border: none;
  padding: 8px 12px;
  font-size: 1.2rem;
  border-radius: 4px;
}

.club-sidebar {
  position: fixed;
  left: 0;
  top: 64px;
  width: 240px;
  height: calc(100vh - 64px);
  background: var(--club-sidebar);
  color: var(--club-yellow);
  border-right: 3px solid var(--club-yellow);
  z-index: 120;
  font-size: 1.06em;
  box-shadow: 2px 0 10px rgba(0,0,0,0.07);
  padding-top: 1.5rem;
  display: flex;
  flex-direction: column;
  transition: left 0.3s ease;
}

.club-sidebar .sb-sidenav-menu-heading {
  padding: 1rem 2rem 0.5rem 2rem;
  font-size: 1.08em;
  font-weight: bold;
  color: var(--club-yellow);
  letter-spacing: 0.02em;
}

.club-sidebar .nav-link {
  display: flex;
  align-items: center;
  color: #fff;
  padding: 12px 2.3rem;
  font-weight: 500;
  font-size: 1em;
  border-left: 3px solid transparent;
  text-decoration: none;
  transition: background 0.15s, border-color 0.15s;
}
.club-sidebar .nav-link:hover,
.club-sidebar .nav-link.active {
  background: #24242e;
  color: var(--club-yellow);
  border-left: 3px solid var(--club-yellow);
}
.club-sidebar .sb-nav-link-icon {
  margin-right: 12px;
  font-size: 1.22em;
  display: flex;
  align-items: center;
}
.club-sidebar .sb-sidenav-footer {
  margin-top: auto;
  background: #1d1d23;
  color: #bdbdbd;
  padding: 18px 2rem;
  font-size: 0.93em;
  border-top: 1px solid #333;
}

/* ✅ 모바일 반응형 처리 */
@media (max-width: 768px) {
  .sidebar-toggle {
    display: block;
  }
  .club-sidebar {
    left: -250px;
    transition: left 0.3s ease;
  }
  .club-sidebar.active {
    left: 0;
  }
}
</style>

<!-- ✅ JS 토글 스크립트 -->
<script>
function toggleSidebar() {
  const sidebar = document.getElementById('sidebar');
  sidebar.classList.toggle('active');
}
</script>
