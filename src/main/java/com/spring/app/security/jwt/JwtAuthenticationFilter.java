package com.spring.app.security.jwt;

import java.io.IOException;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;

import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import reactor.netty.http.Cookies;

public class JwtAuthenticationFilter extends BasicAuthenticationFilter {
	
	private JwtTokenManager jwtTokenManager;
	
	public JwtAuthenticationFilter(JwtTokenManager jwtTokenManager, AuthenticationManager authenticationManager) {
		super(authenticationManager);
		this.jwtTokenManager=jwtTokenManager;
	}

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		// TODO Auto-generated method stub
		Cookie [] cookies = request.getCookies();
		String accessToken = "";
		
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals("accessToken")) {
					accessToken=cookie.getValue();
				}
			}
		}
		
		if (accessToken.length()>0) {
			Claims claims = jwtTokenManager.validateToken(accessToken);
			Authentication authenticaiton = jwtTokenManager.getAuthentication(claims.getSubject());
			
			SecurityContextHolder.getContext().setAuthentication(authenticaiton);
		}
		
		doFilter(request, response, chain);
	}

}
