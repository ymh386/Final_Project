package com.spring.app.chat;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class MessageVO {
	
	private Long messageId;
	private Long roomId;
	private String contents;
	private String messageType;
	private Date createdAt;
	private String username;
}
