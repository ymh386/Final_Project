package com.spring.app.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.app.subscript.SubscriptService;
import com.spring.app.subscript.SubscriptVO;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/user/*")
public class UserController {
	
	@Autowired
	private PasswordEncoder encoder;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private SubscriptService subscriptService;
	
	@GetMapping("join/join")
	void join() {}
	
	@GetMapping("join/memberJoin")
	void memberJoin() {}
	
	@GetMapping("mypage")
	void myPage(@AuthenticationPrincipal UserVO userVO, Model model) throws Exception {
		
		if (userVO!=null) {
			String username = userVO.getUsername();
			List<SubscriptVO> list = subscriptService.getSubscriptByUser(username);
			
			model.addAttribute("list", list);
		}
	}
	
	@PostMapping("join/memberJoin")
	String memberJoin(UserVO userVO) throws Exception{
		int result = userService.join(userVO);
		
		return "redirect:/";
	}
	
	@GetMapping("join/trainerJoin")
	void trainerJoin(Model model) throws Exception {
		String trainerId = "T"+userService.getTrainerCode();
		model.addAttribute("code", trainerId);
	}
	
	@PostMapping("join/trainerJoin")
	String trainerJoin(UserVO userVO) throws Exception{
		Long code = userService.getTrainerCode();
		userVO.setTrainerCode(code);
		int result = userService.join(userVO);
		
		return "redirect:/";
	}
	
	@GetMapping("login/login")
	String memberLogin(@AuthenticationPrincipal UserVO userVO) {
		if (userVO != null) {
			return "redirect:/";
		}
		
		return "user/login/login";
	}
	
	@GetMapping("login/trainerLogin")
	String trainerLogin(@AuthenticationPrincipal UserVO userVO, @RequestParam(value = "error", required = false) String error, Model model) {
		if (userVO != null) {
			return "redirect:/";
		}
		if (error != null) {
			model.addAttribute("error", error);
		}
		
		return "user/login/trainerLogin";
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
	
	@GetMapping("update")
	String update(Model model, UserVO userVO) throws Exception {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		String username = auth.getName();
		
		userVO.setUsername(username);
		userVO=userService.detail(userVO);
		
		model.addAttribute("user", userVO);
		
		return "user/update";
	}
	
	@PostMapping("update")
	String update(@ModelAttribute UserVO updateUser) throws Exception {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String username = auth.getName();
		UserVO userVO = new UserVO();
		
		userVO.setUsername(username);
		userVO = userService.detail(userVO);
		
		userVO.setName(updateUser.getName());
		userVO.setBirth(updateUser.getBirth());
		userVO.setEmail(updateUser.getEmail());
		userVO.setPassword(encoder.encode(updateUser.getPassword()));
		
		int result = userService.update(userVO);
		
		return "redirect:./mypage";
	}
}
