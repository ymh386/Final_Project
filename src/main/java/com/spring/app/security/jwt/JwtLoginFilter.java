package com.spring.app.security.jwt;

import java.io.IOException;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;


@Slf4j
//로그인 요청을 가로채어 사용자 인증 수행
//사용자가 입력한 id, pw를 검증 후 jwt 토큰 생성
//토큰을 응답 헤더에 포함하여 반환
public class JwtLoginFilter extends UsernamePasswordAuthenticationFilter{
	
	private JwtTokenManager jwtTokenManager;
	
	private AuthenticationManager authenticationManager;
	
	
	public JwtLoginFilter(AuthenticationManager authenticationManager, JwtTokenManager jwtTokenManager) {
		//Spring Security의 내부 인증 매니저를 필터에 저장
		this.authenticationManager=authenticationManager;
		//인증이 성공했을때 jwt 토큰을 생성/검증하는 객체를 필터에 저장
		this.jwtTokenManager=jwtTokenManager;
		//이 필터가 동작할 URL을 설정
		//UsernamePasswordAuthenticationFilter는 AbstractAuthenctcationFilter를 상속하고 있기 때문에 해당 메서드를 사용 가능.
		this.setFilterProcessesUrl("/users/login");
	}
	
	
	@Override
	public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
			throws AuthenticationException {
		
		request.getMethod();
		
		if (!request.getMethod().equals("POST")) {
			throw new AuthenticationServiceException("지원하지 않는 형식입니다.");
		}
		
		//id, pw 파라미터 가져옴
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		//가져온 파라미터 내용을 authenticationToken에 담음
		UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(username, password);
		
		//내용을 담은 authenticationToken을 검증함 (내부적으로 authenticationProvider.authenticate를 실행 > userdetailsService 호출)
		//인증을 위임하여 비밀번호 검증 또한 내부적으로 passwordEncoder.matches()로 처리됨.
		Authentication authentication = this.authenticationManager.authenticate(token);
		log.info("token : {}", authentication);
		
		//리턴된 값은 successfulAuthentication()의 매개변수로 전달됨.
		//호출하지 않아도 리턴값이 전달되는 이유는 successfulAuthentication() 메서드는 attemptAuthentication()의 리턴값을
		//security 내부에서 받아서 자동으로 호출해주는 콜백 메서드이기 때문.
		return authentication;
	}
	
	@Override
	protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain,
			Authentication authResult) throws IOException, ServletException {
		// TODO Auto-generated method stub
		
		 //jwt를 token형식으로 저장
		 String token = jwtTokenManager.createToken(authResult);
		
		 //저장된 token형식을 cookie에 저장
		 Cookie cookie = new Cookie("accessToken", token);
		 cookie.setMaxAge(120);
		 cookie.setPath("/");
		 
		 //cookie를 js에서 접근하지 못하게 함.
		 cookie.setHttpOnly(true);
		 
		 //로그인에 성공한 사용자의 JWT를 클라이언트 브라우저에 쿠키로 저장 (기존의 Session 대체로 사용)
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
