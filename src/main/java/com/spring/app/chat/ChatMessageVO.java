package com.spring.app.chat;

import java.sql.Date;
import java.time.LocalDateTime;
import java.time.LocalTime;

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
	private String createdAt;
	private String senderId;
	

}
