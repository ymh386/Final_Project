package com.spring.app.payment;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PaymentResultVO {
	
	private String username;
	private Long subscriptionId;
    private String paymentKey;
    private String method;
    private BigDecimal amount;
    private String paymentStatus;
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalDateTime approvedAt;

}
