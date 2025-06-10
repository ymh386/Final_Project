package com.spring.app.reservation;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.app.schedule.ScheduleService;
import com.spring.app.schedule.ScheduleVO;

@Controller
@RequestMapping("/reservation")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;
    @Autowired
    private ScheduleService   scheduleService;
    
    /** 1) 예약 폼 보여주기 (트레이너 목록) */
    @GetMapping("/book")
    public String showBookingForm(Model model) {
        List<String> trainers = scheduleService.getAllTrainerNames();
        model.addAttribute("trainers", trainers);
        
        List<ScheduleVO> schedules = scheduleService.getAllSchedules();
        model.addAttribute("schedules", schedules);
        
        
        return "reservation/book";
    }


    /** 3) 예약 처리 */
    @PostMapping("/book")
    public String book(@ModelAttribute ReservationVO vo, RedirectAttributes rttr) {
        // JWT에서 username 추출
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        vo.setUsername(username);

        reservationService.reserve(vo);
        rttr.addFlashAttribute("msg", "예약이 완료되었습니다.");
        return "redirect:/reservation/my";
    }

    /** 4) 예약 상세 조회 */
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable("id") Long reservationId, Model model) {
        ReservationVO vo = reservationService.getReservation(reservationId);
        model.addAttribute("reservation", vo);
        return "reservation/detail";
    }
    
    @GetMapping("/my")
    public String myReservations(Model model) {
        String username = SecurityContextHolder
                              .getContext()
                              .getAuthentication()
                              .getName();
        List<ReservationVO> list = reservationService.getReservationsByUsername(username);
        model.addAttribute("list", list);
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
            RedirectAttributes rttr) {
    	
        ReservationVO before = reservationService.getReservation(reservationId);

        // cancel() 내부에서 scheduleId를 VO에 세팅하도록 구현되어 있어야 합니다.
        ReservationVO vo = new ReservationVO();
        vo.setReservationId(reservationId);
        vo.setCanceledReason(canceledReason);
        vo.setScheduleId(before.getScheduleId());

        reservationService.cancel(vo);
        rttr.addFlashAttribute("msg", "예약이 취소되었습니다.");
        return "redirect:/reservation/my";

    }
}
