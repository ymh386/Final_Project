package com.spring.app.security.social;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.spring.app.auditLog.AuditLogService;
import com.spring.app.security.jwt.JwtTokenManager;
import com.spring.app.user.UserDAO;
import com.spring.app.user.UserVO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class SocialLoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
	
	@Autowired
	private JwtTokenManager jwtTokenManager;
	
	@Autowired
	private AuditLogService auditLogService;
	
	@Autowired UserDAO userDAO;

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession(false);
		String url = session.getAttribute("loginType").toString();
		
		String token = jwtTokenManager.createToken(authentication);
		
		Cookie cookie = new Cookie("accessToken", token);
		
		cookie.setHttpOnly(true);
		cookie.setPath("/");
		cookie.setMaxAge(36000);
		
		response.addCookie(cookie);
		
		// 로그/감사 기록용
		try {
			String username = authentication.getName();
			UserVO userVO = new UserVO();
			userVO.setUsername(username);
			
			userVO = userDAO.detail(userVO);
			
			auditLogService.log(
			        username,
			        "SOCIAL_LOGIN_SUCCESS",
			        "USER",
			        username,
			        username.concat("이").concat(userVO.getSns()).concat(" 로그인 성공"),
			        request
			    );
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		if ("trainer".contains(url)) {
			response.sendRedirect("/");
		}else {
			response.sendRedirect("/");			
		}
		super.onAuthenticationSuccess(request, response, authentication);
	}

}
