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

import com.spring.app.schedule.ScheduleDAO;
import com.spring.app.subscript.SubscriptDAO;

@Service
public class ReservationService {

	@Autowired
	private ReservationDAO reservationDAO;

	@Autowired
	private ScheduleDAO scheduleDAO;

	@Autowired
	private SubscriptDAO subscriptionDAO;
	


	@Transactional(readOnly = true)
	public ReservationVO getReservation(Long reservationId) {
		return reservationDAO.selectReservation(reservationId);
	}

	@Transactional(readOnly = true)
	public List<ReservationVO> getReservationsBySchedule(Long scheduleId) {
		return reservationDAO.selectBySchedule(scheduleId);
	}

	  @Transactional
	    public void reserve(ReservationVO vo) {
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
	    }
	

	@Transactional
	public void cancel(ReservationVO vo) {
		vo.setCanceledAt(LocalDateTime.now());
		vo.setUpdatedAt(LocalDateTime.now());
		reservationDAO.cancelReservation(vo);

		// 남은좌석 1증가
		scheduleDAO.incrementRemainingSeats(vo.getScheduleId());
	}

	public List<ReservationVO> getReservationsByUsername(String username) {
		return reservationDAO.selectByUsername(username);
	}

	public List<Map<String, Object>> getEvent(String username) {

		return reservationDAO.selectMember(username).stream().map(row -> {
			Map<String, Object> evt = new HashMap<>();
			evt.put("id", row.get("reservationId"));
			evt.put("title", "예약: " + row.get("facilityName"));
			evt.put("start", row.get("scheduleDate") + "T" + row.get("startTime"));
			evt.put("end", row.get("scheduleDate") + "T" + row.get("endTime"));
			evt.put("allDay", false);
			return evt;
		}).collect(Collectors.toList());

	}
	

}
