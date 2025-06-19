package com.spring.app.chat;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
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
import com.spring.app.attendance.AttendanceService;
import com.spring.app.auditLog.AuditLogService;
import com.spring.app.user.UserVO;
import com.spring.app.user.friend.FriendService;
import com.spring.app.user.friend.FriendVO;
import com.spring.app.websocket.NotificationManager;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/chat")
public class ChatController {
	
	@Autowired
	private NotificationManager notificationManager;
	
	@Autowired
	private FriendService friendService;
	
	@Autowired
	private ChatService chatService;
	
	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	
	@Autowired
	private AuditLogService	auditLogService;
	
	@GetMapping("chat")
	public void makeChat(@AuthenticationPrincipal UserVO userVO
			 , FriendVO friendVO, Model model) throws Exception {

		friendVO.setUser1(userVO.getUsername());
		
		List<FriendVO> list = friendService.friendList(userVO.getUsername());
		for (FriendVO friend : list) {
		}
		model.addAttribute("list", list);
	}
	
	@GetMapping("room")
	public void makeRoom(@AuthenticationPrincipal UserVO userVO
			 , FriendVO friendVO, Model model) throws Exception {

		friendVO.setUser1(userVO.getUsername());
		
		List<FriendVO> list = friendService.friendList(userVO.getUsername());
		for (FriendVO friend : list) {
		}
		model.addAttribute("list", list);
	}
	
	@PostMapping("makeRoom")
	@ResponseBody
	public Map<String, Object> createGroupChat(@RequestBody Map<String, List<String>> body,
											   @AuthenticationPrincipal UserVO userVO, HttpServletRequest request) throws Exception {
		
		List<String> selectedUsers = body.get("users");
		selectedUsers.add(userVO.getUsername());
		
		Long roomId = chatService.insertMemberRoom(selectedUsers, true, request);
		
		return Map.of("roomId", roomId);
	}
	
	@PostMapping("makeChat")
	@ResponseBody
	public Map<String, Object> createSingleChat(@RequestBody Map<String, String> body,
			                                    @AuthenticationPrincipal UserVO userVO, HttpServletRequest request) throws Exception {
		
		System.out.println("makeChat 컨트롤러 진입");
		String me = userVO.getUsername();
		String target = body.get("target");
		Long roomId = chatService.insertMemberRoom(List.of(me, target), false, request);
		
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
		
		List<String> friends = chatService.getUserNotInRoom(roomId, userVO.getUsername());
		ChatRoomVO room = chatService.getRoomDetail(roomId);
		List<ChatMessageVO> list = chatService.getMessageByRoom(roomId);
		List<RoomMemberVO> members = chatService.getUserByRoom(roomId);
		List<FriendVO> notFriends = friendService.notfriendList(userVO.getUsername());

		
		model.addAttribute("notFriend", notFriends);
		model.addAttribute("friend", friends);
		model.addAttribute("members", members);
		model.addAttribute("room", room);
		model.addAttribute("msg", list);
		model.addAttribute("host", room.getCreatedBy());
		
		return "chat/detail";
	}
	
	@MessageMapping("/chat.sendMessage")
	public void sendMessage(ChatMessageVO message, @AuthenticationPrincipal UserVO userVO ) throws Exception {
		
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
		
		message.setCreatedAt(time);
		message.setMessageType("TEXT");
		
		int result = chatService.saveMessage(message);
		
		//메세지저장 성공 시 채팅방안 모든 인원에게 메세지 전송
		if(result > 0) {
			List<RoomMemberVO> ar = chatService.getUserByRoom(message.getRoomId());
			notificationManager.messageNotification(message, ar);
			
			// 로그/감사 기록용
			String ip = "";
			String userAgent = "WebSocket-Client";
			auditLogService.log(
					message.getSenderId(),
			        "SEND_MESSAGE",
			        "CHAT_MESSAGE",
			        message.getMessageId().toString(),
			        userVO.getUsername() + "이 "
			        + message.getRoomId() + "번방에서 "
			        + "\"" + message.getContents() + "\"" + "메세지를 작성",
			        ip,
			        userAgent
			    );
		}
		
		messagingTemplate.convertAndSend(
				"/topic/chat/"+message.getRoomId(), message);
	}
	
