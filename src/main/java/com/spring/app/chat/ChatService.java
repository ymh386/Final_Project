package com.spring.app.chat;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.spring.app.user.friend.FriendVO;

@Service
public class ChatService {
	
	@Autowired
	private ChatDAO chatDAO;
	
	public List<ChatRoomVO> getRoomList(String username) throws Exception {
		List<ChatRoomVO> list = chatDAO.getRoomList(username);
		
		return list;
	}
	
	public List<RoomMemberVO> getUserByRoom(Long roomId) throws Exception {
		List<RoomMemberVO> list = chatDAO.getUserByRoom(roomId);
		
		return list;
	}
	
	public List<String> getUserNotInRoom(Long roomId, String username) throws Exception {
		List<String> list = chatDAO.getUserNotInRoom(roomId, username);
		
		return list;
	}
	
	int outUser(RoomMemberVO memberVO) throws Exception {
		int result = chatDAO.outUser(memberVO);
		
		return result;
	}
	
	public ChatRoomVO getRoomDetail(Long roomId) throws Exception {
		ChatRoomVO chatRoomVO = new ChatRoomVO();
		chatRoomVO = chatDAO.getRoomDetail(roomId);
		
		return chatRoomVO;
	}
	
	public List<ChatMessageVO> getMessageByRoom(Long roomId) throws Exception {
		List<ChatMessageVO> list = chatDAO.getMessageByRoom(roomId);
		
		return list;
	}
	
	public int saveMessage(ChatMessageVO message) throws Exception {
		
		return chatDAO.insertMessage(message);
	}
	
	public int renameRoom(String roomName, Long roomId) throws Exception {
		int result = chatDAO.renameRoom(roomId, roomName);
		
		return result;
	}
	
	public int changeHost(String createdBy, Long roomId) throws Exception {
		int result = chatDAO.changeHost(createdBy, roomId);
		
		return result;
	}
	
	public int readMessage(String username, Long roomId) throws Exception {
		int result = chatDAO.readMessage(username, roomId);
		
		return result;
	}
	
	public Long insertMemberRoom(List<String> usernames, boolean isGroup) throws Exception {
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String user = auth.getName();
		ChatRoomVO chatRoomVO = new ChatRoomVO();
		
		if (!isGroup && usernames.size()==2) {
			Long exist = chatDAO.findRoom(usernames.get(0), usernames.get(1));
			if (exist!=null) {
				return exist;
			} else {
				Long exist2 = chatDAO.findRoomByMsg(usernames.get(0), usernames.get(1));
				if (exist2!=null) {
					List<RoomMemberVO> list = chatDAO.getUserByRoom(exist2);
					RoomMemberVO memberVO = new RoomMemberVO();
					
					if (!list.contains(user)){		
						memberVO.setUsername(user);
						memberVO.setRoomId(exist2);
						chatDAO.insertMember(memberVO);
					} else if (!list.contains(usernames.get(1))) {
							memberVO.setUsername(usernames.get(1));
							memberVO.setRoomId(exist2);
							chatDAO.insertMember(memberVO);
						} else {
							
					}
					return exist2;
				}
			}
		}
		
		
		if (isGroup) {
			int person = usernames.size()-1;
			chatRoomVO.setCreatedBy(user);
			chatRoomVO.setRoomName(usernames.get(0)+"님 외 "+person+"명");	
			chatDAO.makeRoom(chatRoomVO);
		}else {
			chatRoomVO.setRoomName(usernames.get(1)+usernames.get(0));
			chatDAO.makeChat(chatRoomVO);
		}
		
		for (String username : usernames) {
			RoomMemberVO memberVO = new RoomMemberVO();
			memberVO.setRoomId(chatRoomVO.getRoomId());
			memberVO.setUsername(username);
			chatDAO.insertMember(memberVO);
		}
		
		return chatRoomVO.getRoomId();
	}
	
	public Long getUnreadMessage(String username, Long roomId) throws Exception {
		Long count = chatDAO.getUnreadMessage(username, roomId);
		
		return count;
	}
	
	public Long getUnreadMember(Long roomId, Long messageId) throws Exception {
		Long count = chatDAO.getUnreadMember(roomId, messageId);
		
		return count;
	}
	
	public String getLastMessageTime(Long roomId) throws Exception {
		String time = chatDAO.getLastMessageTime(roomId);
		
		return time;
	}
	
	public String getLastMessage(Long roomId) throws Exception {
		String msg = chatDAO.getLastMessage(roomId);
		
		return msg;
	}
	
	public int invite(RoomMemberVO memberVO) throws Exception {
		int result = chatDAO.insertMember(memberVO);
		
		return result;
	}
	

}
