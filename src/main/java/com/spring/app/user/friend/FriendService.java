package com.spring.app.user.friend;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FriendService {
	
	@Autowired
	private FriendDAO friendDAO;
	
	public List<FriendVO> friendList(String username) throws Exception {
		List<FriendVO> list = friendDAO.friendList(username);
		
		return list;
	}
	
	public List<FriendVO> notfriendList(String username) throws Exception {
		List<FriendVO> list = friendDAO.notFriendList(username);
		
		return list;
	}
	
	public List<FriendRequestVO> receiveList(String username) throws Exception {
		List<FriendRequestVO> list = friendDAO.receiveList(username);
		
		return list;
	}
	
	public List<FriendRequestVO> requestList(String username) throws Exception {
		List<FriendRequestVO> list = friendDAO.requestList(username);
		
		return list;
	}
	
	public int friendRequest(FriendRequestVO friendRequestVO) throws Exception {
		int result=friendDAO.friendRequest(friendRequestVO);
		
		return result;
	}
	
	public int accept(FriendRequestVO friendRequestVO) throws Exception {
		int result=friendDAO.accept(friendRequestVO);
		
		return result;
	}
	
	public int newFriend(FriendVO friendVO) throws Exception {
		int result = friendDAO.newFriend(friendVO);
		
		return result;
	}
	
	public int cleanData(FriendRequestVO friendRequestVO) throws Exception {
		int result=friendDAO.cleanData(friendRequestVO);
		
		return result;
	}
	
	public int deleteFriend(String username, String friend) throws Exception {
		int result = friendDAO.deleteFriend(username, friend);
		
		return result;
	}
	
	


}
