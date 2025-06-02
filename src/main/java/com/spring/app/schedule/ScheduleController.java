package com.spring.app.schedule;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * 역할:
 *  - ROLE_TRAINER: 본인 일정(User 기준) 조회만 가능
 *  - ROLE_ADMIN  : 전체 일정 조회·생성·수정·삭제 가능
 */
@Controller
@RequestMapping("/schedule")
public class ScheduleController {

    @Autowired
    private ScheduleService scheduleService;

    // 1) 일정 관리 페이지 렌더링 (모두 접근 가능: 트레이너도, 관리자도)
    @GetMapping("/page")
    public String schedulePage() {
        return "schedule/page"; // /WEB-INF/views/schedule/page.jsp
    }

    // 2) 트레이너 본인 일정 조회 (ROLE_TRAINER 권한 혹은 ROLE_ADMIN 권한 둘 다 가능)
    //    GET /schedule/my
    @GetMapping("/my")
    @ResponseBody
    @PreAuthorize("hasAnyRole('TRAINER','ADMIN')")
    public List<ScheduleVO> getMySchedules(Principal principal) {
        String username = principal.getName();
        return scheduleService.getScheduleById(username);
    }

    // 3) 전체 일정 조회 (관리자만)
    //    GET /schedule/list
    @GetMapping("/list")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public List<Map<String, Object>> getAllSchedules() {
        List<ScheduleVO> list = scheduleService.getAllSchedules();
        List<Map<String,Object>> events = new ArrayList<>();
        for (ScheduleVO vo : list) {
            Map<String,Object> evt = new HashMap<>();
            evt.put("id", vo.getScheduleId().toString());
            evt.put("title", "Facility " + vo.getFacilityId());
            LocalDateTime startDT = LocalDateTime.of(vo.getScheduleDate(), vo.getStartTime());
            evt.put("start", startDT.toString());
            LocalDateTime endDT = LocalDateTime.of(vo.getScheduleDate(), vo.getEndTime());
            evt.put("end", endDT.toString());
            evt.put("extendedProps", Collections.singletonMap("username", vo.getUsername()));
            events.add(evt);
        }
        return events;
    }



    // 5) 일정 생성 (관리자만)
    //    POST /schedule/create
    @PostMapping("/create")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ScheduleVO createSchedule(@RequestBody ScheduleVO vo) {
        // 생성 시 CREATED_AT은 DB의 NOW()로 자동 설정되므로 VO 세팅만 해 주면 됩니다.
        scheduleService.createSchedule(vo);
        return vo; // scheduleId가 자동 할당됨
    }



    // 7) 일정 삭제 (관리자만)
    //    DELETE /schedule/delete/{id}
    @DeleteMapping("/delete/{id}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public String deleteSchedule(@PathVariable("id") Long id) {
        scheduleService.deleteSchedule(id);
        return "OK";
    }
}
