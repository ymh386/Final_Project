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

import com.spring.app.subscript.SubscriptDAO;
import com.spring.app.subscript.SubscriptService;
import com.spring.app.subscript.SubscriptVO;
import com.spring.app.subscript.SubscriptionVO;

import jakarta.transaction.Transactional;

@Service
public class PaymentService {
	
	@Autowired
	private PaymentDAO paymentDAO;
	
	@Autowired
	private SubscriptDAO subscriptDAO;
	
	@Autowired
	private SubscriptService subscriptService;
	
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
		
		SubscriptVO subscriptVO = new SubscriptVO();
		
		Long days = subscriptDAO.getPlansDetail(subscriptionId).getDays();
		subscriptVO.setSubscriptionId(subscriptionId);
		subscriptVO.setSubscriptId(subscriptDAO.getNextId());
		subscriptVO.setUsername(customerKey);
		subscriptVO.setSubscriptStatus("ACTIVE");
		subscriptVO.setStartDate(LocalDateTime.now());
		subscriptVO.setEndDate(LocalDateTime.now().plusDays(days));
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
		
		paymentResultVO.setPaymentKey(paymentVO.getPaymentKey());
		paymentResultVO.setMethod(paymentVO.getMethod());
		paymentResultVO.setAmount(paymentVO.getAmount());
		paymentResultVO.setPaymentStatus(paymentVO.getPaymentStatus());
		paymentResultVO.setStartDate(subscriptVO.getStartDate());
		paymentResultVO.setEndDate(subscriptVO.getEndDate());
		paymentResultVO.setApprovedAt(paymentVO.getApprovedAt());
		
		return paymentResultVO;
	}

}
