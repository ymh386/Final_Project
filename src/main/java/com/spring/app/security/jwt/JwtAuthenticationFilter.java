package com.spring.app.security.jwt;

import java.io.IOException;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class JwtAuthenticationFilter extends BasicAuthenticationFilter {
	
	private JwtTokenManager jwtTokenManager;
	
	public JwtAuthenticationFilter(JwtTokenManager jwtTokenManager, AuthenticationManager authenticationManager) {
		super(authenticationManager);
		this.jwtTokenManager= jwtTokenManager;
		
	}

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		// TODO Auto-generated method stub
		Cookie [] cookies = request.getCookies();
		String access="";
		
		if (cookies!=null) {
			for (Cookie cookie:cookies) {
				if (cookie.getName().equals("accessToken")) {
					access=cookie.getValue();
				}
			}
		}
		
		if (access.length()>0) {
			Claims claims = jwtTokenManager.validateToken(access);
			Authentication authentication = jwtTokenManager.getAuthentication(claims.getSubject());
			
			SecurityContextHolder.getContext().setAuthentication(authentication);
		}
		
		super.doFilterInternal(request, response, chain);
	}

}
