package com.spring.app.reservation;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.spring.app.schedule.ScheduleVO;

@Mapper
public interface ReservationDAO {
	
	public int insertReservation(ReservationVO vo);
	public ReservationVO selectById(Long reservationId);
	//특정 좌석 1감소
	public int decreaseRemainingSeats(Long scheduleId);
	//특정 좌석 1증가
	int increaseRemainingSeats(Long scheduleId);
	//트레이너중 예약 가능 목록
	List<ScheduleVO> selectAvailableSchedules(Map<String, Object> params);

	
	
	
}
