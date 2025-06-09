package com.spring.app.reservation;

import java.time.LocalDateTime;
import java.util.List;

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
	        vo.setCreatedAt(LocalDateTime.now());
	        reservationDAO.insertReservation(vo);
	        
	        //남은좌석 1 감소 
	        scheduleDAO.decrementRemainingSeats(vo.getScheduleId());
	    }

	    @Transactional
	    public void cancel(ReservationVO vo) {
	        vo.setCanceledAt(LocalDateTime.now());
	        vo.setUpdatedAt(LocalDateTime.now());
	        reservationDAO.cancelReservation(vo);
	        
	        //남은좌석 1증가
	        scheduleDAO.incrementRemainingSeats(vo.getScheduleId());
	    }
	    
	    public List<ReservationVO> getReservationsByUsername(String username) {
	        return reservationDAO.selectByUsername(username);
	    }
	    
	    
	
	
}
