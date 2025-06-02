package com.spring.app.home;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;



@Controller
public class HomeController {
	
	@Autowired
	private UserService userService;
	
	@GetMapping("/")
	public String home() throws Exception {
		System.out.println("Home");
		
		return "index";
	}
	
	@GetMapping("/admin")
	String admin(Model model, UserVO userVO) throws Exception {
		
		List<UserVO> ar = userService.awaitUserList(userVO);
		
		model.addAttribute("userList", ar);
		
		return "admin";
	}
}
