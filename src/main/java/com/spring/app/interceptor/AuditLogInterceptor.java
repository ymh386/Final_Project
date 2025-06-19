package com.spring.app.interceptor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.spring.app.auditLog.AuditLogService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class AuditLogInterceptor implements HandlerInterceptor{
	
	
	private AuditLogService auditLogService;
	

    public AuditLogInterceptor(@Lazy AuditLogService auditLogService) {
        this.auditLogService = auditLogService;
    }
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		 String uri = request.getRequestURI();
	        String method = request.getMethod();

	        if (uri.startsWith("/admin") || uri.contains("/delete")) {
	            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	            String username = auth != null && auth.isAuthenticated() ? auth.getName() : "anonymous";
	            System.out.println("interceptor");

	            auditLogService.log(
	                username,
	                method,
	                "UNKNOWN", // 또는 URI 기반으로 파싱
	                null,
	                "URL 요청: " + uri,
	                request
	            );
	        }

	        return true;
	}
}
