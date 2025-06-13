package com.spring.app.chat;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ChatDAO {
	
	List<ChatRoomVO> getRoomList(@Param("username") String username) throws Exception;
	
	int makeChat(ChatRoomVO chatRoomVO) throws Exception;
	
	int makeRoom(ChatRoomVO chatRoomVO) throws Exception;
	
	int insertMember(RoomMemberVO memberVO) throws Exception;
	
}
