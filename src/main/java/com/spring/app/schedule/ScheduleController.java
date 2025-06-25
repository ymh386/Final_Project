package com.spring.app.schedule;

import java.security.Principal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;

/**
 * 역할:
 *  - ROLE_TRAINER: 본인 일정(User 기준) 조회만 가능
 *  - ROLE_ADMIN  : 전체 일정 조회·생성·수정·삭제 가능
 *
 */
@Controller
@RequestMapping("/schedule")
public class ScheduleController {

    @Autowired
    private ScheduleService scheduleService;
    
    @Autowired
    private UserService userService; 

    /**
     * 1) 일정 관리 페이지 렌더링
     *    - 트레이너도, 관리자도 접근 가능
     *    - 모델에는 오직 scheduleVO(바인딩용)만 전달
     *    → 트레이너 목록은 별도 API나 front-end 코드에서 처리해야 함
     */
    @GetMapping("/page")
    public String schedulePage(Model model) {
        // 1) "T로 시작하는" 트레이너 목록 조회
        //    여기서 "T%"를 넘기면 MyBatis 쿼리가 `WHERE username LIKE 'T%'` 로 실행됨
        List<UserVO> trainerList = userService.getUsersByUsernamePrefix("T%");

        // 2) JSP에서 <c:forEach items="${trainerList}"> 으로 순회할 수 있도록 모델에 담아준다.
        model.addAttribute("trainerList", trainerList);

        // 3) 폼 바인딩용 빈 ScheduleVO 추가 (선택 사항)
        model.addAttribute("scheduleVO", new ScheduleVO());

        return "schedule/page";  // /WEB-INF/views/schedule/page.jsp
    }

    /**
     * 2) 트레이너 본인 일정 조회 (ROLE_TRAINER 또는 ROLE_ADMIN 권한)
     *    GET /schedule/my
     *    → FullCalendar가 이해할 수 있는 JSON 구조로 반환
     */
    @GetMapping("/my")
    @ResponseBody
    @PreAuthorize("hasAnyRole('TRAINER','ADMIN')")
    public List<Map<String, Object>> getMySchedules(Principal principal) {
        String username = principal.getName();
        // ScheduleVO 리스트(원시 데이터)를 가져온다
        List<ScheduleVO> list = scheduleService.getScheduleById(username);

        // FullCalendar가 이해할 수 있는 형태로 변환
        return convertToCalendarEvents(list);
    }

    /**
     * 3) 전체 일정 조회 (관리자만)
     *    GET /schedule/list
     *    → FullCalendar 등에서 쓸 수 있도록 Map 구조로 반환
     */
    @GetMapping("/list")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public List<Map<String, Object>> getAllSchedules() {
        List<ScheduleVO> list = scheduleService.getAllSchedules();
        return convertToCalendarEvents(list);
    }

    /**
     * ScheduleVO 리스트를 FullCalendar용 이벤트로 변환하는 공통 메서드
     */
    private List<Map<String, Object>> convertToCalendarEvents(List<ScheduleVO> schedules) {
        List<Map<String, Object>> events = new ArrayList<>();
        
        for (ScheduleVO vo : schedules) {
            // 1. 트레이너 정보 조회
        	UserVO trainer = (UserVO) userService.loadUserByUsername(vo.getUsername());
            String trainerName = (trainer != null) ? trainer.getName() : vo.getUsername();
            
            // 2. 시설명 매핑
            String facilityName = getFacilityName(vo.getFacilityId());
            
            // 3. 시간 포맷팅 (LocalTime을 HH:MM 형태로)
            String startTime = formatTime(vo.getStartTime());
            String endTime = formatTime(vo.getEndTime());
            
            // 4. FullCalendar 이벤트 생성
            Map<String, Object> event = new HashMap<>();
            
            // 이벤트 ID
            event.put("id", vo.getScheduleId().toString());
            
            // 제목: "09:00-10:00\n김트레이너\n헬스장" 형태
            String title = String.format("%s-%s\n%s\n%s", 
                startTime, endTime, trainerName, facilityName);
            event.put("title", title);
            
            // 시작/종료 시간 (ISO 8601 형식)
            LocalDateTime startDT = LocalDateTime.of(vo.getScheduleDate(), vo.getStartTime());
            LocalDateTime endDT = LocalDateTime.of(vo.getScheduleDate(), vo.getEndTime());
            event.put("start", startDT.toString());
            event.put("end", endDT.toString());
            
            // 시설별 색상 설정
            event.put("backgroundColor", getFacilityColor(vo.getFacilityId()));
            event.put("borderColor", getFacilityColor(vo.getFacilityId()));
            event.put("textColor", "#ffffff");
            
            // 확장 속성 (수정/삭제 시 필요한 정보)
            Map<String, Object> extendedProps = new HashMap<>();
            extendedProps.put("scheduleId", vo.getScheduleId());
            extendedProps.put("username", vo.getUsername());
            extendedProps.put("trainerName", trainerName);
            extendedProps.put("facilityId", vo.getFacilityId());
            extendedProps.put("facilityName", facilityName);
            extendedProps.put("scheduleDate", vo.getScheduleDate().toString());
            extendedProps.put("startTime", startTime);
            extendedProps.put("endTime", endTime);
            event.put("extendedProps", extendedProps);
            
            events.add(event);
        }
        
        return events;
    }
    
    /**
     * 시설 ID를 시설명으로 변환
     */
    private String getFacilityName(Long facilityId) {
        if (facilityId == null) return "미지정";
        
        switch (facilityId.intValue()) {
            case 1: return "복싱장";
            case 2: return "헬스장";
            case 3: return "수영장";
            default: return "시설" + facilityId;
        }
    }
    
    /**
     * 시설별 색상 지정
     */
    private String getFacilityColor(Long facilityId) {
        if (facilityId == null) return "#95a5a6";
        
        switch (facilityId.intValue()) {
            case 1: return "#e74c3c"; // 복싱장 - 빨간색
            case 2: return "#3498db"; // 헬스장 - 파란색
            case 3: return "#2ecc71"; // 수영장 - 초록색
            default: return "#95a5a6"; // 기본 - 회색
        }
    }
    
    /**
     * LocalTime을 HH:MM 형태 문자열로 변환
     */
    private String formatTime(java.time.LocalTime time) {
        if (time == null) return "00:00";
        return time.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    /**
     * 5) 일정 생성 (관리자만)
     *    POST /schedule/create
     *    → 생성 후 FullCalendar용 이벤트 형태로 반환
     */
    @PostMapping("/create")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public Map<String, Object> createSchedule(@RequestBody ScheduleVO vo) {
        // 일정 생성
        scheduleService.createSchedule(vo);
        
        // 생성된 일정을 FullCalendar 이벤트 형태로 변환하여 반환
        List<ScheduleVO> createdSchedule = Arrays.asList(vo);
        List<Map<String, Object>> events = convertToCalendarEvents(createdSchedule);
        
        return events.isEmpty() ? new HashMap<>() : events.get(0);
    }

    /**
     * 7) 일정 삭제 (관리자만)
     *    DELETE /schedule/delete/{id}
     */
    @DeleteMapping("/delete/{id}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public String deleteSchedule(@PathVariable("id") Long id) {
        scheduleService.deleteSchedule(id);
        return "OK";
    }
    
    
    
    
    
    
}