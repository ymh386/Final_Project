package com.spring.app.chat;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ChatRoomVO {
	
	private Long roomId;
	private String roomName;
	private String roomType;
	private LocalDateTime createdAt;
	private String createdBy;
	private String username;
	private LocalDateTime joinedAt;
	private Long lastReadMessage;
	
	private RoomMemberVO roomMemberVO;
	
	private List<ChatMessageVO> messgaeList;
	private List<RoomMemberVO> roomMemberList;
}
