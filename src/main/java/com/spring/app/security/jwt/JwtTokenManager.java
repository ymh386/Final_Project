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

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class JwtTokenManager {
	
	@Value("${jwt.issuer}")
	private String issuer;
	
	@Value("${jwt.secretKey}")
	private String secretKey;
	
	@Value("${jwt.access.ValidTime}")
	private long validTime;
	
	private SecretKey key;
	
	@Autowired
	private UserService userService;
	
	@PostConstruct
	public void init() {
		String s = Base64.getEncoder().encodeToString(secretKey.getBytes());
		this.key = Keys.hmacShaKeyFor(s.getBytes());
	}
	
	//토큰 생성
	public String createToken(Authentication authentication) {
		
		//생성하기 위한 토큰 빌더 객체 생성
		//사용자 이름, 권한 정보, 발급/만료 시간, 발급자, 발급된 키로 서명, 문자열로 직렬화
		String token = Jwts
						.builder()
						.setSubject(authentication.getName())
						.claim("roles", authentication.getAuthorities())
						.issuedAt(new Date(System.currentTimeMillis()))
						.expiration(new Date(System.currentTimeMillis()+validTime))
						.issuer(issuer)
						.signWith(key)
						.compact()
						;
		
		return token;
		
	}
	
	//토큰 검증
	public Claims validateToken(String token) {
		
		//검증하기 위해 builder객체 초기화
		//서명 키 설정 및 빌드
		//토큰 파싱(유효성, 서명, 만료 여부 검증)
		//파싱된 토큰의 payload(Claims) 추출
		Claims c = Jwts
					.parser()
					.setSigningKey(key)
					.build()
					.parseClaimsJws(token)
					.getBody()
					;
		
		return c;
					
	}
	
	public Authentication getAuthentication(String username) {
		
		UserDetails userDetails = userService.loadUserByUsername(username);
		
		log.info("username : {}", userDetails.getUsername());
		
		Authentication authentication = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
		
		return authentication;
	}

}
