package com.spring.app.home;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.auditLog.AuditLogService;
import com.spring.app.user.MemberRoleVO;
import com.spring.app.user.MemberStateVO;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/admin/*")
public class AdminController {
	
	@Autowired
	private UserService userService;
	
	@Autowired AuditLogService auditLogService;
	
	@GetMapping("main")
	String admin(Model model, UserVO userVO) throws Exception {
		
		List<UserVO> ar = userService.awaitUserList(userVO);
		
		model.addAttribute("userList", ar);
		
		return "admin";
	}
	
	@PostMapping("updateState")
	String updateState(MemberStateVO memberStateVO, MemberRoleVO memberRoleVO, HttpServletRequest request) throws Exception {
		int result = userService.updateUserState(memberStateVO);
		
		// 로그/감사 기록용
		auditLogService.log(
		        "admin",
		        "APPROVE_USER",
		        "MEMBER_STATE",
		        memberStateVO.getUsername(),
		        "admin이".concat(memberStateVO.getUsername()).concat(" 승인"),
		        request
		    );
		
		return "redirect:../";
	}

}
