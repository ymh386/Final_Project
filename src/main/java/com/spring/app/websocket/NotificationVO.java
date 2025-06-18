package com.spring.app.websocket;

import java.sql.Date;
import java.sql.Timestamp;

import com.spring.app.user.UserVO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class NotificationVO {

	private Long notificationId;
	private String username;
	private String notificationTitle;
	private String message;
	private String linkUrl;
	private String notificationType;
	private boolean read;
	private Timestamp createdAt;
	private String senderId;
	
	private UserVO userVO;
	private UserVO senderVO;
}
