package com.spring.app.user;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserDAO {
	
	int join(UserVO userVO) throws Exception;
	
	int trainerJoin(UserVO userVO) throws Exception;
	
	Long getTrainerCode() throws Exception;
	
	UserVO detail(UserVO userVO) throws Exception;
	
	List<UserVO> awaitUserList(UserVO userVO) throws Exception;

}
