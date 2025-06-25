package com.spring.app.websocket;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.spring.app.home.util.Pager;
import com.spring.app.user.UserVO;

@Mapper
public interface NotificationDAO {
	
	//해당 사용자의 안읽은 알림 목록 조회
	public List<NotificationVO> getUnread(UserVO userVO) throws Exception;
	
	//로그인한 유저의 알림 리스트 조회
	public List<NotificationVO> getList(NotificationVO notificationVO) throws Exception;
	
	//알림 디테일 조회
	public NotificationVO getDetail(NotificationVO notificationVO) throws Exception;
	
	//읽지 않은 알림 수 조회
	public Long getUnreadCount(NotificationVO notificationVO) throws Exception;
	
	//알림 정보 추가
	public int add(NotificationVO notificationVO) throws Exception;
	
	//읽음으로 변경
	public int updateIsRead(NotificationVO notificationVO) throws Exception;
	
	//송신자 이름 조회
	public String getSenderName(String username) throws Exception;
	
	public Long getNotificationCount(NotificationVO notificationVO) throws Exception;
}
