package com.spring.app.payment;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PaymentVO {
	
	private String paymentKey;
	private String username;
	private Long subscriptId;
	private String billingKey;
	private String method;
	private BigDecimal amount;
	private String paymentStatus;
	private LocalDateTime requestedAt;
	private LocalDateTime approvedAt;
	private String failReason;
	private LocalDateTime createdAt;
	

}
