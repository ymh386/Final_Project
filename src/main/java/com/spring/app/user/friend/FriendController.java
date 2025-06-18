package com.spring.app.user.friend;

import java.net.http.HttpRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.spring.app.user.UserController;
import com.spring.app.user.UserVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/friend/*")
public class FriendController {

    private final UserController userController;
	
	@Autowired
	private FriendService friendService;

    FriendController(UserController userController) {
        this.userController = userController;
    }
	
	@GetMapping("list")
	public void friendList(@AuthenticationPrincipal UserVO userVO
						 , FriendVO friendVO, Model model) throws Exception {
		friendVO.setUser1(userVO.getUsername());
		
		List<FriendVO> list = friendService.friendList(userVO.getUsername());
		for (FriendVO friend : list) {
			System.out.println("friend : "+friend);
		}
		model.addAttribute("list", list);
	}
	
	@PostMapping("deleteFriend")
	public String deleteFriend(@AuthenticationPrincipal UserVO userVO
							 , @RequestParam("user1") String username, FriendVO friendVO
							 , @RequestParam("user2") String friend,  Model model) throws Exception {
		
		username=userVO.getUsername();
		
		Map<String, Object> map = new HashMap<>();
		map.put("friend", friend);
		map.put("username", username);
		
		FriendRequestVO friendRequestVO = new FriendRequestVO();
		friendRequestVO.setReceiverId(friend);
		friendRequestVO.setRequesterId(username);
		
		friendService.cleanData(friendRequestVO);
		friendService.deleteFriend(username, friend);
		
		model.addAttribute("result", "친구 리스트에서 삭제되었습니다.");
		model.addAttribute("path", "/friend/list");
		
		return "commons/result";
	}
	
	@GetMapping("receiveList")
	public void receiveList(@AuthenticationPrincipal UserVO userVO
						  , FriendRequestVO friendRequestVO, Model model) throws Exception {
		
		if (userVO!=null) {
			friendRequestVO.setReceiverId(userVO.getUsername());
			List<FriendRequestVO> list = friendService.receiveList(friendRequestVO.getReceiverId());
			model.addAttribute("list", list);
		}
	}
	
	@PostMapping("receiveList")
	public String receiveList(@AuthenticationPrincipal UserVO userVO
						  , @RequestParam("requesterId") String requesterId
						  , FriendRequestVO friendRequestVO, Model model) throws Exception {
		
		friendRequestVO.setReceiverId(userVO.getUsername());
		friendRequestVO.setRequesterId(requesterId);
		friendService.accept(friendRequestVO);
		
		FriendVO friendVO = new FriendVO();
		friendVO.setUser1(requesterId);
		friendVO.setUser2(userVO.getUsername());
		friendService.newFriend(friendVO);
		
		model.addAttribute("result", "친구 요청을 수락했습니다.");
		model.addAttribute("path", "/friend/receiveList");
		
		return "commons/result";
	}
	
	@PostMapping("rejectList")
	public String rejectList(@AuthenticationPrincipal UserVO userVO
						  , @RequestParam("requesterId") String requesterId
						  , FriendRequestVO friendRequestVO, Model model) throws Exception {
		
		friendRequestVO.setReceiverId(userVO.getUsername());
		friendRequestVO.setRequesterId(requesterId);
		friendService.cleanData(friendRequestVO);
		
		model.addAttribute("result", "친구 요청을 거절했습니다.");
		model.addAttribute("path", "/friend/receiveList");
		
		return "commons/result";
	}
	
	@GetMapping("requestList")
	public void requestList(@AuthenticationPrincipal UserVO userVO
			  , FriendRequestVO friendRequestVO, Model model) throws Exception {
		
		if (userVO!=null) {
			friendRequestVO.setRequesterId(userVO.getUsername());
			List<FriendRequestVO> list = friendService.requestList(friendRequestVO.getRequesterId());
			model.addAttribute("list", list);
		}
	}
	
	@PostMapping("requestList")
	public String requestList(@AuthenticationPrincipal UserVO userVO
							, @RequestParam("receiverId") String receiverId
							, FriendRequestVO friendRequestVO, Model model) throws Exception {
			
		if (userVO!=null) {
			friendRequestVO.setRequesterId(userVO.getUsername());
			friendRequestVO.setReceiverId(receiverId);
			friendService.cleanData(friendRequestVO);
		}
		model.addAttribute("result", "친구 요청을 취소했습니다.");
		model.addAttribute("path", "/friend/requestList");
		
		return "commons/result";
	}
	
	@GetMapping("suggestList")
	public void suggestList(@AuthenticationPrincipal UserVO userVO, FriendVO friendVO, Model model) throws Exception {
		
		if (userVO!=null) {
			friendVO.setUser1(userVO.getUsername());
			
			System.out.println(friendVO.getUser1());
			
			List<FriendVO> list = friendService.notfriendList(friendVO.getUser1());
			
			model.addAttribute("list", list);
		}
	}
	
	@PostMapping("suggestList")
	public String sendRequest(@AuthenticationPrincipal UserVO userVO
							, @RequestParam("receiverId") String receiverId
							, FriendRequestVO friendRequestVO, Model model, HttpServletRequest request) throws Exception {
		if (userVO!=null) {
			friendRequestVO.setRequesterId(userVO.getUsername());
			friendRequestVO.setReceiverId(receiverId);
			friendService.friendRequest(friendRequestVO);
		}
		
		String url=request.getHeader("referer");
		
		
		if (url.contains("chat")) {
			String[] u=url.split("/");
			Long roomId = Long.parseLong(u[5]);
			System.out.println(roomId);
			model.addAttribute("result", "친구 요청을 보냈습니다.");
			model.addAttribute("path", "/chat/detail/"+roomId);
		} else {
			model.addAttribute("result", "친구 요청을 보냈습니다.");
			model.addAttribute("path", "/friend/suggestList");			
		}
		
		return "commons/result";
	}
	

}
