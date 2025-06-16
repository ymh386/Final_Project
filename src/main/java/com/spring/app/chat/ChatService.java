package com.spring.app.chat;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

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
	
	public void saveMessage(ChatMessageVO message) throws Exception {
		
		chatDAO.insertMessage(message);
	}
	
	public int renameRoom(String roomName, Long roomId) throws Exception {
		int result = chatDAO.renameRoom(roomId, roomName);
		
		return result;
	}
	
	public Long insertMemberRoom(List<String> usernames, boolean isGroup) throws Exception {
		
		if (!isGroup && usernames.size()==2) {
			Long exist = chatDAO.findRoom(usernames.get(0), usernames.get(1));
			
			if (exist!=null) {
				return exist;
			}
		}
		
		ChatRoomVO chatRoomVO = new ChatRoomVO();
		
		if (isGroup) {
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			String username = auth.getName();
			
			int person = usernames.size()-1;
			chatRoomVO.setCreatedBy(username);
			chatRoomVO.setRoomName(usernames.get(0)+"님 외 "+person+"명");	
			chatDAO.makeRoom(chatRoomVO);
		}else {
			chatRoomVO.setRoomName(usernames.get(1));
			chatDAO.makeChat(chatRoomVO);
		}
		
		
		for (String username : usernames) {
			RoomMemberVO memberVO = new RoomMemberVO();
			memberVO.setRoomId(chatRoomVO.getRoomId());
			memberVO.setUsername(username);
			chatDAO.insertMember(memberVO);
		}
		System.out.println("0번째"+usernames.get(0));
		
		return chatRoomVO.getRoomId();
	}

}
