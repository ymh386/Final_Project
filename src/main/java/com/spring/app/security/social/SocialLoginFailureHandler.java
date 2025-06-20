package com.spring.app.security.social;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import com.spring.app.auditLog.AuditLogService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Component
public class SocialLoginFailureHandler extends SimpleUrlAuthenticationFailureHandler {
	
	@Autowired
	private AuditLogService auditLogService;

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		// TODO Auto-generated method stub
		
		
		
		String error = URLEncoder.encode(exception.getMessage(), StandardCharsets.UTF_8);
		setDefaultFailureUrl("/user/login/trainerLogin?error="+error);
		
		super.onAuthenticationFailure(request, response, exception);
	}

}
