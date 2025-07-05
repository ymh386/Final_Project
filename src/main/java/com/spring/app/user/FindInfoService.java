package com.spring.app.user;

import java.util.List;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;


import jakarta.annotation.PostConstruct;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.service.DefaultMessageService;

@Service
public class FindInfoService {
	
	@Autowired
	private UserDAO userDAO;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@Value("${spring.mail.username}")
	private String from;
	
	@Value("${nurigo.api.key}")
	private String apiKey;
	
	@Value("${nurigo.api.secret.key}")
	private String secretKey;
	
	@Value("${nurigo.send.phone.number}")
	private String sendPhone;

	
	public String randomPassword(int length) throws Exception {
		return RandomStringUtils.randomAlphanumeric(12);
	}
	
	public List<String> getPhone(String input) throws Exception {
		List<String> phone = userDAO.getPhone(input);
		
		return phone;
	}
	
	public UserVO getUserByPhone(String phone) throws Exception {
		UserVO userVO = userDAO.getUserByPhone(phone);
		
		return userVO;
	}
	
	public UserVO getUserByPhoneAndId(String username, String phone) throws Exception {
		UserVO userVO = userDAO.getUserByPhoneAndId(username, phone);
		
		return userVO;
	}
	
	public List<UserVO> getUserListByPhone(String phone) throws Exception {
		List<UserVO> list = userDAO.getUserListByPhone(phone);
		
		return list;
	}
	
	public String getEmail(String input) throws Exception {
		String email = userDAO.getEmail(input);
		
		return email;
	}
	
	public UserVO getUserByEmail(String email) throws Exception{
		UserVO userVO = userDAO.getUserByEmail(email);
		
		return userVO;
	}
	
	public static String maskEmail(String email, int start, int end) {
		String mask=StringUtils.repeat("*", end - start);
		
		return StringUtils.overlay(email, mask, start, end);
	}
	
	public int changePw(UserVO userVO) throws Exception {
		int result = userDAO.changePw(userVO);
		
		return result;
	}
	
	public void findPwByEmail(String email, String newPassword) throws Exception {
		SimpleMailMessage msg = new SimpleMailMessage();
		msg.setFrom(from);
		msg.setTo(email);
		msg.setSubject("[FINAL] 임시 비밀번호 안내");
		msg.setText(
				"안녕하세요.\n\n"
				+"요청하신 임시 비밀번호 입니다." + newPassword + "\n"
				+"로그인 후 반드시 비밀번호를 변경해주세요.\n\n"
				);
		mailSender.send(msg);
	}
	
	public void findPwByPhone(String phone, String newPassword) throws Exception {
		DefaultMessageService defaultMessageService = NurigoApp.INSTANCE.initialize(apiKey, secretKey, "https://api.solapi.com");
		Message message = new Message();
		
		message.setFrom(sendPhone);
		message.setTo(phone);
		message.setText("임시 비밀번호는 "+newPassword+"입니다.\n\n"
				+"로그인 후 비밀번호를 변경해주세요.");
		
		defaultMessageService.send(message);
		
	}

}
