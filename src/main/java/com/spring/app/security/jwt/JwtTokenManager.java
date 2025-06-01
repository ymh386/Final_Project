package com.spring.app.security.jwt;

import java.util.Base64;
import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
//jwt 토큰을 생성, 검증, 만료 체크 기능을 제공
//토큰의 유효성 검사
public class JwtTokenManager {
	
	@Value("${jwt.access.ValidTime}")
	private long accessValidTime;
	
	@Value("${jwt.secretKey}")
	private String jwtSecretKey;
	
	@Value("${jwt.issuer}")
	private String issuer;

	private SecretKey key;
	
	@Autowired
	private UserService userService;
	
	@PostConstruct
	public void init() {
		String s = Base64.getEncoder().encodeToString(jwtSecretKey.getBytes());
		this.key = Keys.hmacShaKeyFor(s.getBytes());
	}
	
	public String createToken(Authentication authentication) {
		//String 타입의 JWT 토큰
		return Jwts
					.builder()
					.setSubject(authentication.getName())
					.claim("roles", authentication.getAuthorities())
					.setIssuedAt(new Date(System.currentTimeMillis()))
					.setExpiration(new Date(System.currentTimeMillis()+accessValidTime))
					.setIssuer(issuer) //token 발급자
					.signWith(key)
					.compact();
		
		
	}
	
	//클라이언트로부터 받은 JWT를 검증하고 Claim를 추출
	public Claims tokenValidation(String token) throws Exception {
		//Claims 객체
		return Jwts
				.parser()
				.setSigningKey(this.key)
				.build()
				.parseClaimsJws(token)
				.getBody();
	}
	
	//username을 기반으로 인증 객체 생성
	public Authentication getAuthentication(String username) {
		//매개변수로 받은 username를 기반으로 userService의 loadUserByUsername 메서드로 해당 사용자의 정보를 가져옴.
		UserDetails userDetails = userService.loadUserByUsername(username);
		
		Authentication authentication = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
		
		return authentication;
	}
	
	
	
	
}
