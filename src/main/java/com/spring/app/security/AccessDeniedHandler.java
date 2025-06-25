package com.spring.app.security;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import com.spring.app.user.MemberStateVO;
import com.spring.app.user.StateVO;
import com.spring.app.user.UserDAO;
import com.spring.app.user.UserVO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AccessDeniedHandler implements org.springframework.security.web.access.AccessDeniedHandler {

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		// TODO Auto-generated method stub
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth!=null && auth.getPrincipal() instanceof UserVO) {
			UserVO user = (UserVO)auth.getPrincipal();
			
			System.out.println(user.getStateList().get(0));
			
			if (user.getStateList().get(0).getState().equals("AWAIT")) {
				response.sendRedirect(request.getContextPath() + "/denied/trainer");
				
				return;
			}
			
			if (user.getStateList().get(0).getState().equals("STOP")) {
				response.sendRedirect(request.getContextPath() + "/denied/subscription");
				
				return;
			}

		}
		
		//response.sendRedirect(request.getContextPath() + "denied");
		
	}

}
