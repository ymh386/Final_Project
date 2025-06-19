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

@Component
public class SocialLoginFailureHandler extends SimpleUrlAuthenticationFailureHandler {
	
	@Autowired
	private AuditLogService auditLogService;

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		// TODO Auto-generated method stub
		
		// 감사/로그 기록용
		try {
			auditLogService.log(
					"anonymous",
			        "SOCIAL_LOGIN_FAIL",
			        "USER",
			        "anonymous",
			        "anonymous이 소셜 로그인 실패",
			        request
			    );
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String error = URLEncoder.encode(exception.getMessage(), StandardCharsets.UTF_8);
		setDefaultFailureUrl("/user/login/trainerLogin?error="+error);
		
		super.onAuthenticationFailure(request, response, exception);
	}

}
