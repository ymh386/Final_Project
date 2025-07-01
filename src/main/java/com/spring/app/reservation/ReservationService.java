package com.spring.app.reservation;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.auditLog.AuditLogService;
import com.spring.app.schedule.ScheduleDAO;
import com.spring.app.schedule.ScheduleVO;
import com.spring.app.subscript.SubscriptDAO;
import com.spring.app.websocket.NotificationManager;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class ReservationService {

	@Autowired
	private ReservationDAO reservationDAO;

	@Autowired
	private ScheduleDAO scheduleDAO;

	@Autowired
	private SubscriptDAO subscriptionDAO;
	
	@Autowired
    private NotificationManager notificationManager;
	
    @Autowired 
    private AuditLogService auditLogService;
	


	@Transactional(readOnly = true)
	public ReservationVO getReservation(Long reservationId) {
		return reservationDAO.selectReservation(reservationId);
	}

	@Transactional(readOnly = true)
	public List<ReservationVO> getReservationsBySchedule(Long scheduleId) {
		return reservationDAO.selectBySchedule(scheduleId);
	}

	  @Transactional
	    public void reserve(ReservationVO vo, HttpServletRequest request) {
	        String username = vo.getUsername();

	        // 0) 활성 구독 여부 확인
	        int activeCount = subscriptionDAO.countActiveByUser(username);
	        if (activeCount == 0) {
	            throw new IllegalStateException("구독한 회원만 예약할 수 있습니다.");
	        }

	        // 1) 이미 같은 스케줄에 예약했는지 검사
	        if (reservationDAO.countByUserAndSchedule(username, vo.getScheduleId()) > 0) {
	            throw new IllegalStateException("이미 이 일정에 예약하셨습니다.");
	        }

	        // 2) 이번 달 예약 횟수 검사 (한 달 최대 15회)
	        LocalDateTime now = LocalDateTime.now();
	        int year  = now.getYear();
	        int month = now.getMonthValue();
	        int monthlyCount = reservationDAO.countByUsernameAndMonth(username, year, month);
	        if (monthlyCount >= 15) {
	            throw new IllegalStateException(
	                "한 달 최대 15회까지 예약 가능 (현재 " + monthlyCount + "회 예약됨)"
	            );
	        }

	        // 3) 예약 생성
	        vo.setCreatedAt(now);
	        int rows = reservationDAO.insertReservation(vo);
	        if (rows == 0) {
	            // (이 경우는 거의 없겠지만) 안전장치로…
	            throw new IllegalStateException("예약 처리에 실패했습니다.");
	        }

	        // 4) 남은 좌석 1 감소
	        scheduleDAO.decrementRemainingSeats(vo.getScheduleId());
	        
	      // 5) 예약성공 알림보내기
            try {
            	vo = reservationDAO.selectOneMember(vo);
				notificationManager.reserveNotification(vo);
				
				// 로그/감사 기록용
				auditLogService.log(
						vo.getUsername(),
				        "RESERVE_CLASS",
				        "RESERVATION",
				        vo.getReservationId().toString(),
				        vo.getUsername() + "이 "
				        + vo.getScheduleVO().getScheduleDate() + " "
				        + vo.getScheduleVO().getStartTime() + " ~ " + vo.getScheduleVO().getEndTime() + "시간의 "
				        + vo.getScheduleVO().getUsername() + "의 수업을 예약",
				        request
				    );
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }
	

	@Transactional
	public void cancel(ReservationVO vo, HttpServletRequest request) {
		
		
		vo.setCanceledAt(LocalDateTime.now());
		vo.setUpdatedAt(LocalDateTime.now());
				
		
		reservationDAO.cancelReservation(vo);

		// 남은좌석 1증가
		scheduleDAO.incrementRemainingSeats(vo.getScheduleId());
		
		// 예약취소 알림
		try {
			vo = reservationDAO.selectOneMember(vo);
			notificationManager.cancelReserveNotification(vo);
			
			// 로그/감사 기록용
			auditLogService.log(
					vo.getUsername(),
			        "CANCEL_CLASS",
			        "RESERVATION",
			        vo.getReservationId().toString(),
			        vo.getUsername() + "이 "
			        + vo.getScheduleVO().getScheduleDate() + " "
			        + vo.getScheduleVO().getStartTime() + " ~ " + vo.getScheduleVO().getEndTime() + "에 있는"
			        + vo.getScheduleVO().getUsername() + "의 수업예약을 취소",
			        request
			    );
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	public List<ReservationVO> getReservationsByUsername(String username, int startRow, int pageSize) {
		
		return reservationDAO.getReservationsByUsernameWithPaging(username,startRow, pageSize);
		
	}

	public List<Map<String, Object>> getEvent(String username) {
	    return reservationDAO.selectMember(username).stream().map(row -> {
	        Map<String, Object> evt = new HashMap<>();
	        evt.put("id", row.get("reservationId"));
	        
	        // 시간 포맷팅
	        String startTime = row.get("startTime").toString().substring(0, 5); // HH:MM
	        String endTime = row.get("endTime").toString().substring(0, 5);     // HH:MM
	        
	        // 제목: "09:00-10:00\n김트레이너\n헬스장" 형태
	        String title = String.format("%s-%s\n%s\n%s", 
	            startTime, endTime, 
	            row.get("trainerName"),   // 트레이너명 추가
	            row.get("facilityName"));
	        evt.put("title", title);
	        
	        evt.put("start", row.get("scheduleDate") + "T" + row.get("startTime"));
	        evt.put("end", row.get("scheduleDate") + "T" + row.get("endTime"));
	        evt.put("allDay", false);
	        return evt;
	    }).collect(Collectors.toList());
	}
	
	
	//사용자 전체 예약 개수 조회
	 public long getTotalReservationCount(String username) {
	        return reservationDAO.countReservationsByUsername(username);
	    }
	 
	 public List<ScheduleVO> getFutureSchedules() {
		    LocalDate today = LocalDate.now();
		    return scheduleDAO.selectAll().stream()
		            .filter(s -> !s.getScheduleDate().isBefore(today))
		            .collect(Collectors.toList());
		}

	 
	 public Long countByUsernameAndMonth(String username) {
		    LocalDateTime now = LocalDateTime.now();
		    int year = now.getYear();
		    int month = now.getMonthValue();

		    return (long) reservationDAO.countByUsernameAndMonth(username, year, month);
		}
}
