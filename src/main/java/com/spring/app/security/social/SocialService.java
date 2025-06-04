package com.spring.app.security.social;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import java.util.Map;

import javax.naming.AuthenticationException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.spring.app.user.MemberStateVO;
import com.spring.app.user.RoleVO;
import com.spring.app.user.StateVO;
import com.spring.app.user.UserDAO;
import com.spring.app.user.UserVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
			System.out.println("kakaosuccess");
			return this.kakao(userRequest);
		}
		
		return null;
	}
	
	private OAuth2User google(OAuth2UserRequest userRequest) {
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
		
		HttpSession session = request.getSession(false);
		
		String url = session.getAttribute("loginType").toString();
		System.out.println(url);
		
		OAuth2User user = super.loadUser(userRequest);
		
		Map<String, Object> map = user.getAttributes();
		
		UserVO userVO = new UserVO();
		
		MemberStateVO memberStateVO = new MemberStateVO();
		
		userVO.setAttributes(map);
		userVO.setUsername(map.get("email").toString());
		userVO.setFileName(map.get("picture").toString());
		userVO.setName(map.get("email").toString());
		userVO.setPassword("SOCIALGOOGLE");
		
		userVO.setAccessToken(userRequest.getAccessToken().getTokenValue());
		userVO.setSns(userRequest.getClientRegistration().getRegistrationId());
		
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
			UserVO exist = userDAO.detail(userVO);
			if (exist==null) {
				if ("trainer".equals(url)) {
					Long code = userDAO.getTrainerCode();
					userVO.setTrainerCode(code);
					System.out.println(userVO.getTrainerCode());
				} else {

				}
				userDAO.join(userVO);
				exist=userVO;
			}else {
				if ("trainer".equals(url) && exist.getTrainerCode()==null) {
					throw new AuthenticationServiceException("트레이너 계정이 아닙니다.");
				}
				
				userVO=exist;
				
			}
			
			return userVO;
			
		} catch (AuthenticationServiceException authEx) {
	        // 1) AuthenticationServiceException은 반드시 다시 던져서 Spring Security에게 전달
	        throw authEx;

	    } catch (Exception e) {
	        // 2) 그 외 예외는 OAuth2AuthenticationException으로 wrapping하여 던져야 함
	        e.printStackTrace();
	        OAuth2Error oauth2Error = new OAuth2Error(
	                "invalid_request",          // 에러 코드 (관례적인 문자열)
	                e.getMessage(),             // 프론트에 노출할 메시지
	                null                        // RFC 문서 URL 등 (없으면 null)
	        );
	        throw new OAuth2AuthenticationException(oauth2Error, e.getMessage(), e);
	    }
	}
	
	private OAuth2User kakao(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
		
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		
		HttpSession session = request.getSession(false);
		
		String url = session.getAttribute("loginType").toString();
		
		System.out.println("url:"+url);
		
		OAuth2User user=super.loadUser(userRequest);
		
		Map<String, Object> map=(Map<String, Object>)user.getAttributes().get("properties");
		
		UserVO userVO = new UserVO();
		
		userVO.setAttributes(user.getAttributes());
		userVO.setUsername(user.getAttribute("id").toString());
		userVO.setPassword("SOCIALKAKAO");
		userVO.setFileName(map.get("thumbnail_image").toString());
		userVO.setName(map.get("nickname").toString());
		userVO.setAccessToken(userRequest.getAccessToken().getTokenValue());
		userVO.setSns(userRequest.getClientRegistration().getRegistrationId());
		
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
			UserVO exist = userDAO.detail(userVO);
			if (exist==null) {
				if ("trainer".equals(url)) {
					Long code = userDAO.getTrainerCode();
					userVO.setTrainerCode(code);
					System.out.println(userVO.getTrainerCode());
				} else {

				}
				userDAO.join(userVO);
				exist=userVO;
			}else {
				if ("trainer".equals(url) && exist.getTrainerCode()==null) {
					throw new AuthenticationServiceException("트레이너 계정이 아닙니다.");
				}
				
				userVO=exist;
				
			}
			
			return userVO;
			
		} catch (AuthenticationServiceException authEx) {
	        // 1) AuthenticationServiceException은 반드시 다시 던져서 Spring Security에게 전달
	        throw authEx;

	    } catch (Exception e) {
	        // 2) 그 외 예외는 OAuth2AuthenticationException으로 wrapping하여 던져야 함
	        e.printStackTrace();
	        OAuth2Error oauth2Error = new OAuth2Error(
	                "invalid_request",          // 에러 코드 (관례적인 문자열)
	                e.getMessage(),             // 프론트에 노출할 메시지
	                null                        // RFC 문서 URL 등 (없으면 null)
	        );
	        throw new OAuth2AuthenticationException(oauth2Error, e.getMessage(), e);
	    }
		
	}

}
