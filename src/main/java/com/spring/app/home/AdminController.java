package com.spring.app.home;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.user.MemberRoleVO;
import com.spring.app.user.MemberStateVO;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;

@Controller
@RequestMapping("/admin/*")
public class AdminController {
	
	@Autowired
	private UserService userService;
	
	@GetMapping("main")
	String admin(Model model, UserVO userVO) throws Exception {
		
		List<UserVO> ar = userService.awaitUserList(userVO);
		
		model.addAttribute("userList", ar);
		
		return "admin";
	}
	
	@PostMapping("updateState")
	String updateState(MemberStateVO memberStateVO, MemberRoleVO memberRoleVO) throws Exception {
		int result = userService.updateUserState(memberStateVO);
		int result2 = userService.giveTrainerRole(memberRoleVO);
		return "redirect:../";
	}

}
