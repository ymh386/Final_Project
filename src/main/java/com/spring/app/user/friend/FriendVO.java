package com.spring.app.user.friend;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class FriendVO {
	
	private String user1;
	private String user2;
	private LocalDateTime friendSince;

}
