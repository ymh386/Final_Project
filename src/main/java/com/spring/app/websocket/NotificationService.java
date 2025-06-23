package com.spring.app.websocket;

import java.util.List;

import javax.management.Notification;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.home.util.Pager;
import com.spring.app.user.UserVO;

@Service
public class NotificationService {
	
	@Autowired
	private NotificationDAO notificationDAO;
	
	//로그인한 사용자의 읽지않은 알림 가져오기
	public List<NotificationVO> getUnread(UserVO userVO) throws Exception {
		return notificationDAO.getUnread(userVO);
	}
	
	//로그인한 유저의 알림 리스트 조회
	public List<NotificationVO> getList(NotificationVO notificationVO, Pager pager) throws Exception {
		//LIMIT 절에 사용할 startRow, pageSize 계산
		pager.makeRow();
		//감사 기록 총 개수(해당 카테고리의 검색어 기준)
		notificationVO.setPager(pager);
		Long totalCount = notificationDAO.getNotificationCount(notificationVO);
		//총 개수를 토대로 페이지 생성
		pager.makePage(totalCount);
		notificationVO.setPager(pager);
		
		return notificationDAO.getList(notificationVO);
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
