package com.spring.app.websocket;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.home.util.Pager;
import com.spring.app.user.UserVO;

@Controller
@RequestMapping("/notification/*")
public class NotificationController {
	
	@Autowired
	private NotificationService notificationService;
	
	
	
	@GetMapping("unread")
	@ResponseBody
	public List<NotificationVO> getUnreadList(@AuthenticationPrincipal UserVO userVO) throws Exception {
		List<NotificationVO> ar = notificationService.getUnread(userVO);
		
		return ar;
	}
	
	@PostMapping("read")
	@ResponseBody
	public int updateIsRead(@AuthenticationPrincipal UserVO userVO, NotificationVO notificationVO) throws Exception {
		notificationVO.setUsername(userVO.getUsername());
		
		int result = notificationService.updateIsRead(notificationVO);
		
		return result;
	}
	
	@GetMapping("unreadCount")
	@ResponseBody
	public Long getUnreadCount(@AuthenticationPrincipal UserVO userVO) throws Exception {
		NotificationVO notificationVO = new NotificationVO();
		notificationVO.setUsername(userVO.getUsername());
		
		Long count = notificationService.getUnreadCount(notificationVO);
		
		return count;
	}
	
	@GetMapping("list")
	public String getList(@AuthenticationPrincipal UserVO userVO, NotificationVO notificationVO, Pager pager, Model model) throws Exception {
		notificationVO.setUsername(userVO.getUsername());
		System.out.println("read " + notificationVO.getRead());
		
		List<NotificationVO> ar = notificationService.getList(notificationVO, pager);
		model.addAttribute("ar", ar);
		model.addAttribute("pager", pager);
		model.addAttribute("read", notificationVO.getRead());
		
		return "notification/list";
	}

}
