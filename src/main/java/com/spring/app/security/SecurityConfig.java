package com.spring.app.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.DefaultSecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFilter;
import org.springframework.security.web.firewall.DefaultHttpFirewall;
import org.springframework.security.web.firewall.HttpFirewall;

import com.spring.app.security.jwt.JwtAuthenticationFilter;
import com.spring.app.security.jwt.JwtLoginFilter;
import com.spring.app.security.jwt.JwtTokenManager;


@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
	@Autowired
	private AuthenticationConfiguration authenticationConfiguration;
	
	@Autowired
	private JwtTokenManager jwtTokenManager;
	
	@Bean
	HttpFirewall fireWall() {
		return new DefaultHttpFirewall();
	}
	
	@Bean
	WebSecurityCustomizer custom() {
		return (web)->{
			web.ignoring().requestMatchers("/css/**", "/js/**", "/img/**");
		};
	}
	
	@Bean
	DefaultSecurityFilterChain filterChain(HttpSecurity security) throws Exception {
		security
		.cors(cors->cors.disable())
		.csrf(csrf->csrf.disable())
		.authorizeHttpRequests(request->{
			request
				.requestMatchers("/admin/**").hasRole("ADMIN")
				.anyRequest().permitAll();
		})
		.formLogin(login->login.disable())
		.sessionManagement(session -> {
			session.sessionCreationPolicy(SessionCreationPolicy.STATELESS);
		})
		.httpBasic(httpBasic -> httpBasic.disable())
		.addFilter(new JwtLoginFilter(authenticationConfiguration.getAuthenticationManager(), jwtTokenManager))
		.addFilter(new JwtAuthenticationFilter(jwtTokenManager, authenticationConfiguration.getAuthenticationManager()));
		
		return security.build();
		
		
	}
}
