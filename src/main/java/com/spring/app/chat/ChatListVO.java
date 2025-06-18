package com.spring.app.chat;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ChatListVO {
	
	private Long roomId;
	private String roomName;
	private String message;
	private String createdAt;
	private String senderId;
	private Long unread;

}
