package com.spring.app.security.social;

import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.DefaultOAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.client.web.OAuth2AuthorizationRequestResolver;
import org.springframework.security.oauth2.core.endpoint.OAuth2AuthorizationRequest;

import jakarta.servlet.http.HttpServletRequest;

public class RequestResolver implements OAuth2AuthorizationRequestResolver {
	
	private final OAuth2AuthorizationRequestResolver resolver;

	public RequestResolver(ClientRegistrationRepository repo, String authorization) {
		this.resolver = new DefaultOAuth2AuthorizationRequestResolver(repo, authorization);
	}

	@Override
	public OAuth2AuthorizationRequest resolve(HttpServletRequest request) {
		// TODO Auto-generated method stub
        OAuth2AuthorizationRequest originalRequest = resolver.resolve(request);
        return customize(originalRequest, request);
	}

	@Override
	public OAuth2AuthorizationRequest resolve(HttpServletRequest request, String clientRegistrationId) {
		// TODO Auto-generated method stub
        OAuth2AuthorizationRequest originalRequest = resolver.resolve(request, clientRegistrationId);
        return customize(originalRequest, request);
	}
	
    private OAuth2AuthorizationRequest customize(OAuth2AuthorizationRequest request, HttpServletRequest http) {
        if (request == null) return null;

        String redirectParam = http.getParameter("redirect");
        if (redirectParam != null) {
            http.getSession().setAttribute("loginType", redirectParam);
        }

        return request;
    }

}
