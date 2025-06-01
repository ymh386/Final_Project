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

@Component
public class JwtTokenManager {
	
	@Value("${jwt.secretKey}")
	private String secretKey;
	
	@Value("${jwt.issuer}")
	private String issuer;
	
	@Value("${jwt.access.ValidTime}")
	private long validTime;
	
	private SecretKey key;
	
	@Autowired
	private UserService userService;
	
	@PostConstruct
	//사인에 사용할 키 설정
	public void init() {
		String s = Base64.getEncoder().encodeToString(secretKey.getBytes());
		this.key=Keys.hmacShaKeyFor(s.getBytes());
	}
	
	//토큰 생성
	public String createToken(Authentication authentication) {
		String token = Jwts
						.builder()
						.setSubject(authentication.getName())
						.claim("roles", authentication.getAuthorities())
						.setIssuedAt(new Date(System.currentTimeMillis()))
						.setExpiration(new Date(System.currentTimeMillis()+validTime))
						.issuer(issuer)
						.signWith(key)
						.compact()
						;
		
		return token;
	}
	
	//토큰 검증
	public Claims validateToken(String token) {
		Claims c = Jwts
					.parser()
					.setSigningKey(this.key)
					.build()
					.parseClaimsJws(token)
					.getBody()
					;
		
		return c;
	}
	
	public Authentication getAuthentication(String username) {
		
		UserDetails userDetails = userService.loadUserByUsername(username);
		Authentication authentication = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
		
		return authentication;
	}
	

}
