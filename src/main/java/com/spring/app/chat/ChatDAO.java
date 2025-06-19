package com.spring.app.chat;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.spring.app.user.friend.FriendVO;

@Mapper
public interface ChatDAO {
	
	List<ChatRoomVO> getRoomList(@Param("username") String username) throws Exception;
	
	List<RoomMemberVO> getUserByRoom(@Param("roomId") Long roomId) throws Exception;
	
	List<String> getUserNotInRoom(@Param("roomId") Long roomId, @Param("username") String username) throws Exception;
	
	List<ChatMessageVO> getLastMsg(@Param("roomId") Long roomId) throws Exception;
	
	int outUser(RoomMemberVO memberVO) throws Exception;
	
	ChatRoomVO getRoomDetail(@Param("roomId") Long roomId) throws Exception;
	
	List<ChatMessageVO> getMessageByRoom(@Param("roomId") Long roomId) throws Exception;
	
	int insertMessage(ChatMessageVO chatMessageVO) throws Exception;
	
	int makeChat(ChatRoomVO chatRoomVO) throws Exception;
	
	int makeRoom(ChatRoomVO chatRoomVO) throws Exception;
	
	int insertMember(RoomMemberVO memberVO) throws Exception;
	
	int renameRoom(@Param("roomId") Long roomId, @Param("roomName") String roomName) throws Exception;
	
	int changeHost(@Param("createdBy") String createdBy, @Param("roomId") Long roomId) throws Exception;
	
	int readMessage(@Param("username") String username, @Param("roomId") Long roomId) throws Exception;
	
	Long findRoom(@Param("user1") String user1, @Param("user2") String user2) throws Exception;
	
	Long findRoomByMsg(@Param("user1") String user1, @Param("user2") String user2) throws Exception;
	
	Long getUnreadMember(@Param("roomId") Long roomId, @Param("messageId") Long lastReadMessage) throws Exception;
	
	Long getUnreadMessage(@Param("username") String username, @Param("roomId") Long roomId) throws Exception;
	
	String getLastMessageTime(@Param("roomId") Long roomId) throws Exception;
	
	String getLastMessage(@Param("roomId") Long roomId) throws Exception;	
	
	String getUserImgInRoom(@Param("username") String username, Long roomId) throws Exception;
	
	String getUserSnsInRoom(@Param("username") String username, Long roomId) throws Exception;
	
}
