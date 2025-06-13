package com.spring.app.user.friend;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface FriendDAO {
	
	//친구 목록 조회
	List<FriendVO> friendList(@Param("username") String username) throws Exception;
	
	//친구가 아닌 유저 목록 조회
	List<FriendVO> notFriendList(@Param("username") String username) throws Exception;
	
	//친구 요청 목록 조회
	List<FriendRequestVO> receiveList(@Param("username") String username) throws Exception;
	
	//내가 보낸 요청 목록 조회
	List<FriendRequestVO> requestList(@Param("username") String username) throws Exception;
	
	//친구 요청
	int friendRequest(FriendRequestVO friendRequestVO) throws Exception;
	
	//수락
	int accept(FriendRequestVO friendRequestVO) throws Exception;
	
	//친구 등록
	int newFriend(FriendVO friendVO) throws Exception;
	
	//기존 데이터 정리
	int cleanData(FriendRequestVO friendRequestVO) throws Exception;
	
	int deleteFriend(@Param("user1") String username, @Param("user2") String friend) throws Exception;

}
