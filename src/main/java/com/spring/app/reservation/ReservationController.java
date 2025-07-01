package com.spring.app.reservation;

import java.security.Principal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;
import com.spring.app.websocket.NotificationManager;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.app.auditLog.AuditLogService;
import com.spring.app.home.util.Pager;
import com.spring.app.schedule.ScheduleService;
import com.spring.app.schedule.ScheduleVO;

@Controller
@RequestMapping("/reservation")
public class ReservationController {

    private final UserService userService;

    @Autowired
    private ReservationService reservationService;
    @Autowired
    private ScheduleService   scheduleService;

    ReservationController(UserService userService) {
        this.userService = userService;
    }
    
    
    //일반회원 예약 내역 
    @GetMapping("/events")
    @ResponseBody
    public List<Map<String, Object>> events(Principal principal) {
        return reservationService.getEvent(principal.getName());
    }
    
    
    
    
    
    
    /** 1) 예약 폼 보여주기 (트레이너 목록 + 미래 일정만) */
    @GetMapping("/book")
    public String showBookingForm(Model model) {
        // 트레이너 목록 (아이디가 T로 시작하는 유저)
        List<UserVO> trainers = userService.getUsersByUsernamePrefix("T%");
        model.addAttribute("trainerList", trainers);

        // 과거 일정 제외한 미래 일정만
        List<ScheduleVO> futureSchedules = reservationService.getFutureSchedules();
        model.addAttribute("schedules", futureSchedules);
        System.out.println("트레이너 수: " + trainers.size());
        return "reservation/book";
    }

    /** 2) 예약 처리 */
    @PostMapping("/book")
    public String reserve(
            @ModelAttribute ReservationVO vo,
            RedirectAttributes rttr,
            Model model, HttpServletRequest request) {

        // JWT로부터 사용자 아이디 추출
        String username = SecurityContextHolder
            .getContext()
            .getAuthentication()
            .getName();
        vo.setUsername(username);

        try {
            // 예약 시도 (중복 체크 포함)
            reservationService.reserve(vo, request);

            // 성공 시 메시지 전달 후 이동
            rttr.addFlashAttribute("msg", "예약이 완료되었습니다.");
            return "redirect:/reservation/my";

        } catch (IllegalStateException ex) {
            // 실패 시 에러 메시지와 함께 다시 폼 렌더링
            model.addAttribute("err", ex.getMessage());
            model.addAttribute("trainerList", userService.getUsersByUsernamePrefix("T%"));
            model.addAttribute("schedules", reservationService.getFutureSchedules());
            return "reservation/book";
        }
    }



    /** 4) 예약 상세 조회 */
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable("id") Long reservationId, Model model) {
        ReservationVO vo = reservationService.getReservation(reservationId);
        model.addAttribute("reservation", vo);
        return "reservation/detail";
    }
    
    @GetMapping("/my")
    public String myReservations(
            @RequestParam(defaultValue = "1") int page,
            Model model) {
        
        String username = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        // Pager 객체 생성 및 설정
        Pager pager = new Pager();
        pager.setCurPage(page);
        pager.setPerPage(5);
        pager.setPerBlock(5);
        pager.makeRow();

        // 전체 예약 개수
        long totalCount = reservationService.getTotalReservationCount(username);
        pager.makePage(totalCount);

        // 예약 목록 조회
        List<ReservationVO> list = reservationService.getReservationsByUsername(
                username, pager.getStartRow(), pager.getPageSize());

        // 스케줄 및 트레이너 정보 조회
        List<ScheduleVO> schedules = scheduleService.getAllSchedules();
        List<UserVO> trainerList = userService.getUsersByUsernamePrefix("T%");

        // ✅ 이번 달 예약 횟수 & 가능 횟수 계산
        long monthlyCount = reservationService.countByUsernameAndMonth(username);
        long maxMonthly = 15;
        long remaining = Math.max(0, maxMonthly - monthlyCount);

        // model에 담기
        model.addAttribute("list", list);
        model.addAttribute("pager", pager);
        model.addAttribute("schedules", schedules);
        model.addAttribute("trainerList", trainerList);
        model.addAttribute("monthlyCount", monthlyCount);
        model.addAttribute("remainingCount", remaining);

        return "reservation/myList";
    }

    

    /** 5) 일정별 예약 목록 */
    @GetMapping("/schedule/{scheduleId}")
    public String listBySchedule(@PathVariable Long scheduleId, Model model) {
        List<ReservationVO> list = reservationService.getReservationsBySchedule(scheduleId);
        model.addAttribute("list", list);
        return "reservation/list";
    }

    /** 6) 예약 취소 처리 */
    @PostMapping("/cancel")
    public String cancel(
            @RequestParam Long reservationId,
            @RequestParam String canceledReason,
            RedirectAttributes rttr, HttpServletRequest request) {
    	
        ReservationVO before = reservationService.getReservation(reservationId);

        // cancel() 내부에서 scheduleId를 VO에 세팅하도록 구현되어 있어야 합니다.
        ReservationVO vo = new ReservationVO();
        vo.setReservationId(reservationId);
        vo.setCanceledReason(canceledReason);
        vo.setScheduleId(before.getScheduleId());

        reservationService.cancel(vo, request);
        rttr.addFlashAttribute("msg", "예약이 취소되었습니다.");
        return "redirect:/reservation/my";

    }
}
