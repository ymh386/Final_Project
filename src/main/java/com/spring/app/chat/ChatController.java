package com.spring.app.chat;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.app.attendance.AttendanceController;
import com.spring.app.attendance.AttendanceService;
import com.spring.app.auditLog.AuditLogService;
import com.spring.app.files.FileManager;
import com.spring.app.user.UserVO;
import com.spring.app.user.friend.FriendService;
import com.spring.app.user.friend.FriendVO;
import com.spring.app.websocket.NotificationManager;
import com.spring.app.websocket.StompSessionEventListener;

import lombok.extern.slf4j.Slf4j;
import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/chat")
@Slf4j
public class ChatController {

    private final AttendanceService attendanceService;

    private final AttendanceController attendanceController;
    
	@Autowired
	private NotificationManager notificationManager;
	
	@Autowired
	private FriendService friendService;
	
	@Autowired
	private ChatService chatService;
	
	@Autowired
	private SimpMessagingTemplate messagingTemplate;

	@Autowired
	private StompSessionEventListener sessionEventListener;

	@Value("${board.file.path}")
	private String path;
	
	@Autowired
	private FileManager fileManager;


    ChatController(AttendanceController attendanceController, AttendanceService attendanceService) {
        this.attendanceController = attendanceController;
        this.attendanceService = attendanceService;
    }
	
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
		String me = userVO.getUsername();
		String target = body.get("target");
		Long roomId = chatService.insertMemberRoom(List.of(me, target), false, request);
		
