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

@Component
@Slf4j
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
	
	public Claims tokenValidation(String token) throws Exception {
		return Jwts
				.parser()
				.setSigningKey(this.key)
				.build()
				.parseClaimsJws(token)
				.getBody();
	}
	
	public Authentication getAuthentication(String username) {
		UserDetails userDetails = userService.loadUserByUsername(username);
		
		Authentication authentication = new UsernamePasswordAuthenticationToken(username, null, userDetails.getAuthorities());
		
		return authentication;
	}
	
	
	
	
}
