package com.spring.app.home;

import java.security.Principal;
import java.time.LocalDate;
import java.time.Month;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.attendance.AttendanceException;
import com.spring.app.attendance.AttendanceScheduler;
import com.spring.app.attendance.AttendanceService;
import com.spring.app.attendance.AttendanceVO;
import com.spring.app.board.notice.NoticeService;
import com.spring.app.board.notice.NoticeVO;
import com.spring.app.chart.AttendanceStatVO;
import com.spring.app.chart.ChartService;
import com.spring.app.chat.ChatRoomVO;
import com.spring.app.chat.ChatService;
import com.spring.app.payment.PaymentDAO;
import com.spring.app.reservation.ReservationService;
import com.spring.app.subscript.SubscriptService;
import com.spring.app.user.MemberRoleVO;
import com.spring.app.user.MemberStateVO;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;

import jakarta.servlet.http.HttpServletRequest;


@Controller
public class HomeController {

    private final AttendanceScheduler attendanceScheduler;
	
	@Autowired
	private NoticeService noticeService;
	
	@Autowired
	private ChartService chartService;
	
	@Autowired
	private ReservationService reservationService;
	
	@Autowired
	private ChatService chatService;
	
	@Autowired
	private AttendanceService attendanceService;

    HomeController(AttendanceScheduler attendanceScheduler) {
        this.attendanceScheduler = attendanceScheduler;
    }
	
	@GetMapping("/")
	public String home(@AuthenticationPrincipal UserVO userVO, Model model) throws Exception {
		
		List<NoticeVO> list = noticeService.noticeHome();
		
		model.addAttribute("notice", list);
		
		if(userVO != null) {
			//현재 년, 월

			List<Map<String, Object>> reservation = reservationService.reservationHome(userVO.getUsername());
			List<ChatRoomVO> chat = chatService.roomHome(userVO.getUsername());
			Integer year = LocalDate.now(ZoneId.of("Asia/Seoul")).getYear();
			Integer month = LocalDate.now(ZoneId.of("Asia/Seoul")).getMonthValue();
			
			System.out.println(chat);
			
			//차트 정보
			AttendanceStatVO attendanceStatVO = chartService.getCurrentMonthStats(year, month, userVO.getUsername());
			model.addAttribute("attendanceStat", attendanceStatVO);
			//차트만들때 필요한 정보들
			model.addAttribute("year", year);
			model.addAttribute("month", month);
			model.addAttribute("reservation", reservation);
			model.addAttribute("chat", chat);
		}
		
		return "index";
	}


}
