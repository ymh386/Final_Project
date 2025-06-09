package com.spring.app.payment;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BillingVO {
	
	private Long billingId;
	private String username;
	private String billingKey;
	private String cardname;
	private String cardNumberMasked;
	private Boolean isActive;
	private LocalDateTime createdAt;

}
