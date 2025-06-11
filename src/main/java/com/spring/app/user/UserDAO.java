package com.spring.app.user;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.spring.app.approval.DocumentVO;
import com.spring.app.approval.UserSignatureVO;

@Mapper
public interface UserDAO {
	
	int join(UserVO userVO) throws Exception;
	
	int trainerJoin(UserVO userVO) throws Exception;
	
	int changePw(UserVO userVO) throws Exception;
	
	UserVO getUserByEmail(String email) throws Exception;
	
	Long getTrainerCode() throws Exception;
	
	UserVO detail(UserVO userVO) throws Exception;
	
	List<UserVO> awaitUserList(UserVO userVO) throws Exception;
	
	int updateUserState(MemberStateVO memberStateVO) throws Exception;
	
	List<MemberRoleVO> getRole(@Param("username") String username) throws Exception;
	
	MemberStateVO checkSubscript(@Param("username") String username) throws Exception;
	
	int startSubscript(MemberStateVO memberStateVO) throws Exception;
	
	int cancelSubscript(MemberStateVO memberStateVO) throws Exception;
	
	int stopSubscript(MemberStateVO memberStateVO) throws Exception;

	List<UserVO> selectUsersByUsernamePrefix(@Param("prefix") String prefix);
	
	int update(UserVO userVO) throws Exception;
	
	//트레이너등급 이상 회원들의 부서정보와 함께 조희
	List<UserVO> getUsersWithDepartment() throws Exception;
	
	//부서등 정보 가져오기
	List<DepartmentVO> getDepartments() throws Exception;
	
	//전재결재 작성목록 불러오기
	public List<DocumentVO> getDocuments(DocumentVO documentVO) throws Exception;
	
	//전자결재 작성 디테일 불러오기
	public DocumentVO getDocument(DocumentVO documentVO) throws Exception;
	
	//서명 OR 도장 가져오기
	public UserSignatureVO getSign(UserVO userVO) throws Exception;
	
}
