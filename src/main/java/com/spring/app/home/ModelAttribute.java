package com.spring.app.home;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.ControllerAdvice;

import com.spring.app.subscript.SubscriptService;
import com.spring.app.user.UserVO;

@ControllerAdvice
public class ModelAttribute {
	
	@Autowired
	private SubscriptService subscriptService;
	
	@org.springframework.web.bind.annotation.ModelAttribute("remainDay")
	public Integer remainDays(@AuthenticationPrincipal UserVO userVO) throws Exception {
		if (userVO==null) {
			return null;
		}else {
			return subscriptService.getRemainDays(userVO.getUsername());
		}
	}

}
