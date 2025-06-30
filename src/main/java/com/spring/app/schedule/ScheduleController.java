package com.spring.app.schedule;

import java.security.Principal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.spring.app.auditLog.AuditLogService;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;
import com.spring.app.websocket.NotificationManager;

import jakarta.servlet.http.HttpServletRequest;

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
    
    @Autowired
    private NotificationManager notificationManager;

    @Autowired
    private AuditLogService auditLogService;
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
        return scheduleService.convertToCalendarEvents(list);
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
        return scheduleService.convertToCalendarEvents(list);
    }

    

    

    @PostMapping("/create")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public Map<String, Object> createSchedule(@AuthenticationPrincipal UserVO userVO, @RequestBody ScheduleVO vo, HttpServletRequest request) {
        // 일정 생성
        scheduleService.createSchedule(vo);
        
        // 생성된 일정을 FullCalendar 이벤트 형태로 변환하여 반환
        List<ScheduleVO> createdSchedule = Arrays.asList(vo);
        List<Map<String, Object>> events =scheduleService.convertToCalendarEvents(createdSchedule);
        
        // 일정 부여 시 알림 전송
        try {
			notificationManager.scheduleNotification(vo);
			
			// 로그/감사 기록용
			auditLogService.log(
					userVO.getUsername(),
			        "CREATE_SCHEDULE",
			        "SCHEDULE",
			        vo.getScheduleId().toString(),
			        "admin이 " + vo.getScheduleDate() + "에 "
			        + vo.getUsername() + "의 일정을 "
			        + vo.getStartTime() + "부터 " + vo.getEndTime() + "까지로 추가",
			        request
			    );
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
		
        
        return events.isEmpty() ? new HashMap<>() : events.get(0);
    }

    /**
     * 7) 일정 삭제 (관리자만)
     *    DELETE /schedule/delete/{id}
     */
    @DeleteMapping("/delete/{id}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public String deleteSchedule(@AuthenticationPrincipal UserVO userVO, @PathVariable("id") Long id, HttpServletRequest request) {
    	ScheduleVO scheduleVO = scheduleService.selectOneUsername(id);
    	
    	// 일정 취소 시 알림 전송
    	try {
			notificationManager.cancelScheduleNotification(scheduleVO);
			
			// 로그/감사 기록용
			auditLogService.log(
					userVO.getUsername(),
			        "DELETE_SCHEDULE",
			        "SCHEDULE",
			        id.toString(),
			        "admin이 " + scheduleVO.getScheduleDate() + "에 "
			        + scheduleVO.getUsername() + "의 일정을 취소",
			        request
			    );
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
        scheduleService.deleteSchedule(id);
        return "OK";
    }
    
    
    
    
    
    
}