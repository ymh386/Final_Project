package com.spring.app.chat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChatService {
	
	@Autowired
	private ChatDAO chatDAO;
	
	public List<ChatRoomVO> getRoomList(String username) throws Exception {
		List<ChatRoomVO> list = chatDAO.getRoomList(username);
		
		return list;
	}
	
	public int makeChat(ChatRoomVO chatRoomVO) throws Exception {
		int result = chatDAO.makeChat(chatRoomVO);
		
		return result;
	}
	
	public int makeRoom(ChatRoomVO chatRoomVO) throws Exception {
		int result = chatDAO.makeRoom(chatRoomVO);
		
		return result;
	}
	
	public Long insertMember(List<String> usernames) throws Exception {
		
		ChatRoomVO chatRoomVO = new ChatRoomVO();
		
		int person = usernames.size()-1;
		
		chatRoomVO.setRoomName(usernames.get(0)+"님 외 "+person+"명");
		
		chatDAO.makeRoom(chatRoomVO);
		
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
