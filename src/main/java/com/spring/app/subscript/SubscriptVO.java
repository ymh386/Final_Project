package com.spring.app.subscript;

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
	private LocalDateTime startDate;
	private LocalDateTime endDate;
	private String subscriptStatus;
	private LocalDateTime createdAt;
	private SubscriptionVO subscriptionVO;

}
