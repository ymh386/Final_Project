package com.spring.app.chat;

import java.time.LocalDateTime;
import java.util.List;

public class ChatRoomVO {
	
	private Long roomId;
	private String roomName;
	private String roomType;
	private LocalDateTime createdAt;
	
	private List<ChatMessageVO> messgaeList;
	private List<RoomMemberVO> roomMemberList;
}
