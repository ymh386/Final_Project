package com.spring.app.payment;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import com.spring.app.user.MemberStateVO;
import com.spring.app.user.UserController;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Service;
import com.spring.app.attendance.AttendanceController;
import com.spring.app.subscript.SubscriptDAO;
import com.spring.app.subscript.SubscriptVO;

@Service
public class PaymentScheduleService {
	
	@Autowired
	private SubscriptDAO subscriptDAO;
	
	@Autowired
	private PaymentService paymentService;
	
	@Autowired
	private UserService userService;
	
	@Scheduled(cron = "* * * * * *")
	public void checkEndPlan() throws Exception {
		List<SubscriptVO> list = subscriptDAO.getEndingPlan();
		
		
		for (SubscriptVO subscriptVO : list) {
			System.out.println(subscriptVO.getUsername());
			
			MemberStateVO memberStateVO = userService.checkSubscript(subscriptVO.getUsername());
			Long stateNum=memberStateVO.getStateNum();
			LocalDate today = LocalDate.now();
			if (subscriptVO.getEndDate().equals(today)) {
				if (stateNum!=1) {
					userService.stopSubscript(memberStateVO);
				}else {
					subscriptDAO.deleteSubscript(subscriptVO);
					charge(subscriptVO);													
				}
			}
			
		}
	}
	
	private void charge(SubscriptVO subscriptVO) throws Exception {
		
		PaymentResultVO paymentResultVO=paymentService.approve(subscriptVO.getUsername(), subscriptVO.getSubscriptionId());
		subscriptVO.setSubscriptionId(paymentResultVO.getSubscriptionId());
		subscriptVO.setUsername(paymentResultVO.getUsername());
		
		Long id = subscriptVO.getSubscriptionId();
		

	}

}
