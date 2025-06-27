package com.spring.app.home;

import java.time.LocalDate;
import java.time.Month;
import java.time.ZoneId;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.spring.app.chart.AttendanceStatVO;
import com.spring.app.chart.ChartService;
import com.spring.app.payment.PaymentDAO;
import com.spring.app.subscript.SubscriptService;
import com.spring.app.user.MemberRoleVO;
import com.spring.app.user.MemberStateVO;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;



@Controller
public class HomeController {
	
	@Autowired
	private SubscriptService subscriptService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private ChartService chartService;
	
	@GetMapping("/")
	public String home(@AuthenticationPrincipal UserVO userVO, Model model) throws Exception {
		if(userVO != null) {
			//현재 년, 월
			Integer year = LocalDate.now(ZoneId.of("Asia/Seoul")).getYear();
			Integer month = LocalDate.now(ZoneId.of("Asia/Seoul")).getMonthValue();
			
			//차트 정보
			AttendanceStatVO attendanceStatVO = chartService.getCurrentMonthStats(year, month, userVO.getUsername());
			model.addAttribute("attendanceStat", attendanceStatVO);
			//차트만들때 필요한 정보들
			model.addAttribute("year", year);
			model.addAttribute("month", month);
		}
		
		return "index";
	}

}
