package com.spring.app.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user/*")
public class UserController {
	
	@Autowired
	private UserService userService;
	
	@GetMapping("join")
	public void join() {
		
	}
	
	@PostMapping("join")
	public String join(UserVO userVO) throws Exception{
		int result = userService.join(userVO);
		
		return "redirect:../";
	}
	
	@GetMapping("login")
	public String login() {
		return "user/login";
	}
	
}
