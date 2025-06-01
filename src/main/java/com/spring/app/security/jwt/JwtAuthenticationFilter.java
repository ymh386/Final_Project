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

//요청을 가로채어 jwt 토큰 검증 및 사용자 인증 수행
//유효한 토큰이 존재하면 인증 컨텍스트에 저장
public class JwtAuthenticationFilter extends BasicAuthenticationFilter {
	
	private JwtTokenManager jwtTokenManager;
	
	public JwtAuthenticationFilter(AuthenticationManager authenticationManager, JwtTokenManager jwtTokenManager) {
		super(authenticationManager);
		this.jwtTokenManager = jwtTokenManager;
	}

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		
		Cookie [] cookies = request.getCookies();
		String accessToken="";
		if(cookies != null) {
			for(Cookie cookie: cookies) {
				//클라이언트가 보낸 쿠키의 배열 중 accessToken이라는 이름을 가진 쿠키의 값을 꺼냄. -> 클라이언트가 보낸 JWT 토큰
				if(cookie.getName().equals("accessToken")) {
					accessToken = cookie.getValue();
				}
			}
		}
		
		if(accessToken.length()>0) {
			try {
				//토큰이 유효한지 검증
				Claims claims = jwtTokenManager.tokenValidation(accessToken);
				
				//해당 유저의 authentication 객체를 생성
				Authentication authentication = jwtTokenManager.getAuthentication(claims.getSubject());
				//현재 요청에 대해 인증 정보를 SecurityContext에 설정. (차후 프론트에서 sec태그 사용 위함)
				SecurityContextHolder.getContext().setAuthentication(authentication);
								
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		
		
		chain.doFilter(request, response);
	}

}