	@PostMapping("kick")
	public String kickUser(@AuthenticationPrincipal UserVO userVO, @RequestParam("roomId") Long roomId 
						 , @RequestParam("username") String username, RoomMemberVO memberVO, Model model, HttpServletRequest request) throws Exception {
		
		System.out.println("kick컨트롤러진입");
		
		ChatRoomVO roomVO=chatService.getRoomDetail(roomId);
		String host = roomVO.getCreatedBy();
		System.out.println("host : "+host);
		System.out.println("login : "+userVO.getUsername());
		
		if (!host.equals(userVO.getUsername())) {
			model.addAttribute("result", "강퇴 권한이 없습니다. 방장에게 문의하세요.");
			model.addAttribute("path", "/chat/detail/"+roomId);
		}else {
			memberVO.setUsername(username);
			memberVO.setRoomId(roomId);
			
			chatService.outUser(memberVO);
			
			// 로그/감사 기록용
			auditLogService.log(
					userVO.getUsername(),
			        "KICK_CHAT",
			        "CHAT_ROOM_MEMBER",
			        roomId + ", " + memberVO.getUsername(),
			        userVO.getUsername() + "이 "
			        + roomId + "번방에서 "
			        + memberVO.getUsername() + "을 강퇴",
			        request
			    );
			
			model.addAttribute("result", "강퇴에 성공했습니다.");
			model.addAttribute("path", "/chat/detail/"+roomId);			
		}
		
		return "commons/result";
	}
	
	@PostMapping("out")
	public String out(@AuthenticationPrincipal UserVO userVO, @RequestParam("roomId") Long roomId
			        , RoomMemberVO memberVO, Model model, HttpServletRequest request) throws Exception {
		
		memberVO.setUsername(userVO.getUsername());
		memberVO.setRoomId(roomId);
		
		ChatRoomVO chatRoomVO=chatService.getRoomDetail(roomId);
		String host = chatRoomVO.getCreatedBy();
		
		if (userVO.getUsername().equals(host)) {
			model.addAttribute("result", "회원님은 현재 방의 방장입니다. 참여자 목록에서 방장 변경 후 퇴장할 수 있습니다.");
			model.addAttribute("path", "/chat/detail/"+roomId);
			
			return "commons/result";
		} else {
			chatService.outUser(memberVO);
			
			// 로그/감사 기록용
			auditLogService.log(
					userVO.getUsername(),
			        "LEAVE_CHAT",
			        "CHAT_ROOM_MEMBER",
			        roomId + ", " + userVO.getUsername(),
			        userVO.getUsername() + "이 "
			        + roomId + "번방에서 퇴장",
			        request
			    );
			
			return "";
		}
		
	}
	
	@PostMapping("rename")
	public String rename(@RequestParam("roomName") String roomName, @RequestParam("roomId") Long roomId
			          , Model model) throws Exception {
		
		chatService.renameRoom(roomName, roomId);
		
		model.addAttribute("result", "채팅방 이름을 수정했습니다.");
		model.addAttribute("path", "/chat/detail/"+roomId);
		
		return "commons/result";
	}
	
	@PostMapping("invite")
	public String invite(@AuthenticationPrincipal UserVO userVO, @RequestParam("roomId") Long roomId,
			             @RequestParam("username") String username, Model model, HttpServletRequest request) throws Exception {
		
		RoomMemberVO memberVO = new RoomMemberVO();
		memberVO.setRoomId(roomId);
		memberVO.setUsername(username);
		
		int result = chatService.invite(memberVO);
		
		// 로그/감사 기록용
		if(result > 0) {
			auditLogService.log(
					userVO.getUsername(),
					"INVITE_CHAT",
					"CHAT_ROOM_MEMBER",
					memberVO.getRoomId().toString() + ", " + memberVO.getUsername(),
					userVO.getUsername() + "이 "
					+ memberVO.getRoomId() + "번방에 "
					+ memberVO.getUsername() + "를 초대",
					request
					);	
		}
		
		
		
		model.addAttribute("result", username+" 님을 초대했습니다.");
		model.addAttribute("path", "/chat/detail/"+roomId);
		
		return "commons/result";
	}
	
	@PostMapping("changeHost")
	public String changeHost(@RequestParam("createdBy") String createdBy,
			                 @RequestParam("roomId") Long roomId, Model model) throws Exception {
		
		chatService.changeHost(createdBy, roomId);
		
		model.addAttribute("result", "방장 변경 완료");
		model.addAttribute("path", "/chat/detail/"+roomId);
		
		
		return "commons/result";
	}

}
