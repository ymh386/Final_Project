package com.spring.app.payment;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.spring.app.auditLog.AuditLogService;
import com.spring.app.subscript.SubscriptDAO;
import com.spring.app.subscript.SubscriptService;
import com.spring.app.subscript.SubscriptVO;
import com.spring.app.subscript.SubscriptionVO;
import com.spring.app.user.MemberStateVO;
import com.spring.app.user.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;

@Service
public class PaymentService {
	
	@Autowired
	private PaymentDAO paymentDAO;
	
	@Autowired
	private SubscriptDAO subscriptDAO;
	
	@Autowired
	private SubscriptService subscriptService;
	
	@Autowired
	private UserService userService;
	
	
	@Value("${toss.secret.key}")
	private String secretKey;
	
	@Transactional
	public void registerCard(String customerKey, String authKey) throws Exception {
		HttpHeaders header = new HttpHeaders();
		header.setBasicAuth(secretKey, "");
		header.setContentType(MediaType.APPLICATION_JSON);
		
		Map<String, Object> body = Map.of("customerKey", customerKey, "authKey", authKey);
		
		HttpEntity<Map<String, Object>> map = new HttpEntity<>(body, header);
		
		Map<String, Object> res = new RestTemplate()
				.postForEntity("https://api.tosspayments.com/v1/billing/authorizations/issue", map, Map.class).getBody();
		
		String billingKey = res.get("billingKey").toString();
		String cardName = res.get("cardCompany").toString();
		String cardNum = res.get("cardNumber").toString();
		
		BillingVO billingVO = new BillingVO();
		
		billingVO.setCardname(cardName);
		billingVO.setCardNumberMasked(cardNum);
		billingVO.setBillingKey(billingKey);
		billingVO.setUsername(customerKey);
		billingVO.setIsActive(true);
		
		BillingVO exist = paymentDAO.getBillingByCard(customerKey, cardNum);
		
		if (exist != null) {
			paymentDAO.updateBilling(exist.getBillingId(), billingKey, LocalDateTime.now());
		}else {
			paymentDAO.newBilling(billingVO);			
		}
	}
	
	@Transactional
	public PaymentResultVO approve(String customerKey, Long subscriptionId) throws Exception {
		HttpHeaders header = new HttpHeaders();
		header.setBasicAuth(secretKey, "");
		header.setContentType(MediaType.APPLICATION_JSON);
		
		MemberStateVO memberStateVO = new MemberStateVO();
		
		memberStateVO=userService.checkSubscript(customerKey);
		
		if (memberStateVO.getStateNum()!=1) {
			userService.startSubscript(memberStateVO);	
		}
		
		BillingVO billingVO = paymentDAO.getBilling(customerKey);
		SubscriptionVO subscriptionVO = subscriptDAO.getPlansDetail(subscriptionId);
		
		Map<String, Object> body = Map.of(
				"billingKey", billingVO.getBillingKey(),
				"customerKey", customerKey,
				"orderId", "SUB-"+UUID.randomUUID(),
				"orderName", subscriptionVO.getSubscriptionName(),
				"amount", subscriptionVO.getPrice().intValue());
		
		HttpEntity<Map<String, Object>> map = new HttpEntity<>(body, header);
		
		Map<String, Object> res = new RestTemplate()
				.postForEntity("https://api.tosspayments.com/v1/billing/"+billingVO.getBillingKey(), map, Map.class).getBody();
		
		PaymentVO paymentVO = new PaymentVO();
		
		System.out.println("res : "+res);
		
		String t = res.get("requestedAt").toString();
		OffsetDateTime t2 = OffsetDateTime.parse(t);
		LocalDateTime time = t2.toLocalDateTime();
		
		LocalDate lastEndDate = subscriptDAO.getEndDate(customerKey);
		LocalDate now = LocalDate.now();
		Long day = subscriptDAO.getPlansDetail(subscriptionId).getDays();
		System.out.println("day : "+day);
		LocalDate startDate = (lastEndDate!=null&&lastEndDate.isAfter(now.minusDays(1))) ? lastEndDate : now;
		
		System.out.println("startDate : "+startDate);
		LocalDate endDate = startDate.plusDays(day);
		
		System.out.println("endDate : "+endDate);
	
		SubscriptVO subscriptVO = new SubscriptVO();

		subscriptVO.setSubscriptionId(subscriptionId);
		subscriptVO.setSubscriptId(subscriptDAO.getNextId());
		subscriptVO.setUsername(customerKey);
		subscriptVO.setSubscriptStatus("ACTIVE");
		subscriptVO.setStartDate(startDate);
		subscriptVO.setEndDate(endDate);
		subscriptVO.setCreatedAt(LocalDateTime.now());
		
		subscriptService.createSubscription(subscriptVO);
		
		paymentVO.setPaymentKey(res.get("paymentKey").toString());
		paymentVO.setUsername(customerKey);
		paymentVO.setSubscriptId(subscriptVO.getSubscriptId());
		paymentVO.setBillingKey(billingVO.getBillingKey());
		paymentVO.setMethod(res.get("method").toString());
		paymentVO.setAmount(new BigDecimal(body.get("amount").toString()));
		paymentVO.setPaymentStatus(res.get("status").toString());
		paymentVO.setRequestedAt(time);
		paymentVO.setApprovedAt(LocalDateTime.now());
		
		paymentDAO.newPayment(paymentVO);
		
		PaymentResultVO paymentResultVO = new PaymentResultVO();
		
		paymentResultVO.setUsername(customerKey);
		paymentResultVO.setSubscriptionId(subscriptVO.getSubscriptionId());
		paymentResultVO.setPaymentKey(paymentVO.getPaymentKey());
		paymentResultVO.setMethod(paymentVO.getMethod());
		paymentResultVO.setAmount(paymentVO.getAmount());
		paymentResultVO.setPaymentStatus(paymentVO.getPaymentStatus());
		paymentResultVO.setStartDate(subscriptVO.getStartDate());
		paymentResultVO.setEndDate(subscriptVO.getEndDate());
		paymentResultVO.setApprovedAt(paymentVO.getApprovedAt());
		
		return paymentResultVO;
	}
	
	public BillingVO getBilling(String username) throws Exception {
		return paymentDAO.getBilling(username);
	}
	
	

}
