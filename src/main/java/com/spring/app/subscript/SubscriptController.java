package com.spring.app.subscript;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.app.auditLog.AuditLogService;
import com.spring.app.payment.BillingVO;
import com.spring.app.payment.PaymentResultVO;
import com.spring.app.payment.PaymentService;
import com.spring.app.user.MemberStateVO;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/subscript/*")
public class SubscriptController {
	
	@Value("${toss.client.api.key}")
	private String tossClientKey;
	
	@Autowired
	private SubscriptService subscriptService;
	
	@Autowired
	private PaymentService paymentService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private AuditLogService auditLogService;
	
	@GetMapping("list")
	public void planList(Model model) throws Exception {
		List<SubscriptionVO> list = subscriptService.getPlans();
		
		model.addAttribute("plans", list);
		model.addAttribute("tossClientKey", tossClientKey);
	}
	
	@GetMapping("success")
	public String success(@RequestParam String authKey,
						@RequestParam String customerKey,
						@RequestParam Long subscriptionId, Model model, HttpServletRequest request) throws Exception {
		
		paymentService.registerCard(customerKey, authKey);
		
		model.addAttribute("sub", subscriptService.getPlansDetail(subscriptionId));
		
		return "payment/confirm";
	}
	
	@GetMapping("failure")
	public void fail(@RequestParam("code") String errorCode,
					@AuthenticationPrincipal UserVO userVO,
					 @RequestParam("message") String message, Model model, HttpServletRequest request) throws Exception {

		
		model.addAttribute("errorCode", errorCode);
		model.addAttribute("message", message);
		
	}
	
	@PostMapping("subscribe")
	public String subscribe(@RequestParam String customerKey,
							@RequestParam Long subscriptionId, Model model, HttpServletRequest request) throws Exception {
		PaymentResultVO result = paymentService.approve(customerKey, subscriptionId);
		
		// 로그/감사 기록용(성공)
		if(result.getPaymentKey() != null) {
			auditLogService.log(
					customerKey,
					"PAYMENT_SUCCESS",
					"PAYMENT",
					result.getPaymentKey(),
					customerKey + "이 구독권 아이디가 "
					+ result.getSubscriptionId() + "인 구독권을 "
					+ result.getAmount() + "원으로 구매",
					request
					);
			
		}else {
			// 로그/감사 기록용(실패)
			auditLogService.log(
					customerKey,
					"PAYMENT_FAIL",
					"PAYMENT",
					result.getPaymentKey(),
					customerKey + "이 구독권 아이디가 "
					+ result.getSubscriptionId() + "인 구독권을 "
					+ result.getAmount() + "원으로 구매하려다 실패",
					request
					);
		}
		
		// 로그/감사 기록용
		SubscriptVO subscriptVO = subscriptService.getSubscriptById(subscriptionId, result.getUsername());
		auditLogService.log(
				subscriptVO.getUsername(),
		        "SUBSCRIBE",
		        "MEMBER_SUBSCRIPT",
		        subscriptVO.getSubscriptId().toString(),
		        subscriptVO.getUsername() + "이 구독권 아이디가 "
		        + subscriptVO.getSubscriptionId() + "인 구독시작",
		        request
		    );
		model.addAttribute("payment", result);
		
		return "payment/result";
	}
	
	@GetMapping("cancel")
	public void cancel(@AuthenticationPrincipal UserVO userVO, Model model) throws Exception{
		model.addAttribute("user", userVO);
	}
	
	@PostMapping("cancel")
	public String cancel(@RequestParam String username, HttpServletRequest request) throws Exception {
		MemberStateVO memberStateVO=userService.checkSubscript(username);
		
		userService.cancelSubscript(memberStateVO);
		
		// 로그/감사 기록용
		auditLogService.log(
				memberStateVO.getUsername(),
		        "CANCEL_SUBSCRIBE",
		        "MEMBER_SUBSCRIPT",
		        memberStateVO.getUsername() + "의 모든 구독",
		        memberStateVO.getUsername() + "의 모든 구독 취소",
		        request
		    );
		
		return "redirect:/";
	}
	
	@GetMapping("restart")
	public void reStart(@AuthenticationPrincipal UserVO userVO, Model model) throws Exception {
		LocalDate endDate = subscriptService.getEndDate(userVO.getUsername());
		
		model.addAttribute("endDate", endDate);
		model.addAttribute("user", userVO);
	}
	
	@PostMapping("restart")
	public String reStart(@RequestParam String username, HttpServletRequest request) throws Exception {
		MemberStateVO memberStateVO=userService.checkSubscript(username);
		
		userService.startSubscript(memberStateVO);
		
		// 로그/감사 기록용
		auditLogService.log(
				memberStateVO.getUsername(),
		        "RESTART_SUBSCRIBE",
		        "MEMBER_SUBSCRIPT",
		        memberStateVO.getUsername() + "의 모든 구독",
		        memberStateVO.getUsername() + "의 모든 구독 재개",
		        request
		    );
		
		return "redirect:/";
	}
}
