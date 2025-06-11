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

@Service
public class ReservationService {

	@Autowired
	private ReservationDAO reservationDAO;

	@Autowired
	private ScheduleDAO scheduleDAO;

	


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
		
		
		 if (reservationDAO.countByUserAndSchedule(vo.getUsername(), vo.getScheduleId()) > 0) {
	            throw new IllegalStateException("이미 이 일정에 예약하셨습니다.");
	        }		
		 
		 
		 LocalDateTime now = LocalDateTime.now();
		 int year = now.getYear();
		 int month = now.getMonthValue();
		 int monthlyCount = reservationDAO.countByUsernameAndMonth(username, year, month);
		 if (monthlyCount >= 15) {
			 
			 throw new IllegalStateException(
					 "한 달 최대 15회까지 예약 가능 (현재 "+ monthlyCount + "회 예약됨)"
					 );
			 
		 }
		 
		 
		 
		 	
		
		vo.setCreatedAt(LocalDateTime.now());
		reservationDAO.insertReservation(vo);

		// 남은좌석 1 감소
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
