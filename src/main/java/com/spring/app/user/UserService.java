package com.spring.app.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService implements UserDetailsService {
	
	@Autowired
	private PasswordEncoder encoder;
	
	@Autowired
	private UserDAO userDAO;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		UserVO userVO = new UserVO();
		userVO.setUsername(username);
		try {
			userVO = userDAO.detail(userVO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			userVO=null;
		}
		
		return userVO;
	}
	
	public int join(UserVO userVO) throws Exception {
		
		userVO.setPassword(encoder.encode(userVO.getPassword()));
		int result = userDAO.join(userVO);
		
		return result;
	}
	
	
}
