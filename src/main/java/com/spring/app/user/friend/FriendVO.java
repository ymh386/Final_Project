package com.spring.app.user.friend;

import java.time.LocalDateTime;

import com.spring.app.user.UserVO;

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
	
	private String sns;
	private String fileName;
	private UserVO userVO;

}
