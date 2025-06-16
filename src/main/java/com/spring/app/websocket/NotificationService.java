package com.spring.app.websocket;

import java.util.List;

import javax.management.Notification;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.user.UserVO;

@Service
public class NotificationService {
	
	@Autowired
	private NotificationDAO notificationDAO;
	
	//로그인한 사용자의 읽지않은 알림 가져오기
	public List<NotificationVO> getUnread(UserVO userVO) throws Exception {
		return notificationDAO.getUnread(userVO);
	}
	
	//읽지 않은 알림 수 조회
	public Long getUnreadCount(NotificationVO notificationVO) throws Exception {
		return notificationDAO.getUnreadCount(notificationVO);
	}
	
	//알림 정보 추가
	public int add(NotificationVO notificationVO) throws Exception {
		return notificationDAO.add(notificationVO);
	}
	
	//알림 읽음으로 변경
	public int updateIsRead(NotificationVO notificationVO) throws Exception {
		return notificationDAO.updateIsRead(notificationVO);
	}

}