		return Map.of("roomId", roomId);
	}
	
	@GetMapping("list")
	public void roomList(@AuthenticationPrincipal UserVO userVO, Model model
			           , ChatRoomVO chatRoomVO) throws Exception {
		
		chatRoomVO.setUsername(userVO.getUsername());
		List<ChatRoomVO> list = chatService.getRoomList(userVO.getUsername());
		List<ChatListVO> ar = new ArrayList<>();
		
		for (ChatRoomVO roomVO : list) {
			ChatListVO chatListVO = new ChatListVO();
			chatListVO.setRoomId(roomVO.getRoomId());
			
			if (roomVO.getRoomType().equals("1:1 채팅")) {
				if (roomVO.getRoomName().contains(userVO.getUsername())) {
					String roomName = roomVO.getRoomName();
					String result = roomName.replace(userVO.getUsername(), "");
					chatListVO.setRoomName(result);
				}			
			}
			else {
				if (roomVO.getRoomName().contains(userVO.getUsername())) {
					String roomName = roomVO.getRoomName();
					List<RoomMemberVO> member = chatService.getUserByRoom(roomVO.getRoomId());
					for (RoomMemberVO vo : member) {
						while (true) {
							roomName=vo.getUsername();
							if (vo.getUsername()!=userVO.getUsername()) {
								break;
							}
						}
						int length = member.size()-1;
						chatListVO.setRoomName(roomName+"님 외 "+length+"명");
					}
				}else {
					chatListVO.setRoomName(roomVO.getRoomName());
				}
			}
			chatListVO.setMessage(chatService.getLastMessage(roomVO.getRoomId()));
			chatListVO.setCreatedAt(chatService.getLastMessageTime(roomVO.getRoomId()));
			chatListVO.setUnread(chatService.getUnreadMessage(userVO.getUsername(), roomVO.getRoomId()));
			
			ar.add(chatListVO);
		}
		
		model.addAttribute("list", ar);
	}
	
	@GetMapping("detail/{roomId}")
	public String roomDetail(@AuthenticationPrincipal UserVO userVO,
			 			   @PathVariable Long roomId, Model model) throws Exception {
		
		chatService.readMessage(userVO.getUsername(), roomId);
		
		List<String> friends = chatService.getUserNotInRoom(roomId, userVO.getUsername());
		ChatRoomVO room = chatService.getRoomDetail(roomId);
		if (room.getRoomType().equals("1:1 채팅")) {
			if (room.getRoomName().contains(userVO.getUsername())) {
				String roomName = room.getRoomName();
				String result = roomName.replace(userVO.getUsername(), "");
				room.setRoomName(result);
			}			
		}
		if (room.getRoomType().equals("그룹 채팅")) {
			if (room.getRoomName().contains(userVO.getUsername())) {
				String roomName = room.getRoomName();
				List<RoomMemberVO> member = chatService.getUserByRoom(room.getRoomId());
				for (RoomMemberVO vo : member) {
					while (true) {
						roomName=vo.getUsername();
						if (vo.getUsername()!=userVO.getUsername()) {
							break;
						}
					}
				}
				int length = member.size()-1;
				room.setRoomName(roomName+"님 외 "+length+"명");
			}
		}
		List<ChatMessageVO> list = chatService.getMessageByRoom(roomId);
		List<RoomMemberVO> members = chatService.getUserByRoom(roomId);
		List<FriendVO> notFriends = friendService.notfriendList(userVO.getUsername());
		List<Long> notRead = new ArrayList<>();
		List<String> img = new ArrayList<>();
		List<String> sns = new ArrayList<>();
		Map<String, Object> map = new HashMap<>();
		
		for (ChatMessageVO messageVO : list) {
			Long count = chatService.getUnreadMember(roomId, messageVO.getMessageId());
			notRead.add(count);
			String userSns = chatService.getUserSnsInRoom(messageVO.getSenderId(), roomId);
			String userImg = chatService.getUserImgInRoom(messageVO.getSenderId(), roomId);
			img.add(userImg);
			sns.add(userSns);
			}
		
		map.put("notFriend", notFriends);
		map.put("friend", friends);          
		map.put("members", members);         
		map.put("room", room);               
		map.put("msg", list);                
		map.put("host", room.getCreatedBy());
		map.put("notRead", notRead);
		map.put("sns", sns);
		map.put("img", img);
		
		model.addAttribute("map", map);
		
		return "chat/detail";
	}
	
	@PostMapping("/uploadImg")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> uploadFile(@RequestParam("file") MultipartFile img) throws Exception {
		
		String oriName = img.getOriginalFilename().toString();
		
			String file = oriName.substring(oriName.lastIndexOf(".")).toLowerCase();	

			String uuid = UUID.randomUUID().toString();

			String file2=fileManager.saveFile(path.concat("chat"), img);
		
		Map<String, Object> response = new HashMap<>();
		
		response.put("uploaded", file2);
		
		return ResponseEntity.ok(response);
	}
	
	@MessageMapping("/chat.sendFile")
	public void sendFile(ChatMessageVO message, Principal principal) throws Exception {
		
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
		message.setMessageType("IMAGE");
		
		int result = chatService.saveMessage(message);
		
		//메세지저장 성공 시 채팅방안 모든 인원에게 메세지 전송
		if(result > 0) {
			List<RoomMemberVO> ar = chatService.getUserByRoom(message.getRoomId());
			notificationManager.messageNotification(message, ar);
		}
		
		messagingTemplate.convertAndSend(
				"/topic/chat/"+message.getRoomId(), message);
		
		ChatListVO chatListVO = new ChatListVO();
		
		ChatRoomVO chatRoomVO = new ChatRoomVO();
		
		chatRoomVO=chatService.getRoomDetail(message.getRoomId());
		
		chatListVO.setRoomId(message.getRoomId());
		chatListVO.setRoomName(chatRoomVO.getRoomName());
		chatListVO.setMessage(message.getContents());
		chatListVO.setCreatedAt(message.getCreatedAt());
		chatListVO.setSenderId(message.getSenderId());
		chatListVO.setUnread(chatService.getUnreadMessage(principal.getName(), message.getRoomId()));
		
		messagingTemplate.convertAndSend("/topic/chat/list", chatListVO);
	}	
	
	@MessageMapping("/chat.sendMessage")
	public void sendMessage(ChatMessageVO message, Principal principal) throws Exception {
		
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
			String ip = sessionEventListener.getUserIp(principal.getName());
			String userAgent = sessionEventListener.getUserAgent(principal.getName());
			if(ip != null && userAgent != null) {
				auditLogService.log(
						principal.getName(),
						"SEND_MESSAGE",
						"CHAT_MESSAGE",
						message.getMessageId().toString(),
						message.getSenderId() + "이 "
								+ message.getRoomId() + "번방에서 "
								+ "\"" + message.getContents() + "\"" + "메세지를 작성",
								ip,
								userAgent
						);	
			}
		}
		
		messagingTemplate.convertAndSend(
				"/topic/chat/"+message.getRoomId(), message);
		
		ChatListVO chatListVO = new ChatListVO();
		
		ChatRoomVO chatRoomVO = new ChatRoomVO();
		
		chatRoomVO=chatService.getRoomDetail(message.getRoomId());
		
		chatListVO.setRoomId(message.getRoomId());
		chatListVO.setRoomName(chatRoomVO.getRoomName());
		chatListVO.setMessage(message.getContents());
		chatListVO.setCreatedAt(message.getCreatedAt());
		chatListVO.setSenderId(message.getSenderId());
		chatListVO.setUnread(chatService.getUnreadMessage(principal.getName(), message.getRoomId()));
		
		messagingTemplate.convertAndSend("/topic/chat/list", chatListVO);
	}
	
	@PostMapping("kick")
	public String kickUser(@AuthenticationPrincipal UserVO userVO, @RequestParam("roomId") Long roomId 
						 , @RequestParam("username") String username, RoomMemberVO memberVO, Model model, HttpServletRequest request) throws Exception {
		
		ChatRoomVO roomVO=chatService.getRoomDetail(roomId);
		String host = roomVO.getCreatedBy();
		
		if (!host.equals(userVO.getUsername())) {
			model.addAttribute("result", "강퇴 권한이 없습니다. 방장에게 문의하세요.");
			model.addAttribute("path", "/chat/detail/"+roomId);
		}else {
			memberVO.setUsername(username);
			memberVO.setRoomId(roomId);
			
			int result = chatService.outUser(memberVO);
			
			if (result>0) {
				notificationManager.kickNotification(memberVO, roomVO, username);				
			}
			
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
		
		ChatRoomVO chatRoomVO = new ChatRoomVO();
		
		chatRoomVO=chatService.getRoomDetail(roomId);
		
		if (chatRoomVO.getRoomType().equals("그룹 채팅")) {
		}
		
		RoomMemberVO memberVO = new RoomMemberVO();
		memberVO.setRoomId(roomId);
		memberVO.setUsername(username);
		
		int result = chatService.invite(memberVO);
		
		if (result>0) {
			notificationManager.inviteNotification(memberVO, chatRoomVO, userVO.getUsername(), username);			
		}
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
		
		ChatRoomVO chatRoomVO = new ChatRoomVO();
		
		chatRoomVO=chatService.getRoomDetail(roomId);
		
		int result = chatService.changeHost(createdBy, roomId);
		
		if (result>0) {
			notificationManager.getHostNotification(chatRoomVO, createdBy);			
		}
		
		model.addAttribute("result", "방장 변경 완료");
		model.addAttribute("path", "/chat/detail/"+roomId);
		
		
		return "commons/result";
	}

}
