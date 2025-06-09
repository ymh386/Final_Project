package com.spring.app.user;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserDAO {
	
	int join(UserVO userVO) throws Exception;
	
	int trainerJoin(UserVO userVO) throws Exception;
	
	Long getTrainerCode() throws Exception;
	
	UserVO detail(UserVO userVO) throws Exception;
	
	List<UserVO> awaitUserList(UserVO userVO) throws Exception;
	
	int updateUserState(MemberStateVO memberStateVO) throws Exception;
	

	List<UserVO> selectUsersByUsernamePrefix(@Param("prefix") String prefix);
	
	int update(UserVO userVO) throws Exception;
	
	//트레이너등급 이상 회원들의 부서정보와 함께 조희
	List<UserVO> getUsersWithDepartment() throws Exception;
	
	//부서등 정보 가져오기
	List<DepartmentVO> getDepartments() throws Exception;
}
