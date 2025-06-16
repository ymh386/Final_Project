package com.spring.app.chat;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ChatMessage {
	
	private Long roomId;
	private String sender;
	private String message;
	private LocalDateTime createdAt;

}
