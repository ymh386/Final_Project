package com.spring.app.user;

import java.util.List;

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
			System.out.println(userVO);
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

	
	public String getTrainerId() throws Exception {
		Long code = userDAO.getTrainerCode();
		String trainerId = "T"+code;
		return trainerId;
	}
	
	public List<UserVO> awaitUserList(UserVO userVO) throws Exception {
		List<UserVO> ar = userDAO.awaitUserList(userVO);
		
		return ar;
	}
	
	public int updateUserState(MemberStateVO memberStateVO) throws Exception {
		int result = userDAO.updateUserState(memberStateVO);
		
		return result;
	}
	
	// 트레이너 스케쥴 등록 할때 트레이너/일반회원 구분하기 위해
    public List<UserVO> getUsersByUsernamePrefix(String prefix) {
        return userDAO.selectUsersByUsernamePrefix(prefix);
    }


	
	
}
