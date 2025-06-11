package com.spring.app.subscript;

import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SubscriptVO {
	
	private Long subscriptId;
	private Long subscriptionId;
	private String username;
	private LocalDate startDate;
	private LocalDate endDate;
	private String subscriptStatus;
	private LocalDateTime createdAt;
	private SubscriptionVO subscriptionVO;

}
