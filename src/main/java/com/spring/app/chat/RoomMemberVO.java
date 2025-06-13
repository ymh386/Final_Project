package com.spring.app.chat;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RoomMemberVO {
	
	private Long roomId;
	private String username;
	private LocalDateTime joinedAt;
	private Long lastReadMessage;

}
