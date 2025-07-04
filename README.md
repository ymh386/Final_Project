# 🏋️‍♂️ 스포츠클럽 그룹웨어 시스템 (Sports Club Groupware)

**Tech Stack**: Spring Boot + MyBatis + MariaDB + JSP

---

## 📌 프로젝트 개요

스포츠센터의 운영 효율을 높이기 위한 **내부 전용 그룹웨어 시스템**입니다.  
관리자와 트레이너(일반 회원) 간의 업무 흐름을 전자화하고, 근태 및 일정 관리, 전자결재, 비품 처리 등의 다양한 기능을 제공합니다.

---

## 🎯 주요 기능

### ✅ 공통
- 로그인 / 로그아웃 / 마이페이지
- 쿠키 기반 자동 로그인 (아이디 저장 포함)
- Spring Security 기반 인증 및 권한 분리
- 알림(Notification) 기능 (전자결재, 비품 처리 등 이벤트 기반)
- 감사기록(Audit Log) 저장

### 🧑‍💼 관리자 기능
- 근태 관리 (출근/퇴근 기록 및 통계)
- 수업 일정 등록 (회원이 예약 가능)
- 전자결재 승인 및 요청 현황 관리
- 비품 고장 신고 접수 및 처리
- 부서 관리
- 통계 차트 시각화 (근태율, 휴가율 등)

### 🧑‍🏫 트레이너 / 일반 회원 기능
- 출퇴근 체크 (출근/퇴근)
- 수업 일정 예약 및 조회
- 비품 고장 신고
- 전자결재 요청
- 게시판 열람 및 작성

---

## 🛠 기술 스택

| 분류 | 기술 |
|------|------|
| **Backend** | Java 17, Spring Boot 4.x, MyBatis |
| **Frontend** | JSP, HTML5, CSS3, JavaScript |
| **Database** | MariaDB |
| **Template** | JSP + JSTL |
| **보안** | Spring Security, BCrypt 암호화 |
| **기타** | 쿠키 기반 자동 로그인, Ajax, Chart.js, FullCalendar, Bootstrap 5 |

---

## 🗂 프로젝트 구조

📁 src/
├── 📁 main/
│ ├── 📁 java/
│ │ ├── controller/
│ │ │ ├── ApprovalController.java # 전자결재
│ │ │ ├── AttendanceController.java # 근태관리
│ │ │ ├── EquipmentController.java # 비품 신고/처리
│ │ │ ├── ScheduleController.java # 일정관리
│ │ │ ├── DepartmentController.java # 부서관리
│ │ │ └── NotificationController.java # 알림
│ │ ├── service/ # 비즈니스 로직
│ │ ├── model/ # DTO, Mapper
│ │ ├── security/ # Spring Security 설정
│ │ └── util/ # 유틸 클래스
│ ├── resources/
│ │ ├── mapper/ # MyBatis XML 매퍼
│ │ └── application.yml # 환경 설정
│ └── webapp/
│ ├── WEB-INF/
│ │ └── jsp/ # JSP 화면
│ └── static/ # JS, CSS, 이미지



## 📸 데모 스크린샷

| 통계 대시보드 | 전자결재 요청 화면 |
|---------------|-------------------|
| ![통계](images/statistics.png) | ![전자결재](images/approval.png) |

> 📌 `images/` 폴더에 실제 이미지를 넣고 상대경로로 불러오세요

---

## 🔒 보안

- Spring Security를 통한 역할 기반 권한 관리 (관리자 / 트레이너 구분)
- 비밀번호 BCrypt 암호화
- 마이페이지에서 비밀번호 변경 가능
- 자동 로그인 쿠키 유효성 검증
