package com.spring.app.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authorization.AuthorityAuthorizationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.web.DefaultSecurityFilterChain;
import org.springframework.security.web.access.expression.WebExpressionAuthorizationManager;
import org.springframework.security.web.authentication.AuthenticationFilter;
import org.springframework.security.web.firewall.DefaultHttpFirewall;
import org.springframework.security.web.firewall.HttpFirewall;

import com.spring.app.security.jwt.JwtAuthenticationFilter;
import com.spring.app.security.jwt.JwtLoginFilter;
import com.spring.app.security.jwt.JwtTokenManager;
import com.spring.app.security.social.RequestResolver;
import com.spring.app.security.social.SocialLoginFailureHandler;
import com.spring.app.security.social.SocialLoginSuccessHandler;
import com.spring.app.security.social.SocialService;


@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
	@Autowired
	private SocialLoginFailureHandler socialLoginFailureHandler;
	
	@Autowired
	private ClientRegistrationRepository repo;
	
	@Autowired
	private SocialService socialService;
	
	@Autowired
	private AuthenticationConfiguration authenticationConfiguration;
	
	@Autowired
	private JwtTokenManager jwtTokenManager;
	
	@Autowired
	private SocialLoginSuccessHandler socialLoginSuccessHandler;
	
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
				.requestMatchers("/user/getDocuments", "/user/getDocument").hasAnyRole("ADMIN", "TRAINER")
				.requestMatchers("/user/admin/**").hasRole("ADMIN")
				.requestMatchers("/approval/form**").hasRole("ADMIN")
				.requestMatchers("/approval/**").hasAnyRole("ADMIN", "TRAINER")		
				.requestMatchers("/user/getDocuments", "/user/getDocument").hasAuthority("APPROVE")
				.requestMatchers("/user/department/**").hasRole("ADMIN")
				.requestMatchers("/schedule/**").hasAuthority("APPROVE")
				.requestMatchers("/approval/**").hasAuthority("APPROVE")
				.requestMatchers("/user/mypage**").hasAnyRole("MEMBER", "TRAINER", "ADMIN")
				.requestMatchers("/schedule/**").hasAnyAuthority("APPROVE", "CANCEL")
				.requestMatchers("/approval/**").hasAnyAuthority("APPROVE", "CANCEL")
				.requestMatchers("/subscript/list").access(new WebExpressionAuthorizationManager("!hasRole('TRAINER')"))
				.requestMatchers("/friend/**").hasAnyAuthority("APPROVE", "CANCEL")
				.requestMatchers("/chat/**").hasAnyAuthority("APPROVE", "CANCEL")
				.anyRequest().permitAll();
		})
		.formLogin(login->login.disable())
		.sessionManagement(session -> {
			session.sessionCreationPolicy(SessionCreationPolicy.STATELESS);
		})
		.httpBasic(httpBasic -> httpBasic.disable())
		.addFilter(new JwtLoginFilter(jwtTokenManager, authenticationConfiguration.getAuthenticationManager()))
		.addFilter(new JwtAuthenticationFilter(jwtTokenManager, authenticationConfiguration.getAuthenticationManager()))
		
		.oauth2Login(oauth->{
			oauth
			.authorizationEndpoint(end -> 
				end.authorizationRequestResolver(new RequestResolver(repo, "/oauth2/authorization"))
			)
			.userInfoEndpoint(service->
				service.userService(socialService)
				.and()
				.successHandler(socialLoginSuccessHandler)
				.failureHandler(socialLoginFailureHandler)
			);
		})
		;
		
		return security.build();
		
		
	}
}
