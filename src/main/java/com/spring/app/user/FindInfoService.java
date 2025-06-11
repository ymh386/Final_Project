package com.spring.app.user;

import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class FindInfoService {
	
	@Autowired
	private UserDAO userDAO;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@Value("${spring.mail.username}")
	private String from;
	
	@Value("${twilio.account.sid}")
	private String sid;
	
	@Value("${twilio.auth.token}")
	private String token;
	
	@Value("${twilio.from.number}")
	private String fromNum;
	
	public String randomPassword(int length) throws Exception {
		return RandomStringUtils.randomAlphanumeric(12);
	}
	
	public UserVO getUserByEmail(String email) throws Exception {
		UserVO userVO = userDAO.getUserByEmail(email);
		
		return userVO;
	}
	
	public int changePw(UserVO userVO) throws Exception {
		int result = userDAO.changePw(userVO);
		
		return result;
	}
	
	public void findId(String email, String newPassword) throws Exception {
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

}
