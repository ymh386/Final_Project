package com.spring.app.user.friend;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class FriendRequestVO {
	
	private Long requestId;
	private String requesterId;
	private String receiverId;
	private String status;
	private LocalDateTime createdAt;
	private LocalDateTime updatedAt;

}
