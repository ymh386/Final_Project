package com.spring.app.chat;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.user.UserVO;
import com.spring.app.user.friend.FriendService;
import com.spring.app.user.friend.FriendVO;

@Controller
@RequestMapping("/chat/*")
public class ChatController {
	
	@Autowired
	private FriendService friendService;
	
	@Autowired
	private ChatService chatService;
	
	@GetMapping("chat")
	public void makeChat(@AuthenticationPrincipal UserVO userVO
			 , FriendVO friendVO, Model model) throws Exception {

		friendVO.setUser1(userVO.getUsername());
		
		List<FriendVO> list = friendService.friendList(userVO.getUsername());
		for (FriendVO friend : list) {
			System.out.println("friend : "+friend);
		}
		model.addAttribute("list", list);
	}
	
	@GetMapping("room")
	public void makeRoom(@AuthenticationPrincipal UserVO userVO
			 , FriendVO friendVO, Model model) throws Exception {

		friendVO.setUser1(userVO.getUsername());
		
		List<FriendVO> list = friendService.friendList(userVO.getUsername());
		for (FriendVO friend : list) {
			System.out.println("friend : "+friend);
		}
		model.addAttribute("list", list);
	}
	
	@PostMapping("makeRoom")
	@ResponseBody
	public Map<String, Object> createGroupChat(@RequestBody Map<String, List<String>> body,
											   @AuthenticationPrincipal UserVO userVO) throws Exception {
		
		List<String> selectedUsers = body.get("users");
		selectedUsers.add(userVO.getUsername());
		
		Long roomId = chatService.insertMember(selectedUsers);
		
		return Map.of("roomId", roomId);
	}
	
	@PostMapping("createdChat")
	public void createChat(@AuthenticationPrincipal UserVO userVO) throws Exception {
		
		
	}
	
	@GetMapping("list")
	public void roomList(@AuthenticationPrincipal UserVO userVO, Model model
			           , ChatRoomVO chatRoomVO) throws Exception {
		
		chatRoomVO.setUsername(userVO.getUsername());
		List<ChatRoomVO> list = chatService.getRoomList(userVO.getUsername());
		
		model.addAttribute("list", list);
	}

}
