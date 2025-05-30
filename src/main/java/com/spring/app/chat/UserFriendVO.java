package com.spring.app.chat;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class UserFriendVO {
	
	private String friendId;
	private String requesterId;
	private String receiverId;
	private String status;
	private Date createdAt;
	private Date updatedAt;
}
