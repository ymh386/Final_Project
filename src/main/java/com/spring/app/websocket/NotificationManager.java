package com.spring.app.websocket;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Component;

import com.spring.app.approval.ApprovalVO;
import com.spring.app.approval.DocumentVO;
import com.spring.app.board.notice.NoticeDAO;
import com.spring.app.chat.ChatMessageVO;
import com.spring.app.chat.ChatRoomVO;
import com.spring.app.chat.RoomMemberVO;
import com.spring.app.user.MemberStateVO;
import com.spring.app.equipment.EquipmentFaultVO;
import com.spring.app.reservation.ReservationVO;
import com.spring.app.schedule.ScheduleVO;
import com.spring.app.user.UserVO;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class NotificationManager {
	
	@Autowired
	private NotificationDAO notificationDAO;
	
	//서버에서 클라이언트로 메세지를 보내기 위한 도구
	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	
	//알림 보내기
	public void sendNotification (NotificationVO notificationVO) throws Exception {
		LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));
		Timestamp timestamp = Timestamp.valueOf(now);
		notificationVO.setCreatedAt(timestamp);
		
		int result = 1;
		
		//채팅메세지는 DB기록 X
		if(!"N0".equals(notificationVO.getNotificationType())) {
			result = notificationDAO.add(notificationVO);
			notificationVO = notificationDAO.getDetail(notificationVO);
		}
		
		log.info("알림VO : {}", notificationVO);
		
		if(result > 0) {
			//해당 경로로 메세지를 보내면, 그 사용자에게 알림이 도착
			messagingTemplate.convertAndSend("/topic/notify/".concat(notificationVO.getUsername()), notificationVO);	
		}
		System.out.println(notificationVO);
		
	}
	
	//결재 숭인 요청
	public void approvalNotification(ApprovalVO approvalVO, UserVO userVO) throws Exception {
		NotificationVO notificationVO = new NotificationVO();
		notificationVO.setNotificationTitle("결재 승인 요청");
		notificationVO.setUsername(approvalVO.getApproverId());
		notificationVO.setMessage("승인 요청이 왔습니다. 확인해주세요.");
		notificationVO.setLinkUrl("/approval/awaitDetail?approvalId=".concat(approvalVO.getApprovalId().toString()));
		notificationVO.setNotificationType("N6");
		notificationVO.setSenderId(userVO.getUsername());
		
		this.sendNotification(notificationVO);
	}
	
	//결재 승인
	public void approvedNotification(DocumentVO documentVO, UserVO userVO) throws Exception {
		NotificationVO notificationVO = new NotificationVO();
		notificationVO.setNotificationTitle("결재 승인");
		notificationVO.setUsername(documentVO.getWriterId());
		notificationVO.setMessage("요청하신 결재가 승인되었습니다.");
		notificationVO.setLinkUrl("/user/getDocument?documentId=".concat(documentVO.getDocumentId().toString()));
		notificationVO.setNotificationType("N7");
		notificationVO.setSenderId(userVO.getUsername());
		
		this.sendNotification(notificationVO);
	}
	
	//결재문서 최종 승인
	public void appOrRejNotification(DocumentVO documentVO, UserVO userVO) throws Exception {
		NotificationVO notificationVO = new NotificationVO();
		log.info("documentVO {}", documentVO);
		if("D1".equals(documentVO.getDocumentStatus())) {
			notificationVO.setNotificationTitle("결재문서 최종 승인");
			notificationVO.setMessage("요청하신 결재가 최종 승인되었습니다.");
		}else {
			notificationVO.setNotificationTitle("전자결재 반려");
			notificationVO.setMessage("요청하신 결재가 반려되었습니다.");
		}
		notificationVO.setUsername(documentVO.getWriterId());
		notificationVO.setLinkUrl("/user/getDocument?documentId=".concat(documentVO.getDocumentId().toString()));
		notificationVO.setNotificationType("N8");
		notificationVO.setSenderId(userVO.getUsername());
		
		this.sendNotification(notificationVO);
	}
	
	//채팅메세지
	public void messageNotification(ChatMessageVO chatMessageVO, List<RoomMemberVO> ar) throws Exception {
		String senderName = notificationDAO.getSenderName(chatMessageVO.getSenderId());
		NotificationVO notificationVO = null;
		
		for(RoomMemberVO roomMemberVO : ar) {
			
			if(chatMessageVO.getSenderId().equals(roomMemberVO.getUsername())) {
				continue;
			}
			
			notificationVO = new NotificationVO();
			notificationVO.setNotificationTitle("채팅 메세지");
			notificationVO.setUsername(roomMemberVO.getUsername());
			notificationVO.setMessage(chatMessageVO.getContents());
			notificationVO.setLinkUrl("/chat/list");
			notificationVO.setNotificationType("N0");
			notificationVO.setSenderId(chatMessageVO.getSenderId());
			
			UserVO senderVO = notificationVO.getSenderVO();
			if(senderVO == null) {
				senderVO = new UserVO();
				notificationVO.setSenderVO(senderVO);
			}
			senderVO.setName(senderName);
			
			this.sendNotification(notificationVO);
		}
		
	}
	
	//강퇴 알림
	public void kickNotification(RoomMemberVO memberVO, ChatRoomVO chatRoomVO, String username) throws Exception {
		String senderName = notificationDAO.getSenderName(chatRoomVO.getCreatedBy());
		NotificationVO notificationVO = new NotificationVO();
		
		notificationVO.setNotificationTitle("강퇴 알림");
		notificationVO.setUsername(username);
		notificationVO.setMessage("방장에 의해 강퇴당했습니다.");
		notificationVO.setLinkUrl("/chat/list");
		notificationVO.setNotificationType("N9");
		notificationVO.setSenderId(chatRoomVO.getCreatedBy());
		
		UserVO senderVO = notificationVO.getSenderVO();
		if (senderVO == null) {
			senderVO = new UserVO();
			notificationVO.setSenderVO(senderVO);
		}
		senderVO.setName(senderName);
		
		this.sendNotification(notificationVO);
	}
	
	//초대 알림
	public void inviteNotification(RoomMemberVO memberVO, ChatRoomVO chatRoomVO, String sender, String username) throws Exception {
		String senderName = notificationDAO.getSenderName(sender);
		NotificationVO notificationVO = new NotificationVO();
		
		notificationVO.setNotificationTitle("초대 알림");
		notificationVO.setUsername(username);
		notificationVO.setMessage("채팅에 초대되었습니다.");
		notificationVO.setLinkUrl("/chat/list");
		notificationVO.setNotificationType("N1");
		notificationVO.setSenderId(sender);
		
		UserVO senderVO = notificationVO.getSenderVO();
		if (senderVO == null) {
			senderVO = new UserVO();
			notificationVO.setSenderVO(senderVO);
		}
		senderVO.setName(senderName);
		
		this.sendNotification(notificationVO);
	}
	
	//방장 위임 알림
	public void getHostNotification(ChatRoomVO chatRoomVO, String username) throws Exception {
		String senderName = notificationDAO.getSenderName(chatRoomVO.getCreatedBy());
		NotificationVO notificationVO = new NotificationVO();
		
		notificationVO.setNotificationTitle("방장 권한 위임");
		notificationVO.setUsername(username);
		notificationVO.setMessage("방장에 대한 권한을 위임받았습니다.");
		notificationVO.setLinkUrl("/chat/detail/"+chatRoomVO.getRoomId());
		notificationVO.setNotificationType("N10");
		notificationVO.setSenderId(chatRoomVO.getCreatedBy());
		
		UserVO senderVO = notificationVO.getSenderVO();
		if (senderVO == null) {
			senderVO = new UserVO();
			notificationVO.setSenderVO(senderVO);
		}
		senderVO.setName(senderName);
		
		this.sendNotification(notificationVO);
	}
	
	//일정 부여 알림
	public void scheduleNotification(ScheduleVO scheduleVO) throws Exception {
		NotificationVO notificationVO = new NotificationVO();
		notificationVO.setNotificationTitle("일정 추가");
		notificationVO.setUsername(scheduleVO.getUsername());
		notificationVO.setMessage("일정이 추가되었습니다. 확인해주세요.\n"
				+ scheduleVO.getScheduleDate() + " " + scheduleVO.getStartTime() + " ~ " + scheduleVO.getEndTime());
		notificationVO.setLinkUrl("/schedule/page");
		notificationVO.setNotificationType("N11");
		notificationVO.setSenderId("admin");
		
		this.sendNotification(notificationVO);
	}
	
	//일정 취소 알림
	public void cancelScheduleNotification(ScheduleVO scheduleVO) throws Exception {
		NotificationVO notificationVO = new NotificationVO();
		notificationVO.setNotificationTitle("일정 취소");
		notificationVO.setUsername(scheduleVO.getUsername());
		notificationVO.setMessage("일정이 취소되었습니다. 확인해주세요.\n"
				+ scheduleVO.getScheduleDate() + " " + scheduleVO.getStartTime() + " ~ " + scheduleVO.getEndTime());
		notificationVO.setLinkUrl("/schedule/page");
		notificationVO.setNotificationType("N12");
		notificationVO.setSenderId("admin");
		
		this.sendNotification(notificationVO);
	}
	
	
	
	//수업 예약
	public void reserveNotification(ReservationVO reservationVO) throws Exception {
		NotificationVO notificationVO = null;
		
		//예약자에게 알림
		notificationVO = new NotificationVO();
		
		notificationVO.setNotificationTitle("수업 예약 완료");
		notificationVO.setUsername(reservationVO.getUsername());
		notificationVO.setMessage("수업 예약이 완료되었습니다.\n"
				+ "예약정보\n"
				+ "- 예약자명 : " + reservationVO.getUserVO().getName() + "\n"
				+ "- " + reservationVO.getScheduleVO().getScheduleDate() + " " + reservationVO.getScheduleVO().getStartTime() + " ~ " + reservationVO.getScheduleVO().getEndTime() +"\n"
				+ "- 트레이너명 : " + reservationVO.getScheduleVO().getUserVO().getName() + "\n"
				+ "- 시설명 : " + reservationVO.getFacilityVO().getName() + "(" + reservationVO.getFacilityVO().getLocation() + ")");
		notificationVO.setLinkUrl("/reservation/my");
		notificationVO.setNotificationType("N4");
		notificationVO.setSenderId(reservationVO.getScheduleVO().getUsername());
		
		this.sendNotification(notificationVO);
		
		//트레이너에게 알림
		notificationVO = new NotificationVO();
		
		notificationVO.setNotificationTitle("수업 예약 완료");
		notificationVO.setUsername(reservationVO.getScheduleVO().getUsername());
		notificationVO.setMessage("수업 예약이 완료되었습니다.\n"
				+ "예약정보\n"
				+ "- 예약자명 : " + reservationVO.getUserVO().getName() + "\n"
				+ "- " + reservationVO.getScheduleVO().getScheduleDate() + " " + reservationVO.getScheduleVO().getStartTime() + " ~ " + reservationVO.getScheduleVO().getEndTime() +"\n"
				+ "- 트레이너명 : " + reservationVO.getScheduleVO().getUserVO().getName() + "\n"
				+ "- 시설명 : " + reservationVO.getFacilityVO().getName() + "(" + reservationVO.getFacilityVO().getLocation() + ")");
		notificationVO.setLinkUrl("/schedule/page");
		notificationVO.setNotificationType("N4");
		notificationVO.setSenderId(reservationVO.getUsername());
		
		this.sendNotification(notificationVO);
	}
	
	//수업 예약 취소
	public void cancelReserveNotification(ReservationVO reservationVO) throws Exception {
		
		NotificationVO notificationVO = null;
		
		//예약자에게 알림
		notificationVO = new NotificationVO();
		
		notificationVO.setNotificationTitle("수업 예약 취소");
		notificationVO.setUsername(reservationVO.getUsername());
		notificationVO.setMessage("수업 예약이 취소되었습니다.\n"
				+ "예약정보\n"
				+ "- 예약자명 : " + reservationVO.getUserVO().getName() + "\n"
				+ "- " + reservationVO.getScheduleVO().getScheduleDate() + " " + reservationVO.getScheduleVO().getStartTime() + " ~ " + reservationVO.getScheduleVO().getEndTime() +"\n"
				+ "- 트레이너명 : " + reservationVO.getScheduleVO().getUserVO().getName() + "\n"
				+ "- 시설명 : " + reservationVO.getFacilityVO().getName() + "(" + reservationVO.getFacilityVO().getLocation() + ")\n\n"
				+ "취소 사유 : " + reservationVO.getCanceledReason());
		notificationVO.setLinkUrl("/reservation/my");
		notificationVO.setNotificationType("N5");
		notificationVO.setSenderId(reservationVO.getScheduleVO().getUsername());
		
		this.sendNotification(notificationVO);

		
		//트레이너에게 알림
		notificationVO = new NotificationVO();
		
		notificationVO.setNotificationTitle("수업 예약 취소");
		notificationVO.setUsername(reservationVO.getScheduleVO().getUsername());
		notificationVO.setMessage("수업 예약이 취소되었습니다.\n"
				+ "예약자명 : " + reservationVO.getUserVO().getName() + "\n"
				+ "- " + reservationVO.getScheduleVO().getScheduleDate() + " " + reservationVO.getScheduleVO().getStartTime() + " ~ " + reservationVO.getScheduleVO().getEndTime() +"\n"
				+ "- 트레이너명 : " + reservationVO.getScheduleVO().getUserVO().getName() + "\n"
				+ "- 시설명 : " + reservationVO.getFacilityVO().getName() + "(" + reservationVO.getFacilityVO().getLocation() + ")\n\n"
				+ "취소 사유 : " + reservationVO.getCanceledReason());
		notificationVO.setLinkUrl("/schedule/page");
		notificationVO.setNotificationType("N5");
		notificationVO.setSenderId(reservationVO.getUsername());
		
		this.sendNotification(notificationVO);
	}
	
	//구독권 하루 남았을때 알림
	public void SubscribeWarningNotification(MemberStateVO memberStateVO, String username) throws Exception {
		String senderName = notificationDAO.getSenderName(memberStateVO.getUsername());
		NotificationVO notificationVO = new NotificationVO();
		
		notificationVO.setNotificationTitle("구독권 종료 임박");
		notificationVO.setUsername(username);
		notificationVO.setMessage("구독권 정기 결제가 하루 남았습니다.");
		notificationVO.setLinkUrl("/user/mypage");
		notificationVO.setNotificationType("N2");
		notificationVO.setSenderId(memberStateVO.getUsername());
		
		UserVO senderVO = notificationVO.getSenderVO();
		if (senderVO == null) {
			senderVO = new UserVO();
			notificationVO.setSenderVO(senderVO);
		}
		senderVO.setName(senderName);
		
		this.sendNotification(notificationVO);
	}
	
	//구독권 결제 완료
	public void SubscribePayNotification(MemberStateVO memberStateVO, String username) throws Exception {
		String senderName = notificationDAO.getSenderName(memberStateVO.getUsername());
		NotificationVO notificationVO = new NotificationVO();
		
		notificationVO.setNotificationTitle("구독권 결제 완료");
		notificationVO.setUsername(username);
		notificationVO.setMessage("구독권 정기 결제가 완료되었습니다..");
		notificationVO.setLinkUrl("/user/mypage");
		notificationVO.setNotificationType("N3");
		notificationVO.setSenderId(memberStateVO.getUsername());
		
		UserVO senderVO = notificationVO.getSenderVO();
		if (senderVO == null) {
			senderVO = new UserVO();
			notificationVO.setSenderVO(senderVO);
		}
		senderVO.setName(senderName);
		
		this.sendNotification(notificationVO);
	}
	
	//비품 신고접수 알림
	public void reportNotification(EquipmentFaultVO equipmentFaultVO) throws Exception {
		NotificationVO notificationVO = null;
		
		notificationVO = new NotificationVO();
		notificationVO.setNotificationTitle("비품 신고 접수");
		notificationVO.setUsername(equipmentFaultVO.getUsername());
		notificationVO.setMessage("비품 신고가 접수되었습니다.\n"
				+ "(" + equipmentFaultVO.getEquipmentLocation() + " - " + equipmentFaultVO.getEquipmentName() + ")");
		notificationVO.setLinkUrl("/equipment/main");
		notificationVO.setNotificationType("N13");
		notificationVO.setSenderId("admin");
		
		this.sendNotification(notificationVO);
		
		notificationVO = new NotificationVO();
		notificationVO.setNotificationTitle("비품 신고 접수");
		notificationVO.setUsername("admin");
		notificationVO.setMessage("비품 신고요청이 왔습니다. 확인해주세요.\n"
				+ "(" + equipmentFaultVO.getEquipmentLocation() + " - " + equipmentFaultVO.getEquipmentName() + ")");
		notificationVO.setLinkUrl("/equipment/admin");
		notificationVO.setNotificationType("N13");
		notificationVO.setSenderId(equipmentFaultVO.getUsername());
		
		this.sendNotification(notificationVO);
		
	}
	
	//비품 신고 진행상황 알림
	public void reportingNotification(EquipmentFaultVO equipmentFaultVO) throws Exception {
		NotificationVO notificationVO = new NotificationVO();
		
		if("처리완료".equals(equipmentFaultVO.getFaultStatus())) {
			notificationVO.setMessage("비품 신고가 처리 완료되었습니다.\n"
					+ "(" + equipmentFaultVO.getEquipmentLocation() + " - " + equipmentFaultVO.getEquipmentName() + ")");
		}else {
			notificationVO.setMessage("비품 신고 처리 중 입니다.\n"
					+ "(" + equipmentFaultVO.getEquipmentLocation() + " - " + equipmentFaultVO.getEquipmentName() + ")");
		}
		
		notificationVO.setNotificationTitle("비품 신고 진행상황");
		notificationVO.setUsername(equipmentFaultVO.getUsername());
		notificationVO.setLinkUrl("/equipment/main");
		notificationVO.setNotificationType("N14");
		notificationVO.setSenderId("admin");
		
		this.sendNotification(notificationVO);
	}
}
