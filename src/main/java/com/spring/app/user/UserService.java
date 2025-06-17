package com.spring.app.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.spring.app.approval.DocumentVO;
import com.spring.app.approval.UserSignatureVO;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserService implements UserDetailsService {
	
	@Autowired
	private PasswordEncoder encoder;
	
	@Autowired
	private UserDAO userDAO;
	
	@Autowired
	private JavaMailSender mailSender;
	
	@Value("${spring.mail.username}")
	private String from;

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

	
	public UserVO detail(UserVO userVO) throws Exception {
		userVO = userDAO.detail(userVO);
		
		return userVO;
	}
	
	public int join(UserVO userVO) throws Exception {
		
		userVO.setPassword(encoder.encode(userVO.getPassword()));
		int result = userDAO.join(userVO);
		
		return result;
	}

	public int giveTrainerRole(MemberRoleVO memberRoleVO) throws Exception {
		int result = userDAO.giveTrainerRole(memberRoleVO);
		
		return result;
	}
	
	public Long getTrainerCode() throws Exception {
		Long code = userDAO.getTrainerCode();
		return code;
	}
	
	public List<UserVO> awaitUserList(UserVO userVO) throws Exception {
		List<UserVO> ar = userDAO.awaitUserList(userVO);
		
		return ar;
	}
	
	public int updateUserState(MemberStateVO memberStateVO) throws Exception {
		int result = userDAO.updateUserState(memberStateVO);
		
		return result;
	}
	
	public List<MemberRoleVO> getRole(String username) throws Exception {
		List<MemberRoleVO> list = userDAO.getRole(username);
		
		return list;
	}
	
	public MemberStateVO checkSubscript(String username) throws Exception {
		MemberStateVO memberStateVO = userDAO.checkSubscript(username);
		
		return memberStateVO;
	}
	
	public int startSubscript(MemberStateVO memberStateVO) throws Exception {
		int result = userDAO.startSubscript(memberStateVO);
		
		return result;
	}
	
	public int cancelSubscript(MemberStateVO memberStateVO) throws Exception {
		int result = userDAO.cancelSubscript(memberStateVO);
		
		return result;
	}
	
	public int stopSubscript(MemberStateVO memberStateVO) throws Exception {
		int result = userDAO.stopSubscript(memberStateVO);
		
		return result;
	}
	

	// 트레이너 스케쥴 등록 할때 트레이너/일반회원 구분하기 위해
    public List<UserVO> getUsersByUsernamePrefix(String prefix) {
        return userDAO.selectUsersByUsernamePrefix(prefix);
    }



	public int update(UserVO userVO) throws Exception {
		int result = userDAO.update(userVO);
		
		return result;
	}
	
	//트레이너등급 이상 회원들의 부서정보와 함께 조희
	public List<UserVO> getUsersWithDepartment() throws Exception {
		return userDAO.getUsersWithDepartment();
	}
	
	//트레이너등급 이상 부서가없는 회원들의 정보 조회
	public List<UserVO> getUsersNoDepartment() throws Exception {
		return userDAO.getUsersNoDepartment();
	}

	//부서들 정보 가져오기
	public List<DepartmentVO> getDepartments() throws Exception {
		return userDAO.getDepartments();
	}
	
	//부서 정보 가져오기
	public DepartmentVO getDepartment(DepartmentVO departmentVO) throws Exception {
		return userDAO.getDepartment(departmentVO);
	}
	
	//작성한 전자결재목록 불러오기
	public List<DocumentVO> getDocuments(DocumentVO documentVO) throws Exception {
		return userDAO.getDocuments(documentVO);
	}
	
	//작성한 전자결재디테일 불러오기
	public DocumentVO getDocument(DocumentVO documentVO) throws Exception {
		return userDAO.getDocument(documentVO);
	}
	
	//서명 or 도장 정보 가져오기
	public UserSignatureVO getSign(UserVO userVO) throws Exception {
		return userDAO.getSign(userVO);
	}
	
	//부서 추가
	public int addDepartment(DepartmentVO departmentVO) throws Exception {
		return userDAO.addDepartment(departmentVO);
	}
	
	//부서 수정
	public int updateDepartment(DepartmentVO departmentVO) throws Exception {
		return userDAO.updateDepartment(departmentVO);
	}
	
	//부서 삭제
	public int deleteDepartment(DepartmentVO departmentVO) throws Exception {
		return userDAO.deleteDepartment(departmentVO);
	}
	
	//해당 회원의 부서정보 변경
	public int updateDeptByUser(UserVO userVO, DepartmentVO departmentVO) throws Exception {
		Map<String, Object> map = new HashMap<>();
		
		if(departmentVO.getDepartmentId() != null) {
			UserVO parent = new UserVO();
			parent = userDAO.getParent(departmentVO);
			
			if(parent == null) {
				map.put("parent", "admin");
				map.put("position", "DP1");
			}else {
				map.put("parent", parent.getUsername());
				map.put("position", "DP0");
			}
			
			map.put("username", userVO.getUsername());
			map.put("departmentId", departmentVO.getDepartmentId());
		}else {
			
			map.put("parent", null);
			map.put("username", userVO.getUsername());
			map.put("departmentId", null);
			map.put("position", null);
		}
		
		return userDAO.updateDeptByUser(map);		
		
	}
	
	//해당 부서의 새로운 부서장 임명
	public int updateHeadOfDept(UserVO userVO, DepartmentVO departmentVO) throws Exception {
		int result = 0;
		Map<String, Object> map = new HashMap<>();
		
		result = userDAO.deleteHead(departmentVO);
		if(result > 0) {
			result = userDAO.addHead(userVO);
			if(result > 0) {
				map.put("username", userVO.getUsername());
				map.put("departmentId", departmentVO.getDepartmentId());
				
				result = userDAO.updateParent(map);
			}
		}
		
		return result;
	}
	
	
}
