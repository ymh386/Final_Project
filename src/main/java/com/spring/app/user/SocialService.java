package com.spring.app.user;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

@Service
public class SocialService extends DefaultOAuth2UserService {
	
	@Autowired
	private UserDAO userDAO;

	@Override
	public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
		// TODO Auto-generated method stub
		ClientRegistration register = userRequest.getClientRegistration();
		
		String sns = register.getRegistrationId().toUpperCase();
		
		if (sns.equals("GOOGLE")) {
			return this.google(userRequest);
		} else if (sns.equals("KAKAO")) {
			return this.kakao(userRequest);
		}
		
		return null;
	}
	
	private OAuth2User google(OAuth2UserRequest request) {
		OAuth2User user = super.loadUser(request);
		
		Map<String, Object> map = user.getAttributes();
		
		UserVO userVO = new UserVO();
		
		userVO.setAttributes(map);
		userVO.setUsername(map.get("name").toString());
		userVO.setFileName(map.get("picture").toString());
		
		userVO.setAccessToken(request.getAccessToken().getTokenValue());
		userVO.setSns(request.getClientRegistration().getRegistrationId());
		
		List<StateVO> stateList = new ArrayList<>();
		StateVO stateVO = new StateVO();
		stateVO.setState("APPROVE");
		stateList.add(stateVO);
		
		List<RoleVO> roleList = new ArrayList<>();
		RoleVO roleVO = new RoleVO();
		roleVO.setRoleName("ROLE_MEMBER");
		roleList.add(roleVO);
		
		userVO.setRoleList(roleList);
		userVO.setStateList(stateList);
		
		try {
			if (userDAO.detail(userVO)==null) {
				Long code = userDAO.getTrainerCode();
				userVO.setTrainerCode(code);
				userDAO.join(userVO);
			}else {
				
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return userVO;
	}
	
	private OAuth2User kakao(OAuth2UserRequest request) throws OAuth2AuthenticationException {
		
		OAuth2User user=super.loadUser(request);
		
		Map<String, Object> map=(Map<String, Object>)user.getAttributes().get("properties");
		
		UserVO userVO = new UserVO();
		
		userVO.setAttributes(user.getAttributes());
		userVO.setUsername(user.getAttribute("id").toString());
		userVO.setFileName(map.get("thumbnail_image").toString());
		userVO.setName(map.get("nickname").toString());
		userVO.setAccessToken(request.getAccessToken().getTokenValue());
		userVO.setSns(request.getClientRegistration().getRegistrationId());
		
		List<RoleVO> roleList = new ArrayList<>();
		RoleVO roleVO = new RoleVO();
		roleVO.setRoleName("ROLE_MEMBER");			
		roleList.add(roleVO);
		
		List<StateVO> stateList = new ArrayList<>();
		StateVO stateVO = new StateVO();
		stateVO.setState("APPROVE");
		stateList.add(stateVO);
		
		userVO.setStateList(stateList);
		userVO.setRoleList(roleList);
		
		try {
			if (userDAO.detail(userVO)==null) {
				userDAO.join(userVO);
				System.out.println(userVO.getSns());
			}else {
				
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return userVO;
	}

}
