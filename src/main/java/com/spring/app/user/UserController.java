package com.spring.app.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/user/*")
public class UserController {
	
	@Autowired
	private UserService userService;
	
	@GetMapping("join/join")
	void join() {}
	
	@GetMapping("join/memberJoin")
	void memberJoin() {}
	
	@GetMapping("mypage")
	void myPage() {}
	
	@PostMapping("join/memberJoin")
	String memberJoin(UserVO userVO) throws Exception{
		int result = userService.join(userVO);
		
		return "redirect:/";
	}
	
	@GetMapping("join/trainerJoin")
	void trainerJoin(Model model) throws Exception {
		String trainerId = userService.getTrainerId();
		model.addAttribute("code", trainerId);
	}
	
	@PostMapping("join/trainerJoin")
	String trainerJoin(UserVO userVO) throws Exception{
		int result = userService.join(userVO);
		
		return "redirect:/";
	}
	
	@GetMapping("login")
	String login(@AuthenticationPrincipal UserVO userVO) {
		if (userVO != null) {
			return "redirect:/";
		}
		
		return "user/login";
	}
	
	@GetMapping("logout")
	String logout(HttpSession session, HttpServletResponse response) throws Exception{
		session.invalidate();
		Cookie cookie = new Cookie("accessToken", "");
		cookie.setMaxAge(0);
		cookie.setPath("/");
		response.addCookie(cookie);
		
		return "redirect:/";
	}
}
