package com.spring.app.chat;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ChatMessageVO {
	
	private Long messageId;
	private Long roomId;
	private String contents;
	private String messageType;
	private LocalDateTime createdAt;
	private String username;
	

}
