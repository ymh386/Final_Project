package com.spring.app.home;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.spring.app.payment.PaymentDAO;
import com.spring.app.subscript.SubscriptService;
import com.spring.app.user.MemberRoleVO;
import com.spring.app.user.MemberStateVO;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;



@Controller
public class HomeController {
	
	@Autowired
	private SubscriptService subscriptService;
	
	@Autowired
	private UserService userService;
	
	@GetMapping("/")
	public String home(@AuthenticationPrincipal UserVO userVO, Model model) throws Exception {
		System.out.println("Home");
		
		
		if (userVO!=null) {
			List<MemberRoleVO> list = userService.getRole(userVO.getUsername());
			for (MemberRoleVO memberRoleVO : list) {
				if (memberRoleVO.getRoleNum()==2) {
					return "index";
				}else {
					String username = userVO.getUsername();
					int result = subscriptService.getRemainDays(username);
					model.addAttribute("result", result);									
				}
			}
		}
		
		
		return "index";
	}

}
