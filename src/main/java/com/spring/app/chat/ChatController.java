package com.spring.app.chat;

import java.sql.Date;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.user.UserVO;
import com.spring.app.user.friend.FriendService;
import com.spring.app.user.friend.FriendVO;

@Controller
@RequestMapping("/chat")
public class ChatController {
	
	@Autowired
	private FriendService friendService;
	
	@Autowired
	private ChatService chatService;
	
	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	
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
		
		Long roomId = chatService.insertMemberRoom(selectedUsers, true);
		
		return Map.of("roomId", roomId);
	}
	
	@PostMapping("makeChat")
	@ResponseBody
	public Map<String, Object> createSingleChat(@RequestBody Map<String, String> body,
			                                    @AuthenticationPrincipal UserVO userVO) throws Exception {
		
		System.out.println("makeChat 컨트롤러 진입");
		String me = userVO.getUsername();
		String target = body.get("target");
		Long roomId = chatService.insertMemberRoom(List.of(me, target), false);
		
		return Map.of("roomId", roomId);
	}
	
	@GetMapping("list")
	public void roomList(@AuthenticationPrincipal UserVO userVO, Model model
			           , ChatRoomVO chatRoomVO, ChatMessageVO chatMessageVO) throws Exception {
		
		chatRoomVO.setUsername(userVO.getUsername());
		List<ChatRoomVO> list = chatService.getRoomList(userVO.getUsername());
		
		model.addAttribute("list", list);
	}
	
	@GetMapping("detail/{roomId}")
	public String roomDetail(@AuthenticationPrincipal UserVO userVO,
			 			   @PathVariable Long roomId, Model model) throws Exception {
		
		ChatRoomVO room = chatService.getRoomDetail(roomId);
		List<ChatMessageVO> list = chatService.getMessageByRoom(roomId);
		List<RoomMemberVO> members = chatService.getUserByRoom(roomId);
		
		model.addAttribute("members", members);
		model.addAttribute("room", room);
		model.addAttribute("msg", list);
		model.addAttribute("host", room.getCreatedBy());
		
		return "chat/detail";
	}
	
	@MessageMapping("/chat.sendMessage")
	public void sendMessage(ChatMessageVO message) throws Exception {
		
		LocalDateTime now = LocalDateTime.now();
		
		int hour=now.getHour();
		int min = now.getMinute();
		String day = "오전";
		
		String time = "";
		
		if (hour>12) {
			day="오후";
			hour=hour-12;
			if (min<10) {
				time=day+" "+hour+":"+"0"+min;	
			}else {
				time=day+" "+hour+":"+min;				
			}
		}else {
			if (min<10) {
				time=day+" "+hour+":"+"0"+min;	
			}else {
				time=day+" "+hour+":"+min;				
			}
		}
		System.out.println(min);
		System.out.println(time);
		
		message.setCreatedAt(time);
		message.setMessageType("TEXT");
		System.out.println("message : "+message);
		
		chatService.saveMessage(message);
		messagingTemplate.convertAndSend(
				"/topic/chat/"+message.getRoomId(), message);
	}
	
	@PostMapping("kick")
	public String kickUser(@AuthenticationPrincipal UserVO userVO, @RequestParam("roomId") Long roomId 
						 , @RequestParam("username") String username, RoomMemberVO memberVO, Model model) throws Exception {
		
		ChatRoomVO roomVO=chatService.getRoomDetail(roomId);
		String host = roomVO.getCreatedBy();
		
		if (host!=userVO.getUsername()) {
			model.addAttribute("result", "강퇴 권한이 없습니다. 방장에게 문의하세요.");
			model.addAttribute("path", "/chat/detail/"+roomId);
		}else {
			memberVO.setUsername(username);
			memberVO.setRoomId(roomId);
			
			chatService.outUser(memberVO);
			
			model.addAttribute("result", "강퇴에 성공했습니다.");
			model.addAttribute("path", "/chat/detail/"+roomId);			
		}
		
		return "commons/result";
	}
	
	@PostMapping("out")
	public void out(@AuthenticationPrincipal UserVO userVO, @RequestParam("roomId") Long roomId
			        , RoomMemberVO memberVO, Model model) throws Exception {
		
		memberVO.setUsername(userVO.getUsername());
		memberVO.setRoomId(roomId);
		
		chatService.outUser(memberVO);
	}

}
