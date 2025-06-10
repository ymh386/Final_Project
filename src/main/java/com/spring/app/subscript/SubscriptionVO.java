package com.spring.app.subscript;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SubscriptionVO {
	
	private Long subscriptionId;
	private String subscriptionName;
	private Long days;
	private BigDecimal price;
	private String subscriptionContents;
	private Boolean isActive;

}
