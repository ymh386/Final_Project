<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<html class="fontawesome-i2svg-active fontawesome-i2svg-complete">

<head>
  <meta charset="UTF-8">
  <title>내 예약 목록</title>
  <style>
    /* Reset & Base */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Helvetica Neue', Arial, sans-serif; background: #f5f7fa; color: #333; margin: 20px; }
    
    h2 { margin-bottom: 20px; color: #2c3e50; font-size: 2rem; }
    
    p { margin-bottom: 15px; color: #34495e; }
    
    table { 
      border-collapse: collapse; 
      width: 100%; 
      background: #fff;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 1px 4px rgba(0,0,0,0.05);
      margin-bottom: 30px;
    }
    
    th, td { 
      border: 1px solid #e0e6ed; 
      padding: 12px 8px; 
      text-align: center; 
    }
    
    th { 
      background: #34495e; 
      color: #fff;
      font-weight: 500;
      font-size: 0.9rem;
    }
    
    td {
      font-size: 0.85rem;
      color: #2c3e50;
    }
    
    .msg { 
      color: #27ae60; 
      margin-bottom: 15px; 
      padding: 10px;
      background: #d4edda;
      border: 1px solid #c3e6cb;
      border-radius: 4px;
    }
    
    a.button { 
      margin-top: 15px; 
      margin-right: 10px;
      display: inline-block; 
      padding: 10px 20px; 
      background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
      color: #fff; 
      text-decoration: none; 
      border-radius: 6px;
      font-size: 0.95rem;
      font-weight: 500;
      transition: all 0.2s ease;
      box-shadow: 0 4px 8px rgba(37,117,252,0.3);
    }
    
    a.button:hover { 
      background: linear-gradient(135deg, #5a09b8 0%, #1f65e0 100%);
      box-shadow: 0 6px 12px rgba(31,101,224,0.4);
      transform: translateY(-2px);
    }
    
    /* Form 스타일링 */
    form input[type="text"] {
      padding: 6px 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 0.8rem;
      width: 120px;
    }
    
    form button {
      padding: 6px 12px;
      background: #e74c3c;
      color: #fff;
      border: none;
      border-radius: 4px;
      font-size: 0.8rem;
      cursor: pointer;
      transition: background 0.2s ease;
      margin-left: 5px;
    }
    
    form button:hover {
      background: #c0392b;
    }

    form button:disabled {
      background: #95a5a6;
      cursor: not-allowed;
    }

    /* Pagination - 게시판 스타일과 동일하게 */
    .pagination { 
      text-align: center; 
      margin-top: 36px; 
    }
    
    .pagination a, .pagination strong {
      display: inline-block; 
      margin: 0 6px; 
      padding: 10px 14px; 
      border-radius: 4px;
      font-size: 0.9rem; 
      transition: background 0.2s ease;
    }
    
    .pagination a {
      color: #3498db;
      text-decoration: none;
    }
    
    .pagination a:hover {
      background: #ecf6fc;
    }
    
    .pagination strong {
      background: #3498db;
      color: #fff;
    }

    /* 페이지 정보 스타일링 */
    .page-info {
      text-align: center; 
      margin-top: 10px; 
      color: #7f8c8d; 
      font-size: 0.9rem;
    }

    .expired-class {
      background-color: #f8f9fa !important;
      color: #6c757d !important;
    }
  </style>
  <c:import url="/WEB-INF/views/templates/header.jsp"></c:import>
  
</head>
<body class="sb-nav-fixed">
  <c:import url="/WEB-INF/views/templates/topbar.jsp"></c:import>
    <div id="layoutSidenav">
        <c:import url="/WEB-INF/views/templates/sidebar.jsp"></c:import>
        
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4" style="margin-top:30px">

  <h2>내 예약 목록</h2>
  
  <c:if test="${not empty remainingCount}">
  <div class="msg">
    이번 달 예약 횟수: ${monthlyCount}회 / 남은 가능 횟수: ${remainingCount}회
  </div>
</c:if>
  
  <sec:authorize access="isAuthenticated()">
    <p>안녕하세요, <sec:authentication property="name"/>님</p>
  </sec:authorize>

  <c:if test="${not empty msg}">
    <div class="msg">${msg}</div>
  </c:if>

  <!-- 예약 리스트 테이블 -->
  <table>
    <tr>
      <th>예약 ID</th>
      <th>일정 ID</th>
      <th>수업 시간</th>
      <th>트레이너</th>
      <th>장소</th>
      <th>예약 일시</th>
      <th>취소 일시</th>
      <th>취소 사유</th>
      <th>-</th>
    </tr>
    <c:forEach var="r" items="${list}">
      <tr>
        <td>${r.reservationId}</td>
        <td>${r.scheduleId}</td>
        <!-- 일정에 맞는 수업 시간 표시 -->
        <td>
          <c:forEach var="sch" items="${schedules}">
            <c:if test="${sch.scheduleId == r.scheduleId}">
              <span class="schedule-info" 
                    data-date="${sch.scheduleDate}" 
                    data-time="${sch.startTime}">
                ${sch.scheduleDate} ${sch.startTime} ~ ${sch.endTime}
              </span>
            </c:if>
          </c:forEach>
        </td>
        <!-- 일정 목록에서 scheduleId로 매칭한 schedule의 username을 찾아, trainerList에서 name 뽑아내기 -->
        <td>
          <c:forEach var="sch" items="${schedules}">
            <c:if test="${sch.scheduleId == r.scheduleId}">
              <c:forEach var="t" items="${trainerList}">
                <c:if test="${t.username == sch.username}">
                  ${t.name}
                </c:if>
              </c:forEach>
            </c:if>
          </c:forEach>
        </td>
        <!-- 시설ID에 따라 장소명 매핑 -->
        <td>
          <c:choose>
            <c:when test="${r.facilityId == 1}">복싱장</c:when>
            <c:when test="${r.facilityId == 2}">헬스장</c:when>
            <c:when test="${r.facilityId == 3}">수영장</c:when>
            <c:otherwise>알 수 없음</c:otherwise>
          </c:choose>
        </td>
        <td>${r.createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))}</td>
        <td>
          <c:choose>
            <c:when test="${not empty r.canceledAt}">
              ${r.canceledAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))}
            </c:when>
            <c:otherwise>–</c:otherwise>
          </c:choose>
        </td>
        <td>${r.canceledReason}</td>
        <td>
          <c:if test="${empty r.canceledAt}">
            <c:forEach var="sch" items="${schedules}">
              <c:if test="${sch.scheduleId == r.scheduleId}">
                <form action="${pageContext.request.contextPath}/reservation/cancel" 
                      method="post" 
                      style="display:inline;"
                      onsubmit="return validateCancelTime('${sch.scheduleDate}', '${sch.startTime}', this)">
                  <input type="hidden" name="reservationId" value="${r.reservationId}"/>
                  <input type="text" name="canceledReason" placeholder="취소 사유" required/>
                  <button type="submit">취소</button>
                </form>
              </c:if>
            </c:forEach>
          </c:if>
        </td>
      </tr>
    </c:forEach>
  </table>

  <!-- 페이징 네비게이션 - 게시판 스타일 적용 -->
  <c:if test="${pager.totalPage > 1}">
    <div class="pagination">
      <c:if test="${pager.prev}">
        <a href="?page=${pager.startPage - 1}">&laquo; 이전</a>
      </c:if>

      <c:forEach var="i" begin="${pager.startPage}" end="${pager.lastPage}">
        <c:choose>
          <c:when test="${i == pager.curPage}">
            <strong>${i}</strong>
          </c:when>
          <c:otherwise>
            <a href="?page=${i}">${i}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <c:if test="${pager.next}">
        <a href="?page=${pager.lastPage + 1}">다음 &raquo;</a>
      </c:if>
    </div>
    
    <!-- 페이지 정보 표시 -->
    <div class="page-info">
      총 ${pager.totalCount}개 중 ${pager.curPage}/${pager.totalPage} 페이지
    </div>
  </c:if>

  <a class="button" href="${pageContext.request.contextPath}/reservation/book">예약하기</a>
  <a class="button" href="${pageContext.request.contextPath}/">홈 화면</a>
  </div>
            </main>
            
            <c:import url="/WEB-INF/views/templates/footer.jsp"></c:import>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    function validateCancelTime(scheduleDate, startTime, form) {
        // 현재 시간 구하기
        const now = new Date();
        
        // 수업 시작 시간 구하기 (scheduleDate: yyyy-MM-dd, startTime: HH:mm:ss)
        const classDateTime = new Date(scheduleDate + 'T' + startTime);
        
        // 수업이 이미 시작했는지 확인
        if (now >= classDateTime) {
            alert('⛔ 이미 시작한 수업은 취소할 수 없습니다.');
            return false; // 폼 제출 막기
        }
        
        // 취소 사유 확인
        const cancelReason = form.querySelector('input[name="canceledReason"]').value.trim();
        if (cancelReason === '') {
            alert('❌ 취소 사유를 입력해주세요.');
            return false;
        }
        
        // 확인 메시지
        return confirm('정말로 예약을 취소하시겠습니까?');
    }
    
    // 페이지 로드 시 만료된 수업들 시각적으로 표시
    document.addEventListener('DOMContentLoaded', function() {
        const now = new Date();
        const scheduleInfos = document.querySelectorAll('.schedule-info');
        
        scheduleInfos.forEach(function(span) {
            const scheduleDate = span.getAttribute('data-date');
            const startTime = span.getAttribute('data-time');
            const classDateTime = new Date(scheduleDate + 'T' + startTime);
            
            if (now >= classDateTime) {
                // 만료된 수업의 행을 회색으로 표시
                const row = span.closest('tr');
                row.classList.add('expired-class');
                
                // 취소 버튼 비활성화
                const cancelBtn = row.querySelector('button[type="submit"]');
                if (cancelBtn) {
                    cancelBtn.disabled = true;
                    cancelBtn.textContent = '만료됨';
                }
            }
        });
    });
    </script>
  
</body>
</html>