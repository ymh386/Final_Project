package com.spring.app.security.jwt;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.stereotype.Component;

import com.spring.app.user.UserService;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class JwtLoginFilter extends UsernamePasswordAuthenticationFilter {
	
	private AuthenticationManager authenticationManager;
	
	private JwtTokenManager jwtTokenManager;
	
	@Autowired
	private UserService userService;
	
	public JwtLoginFilter(JwtTokenManager jwtTokenManager, AuthenticationManager authenticationManager) {
		this.authenticationManager=authenticationManager;
		this.jwtTokenManager=jwtTokenManager;
		this.setFilterProcessesUrl("/users/login");
	}

	@Override
	public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
			throws AuthenticationException {
		// TODO Auto-generated method stub
		// 사용자가 입력한 값 가져오기
		// 입력한 값과 DB에 저장된 값 비교
		request.getMethod();
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(username, password);
		
		Authentication authentication = this.authenticationManager.authenticate(token);
		
		return authentication;
	}

	@Override
	protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain,
			Authentication authResult) throws IOException, ServletException {
		// TODO Auto-generated method stub
		// 로그인 요청이 성공했으므로 토큰 생성
		String token = jwtTokenManager.createToken(authResult);
		Cookie cookie = new Cookie("accessToken", token);
		cookie.setMaxAge(120);
		cookie.setPath("/");
		cookie.setHttpOnly(true);
		
		response.addCookie(cookie);
		response.sendRedirect("/");
	}

	@Override
	protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException failed) throws IOException, ServletException {
		// TODO Auto-generated method stub
		
		response.sendRedirect("/user/login");
	}

}
