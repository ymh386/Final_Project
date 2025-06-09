package com.spring.app.reservation;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.spring.app.schedule.ScheduleVO;

@Mapper
public interface ReservationDAO {
    // 1) 새 예약 삽입
    int insertReservation(ReservationVO vo);

    // 2) 예약 ID로 예약 정보 조회
    ReservationVO selectById(Long reservationId);

    // 3) 회원(username)별 예약 목록 조회 (최신순)
    List<ReservationVO> selectByUsername(String username);

    // 4) 예약 취소 시 canceledAt, canceledReason, updatedAt 업데이트
    int updateCancelReservation(Map<String, Object> params);

    // 5) 특정 일정(scheduleId)에 대해 남은 좌석(remainingSeats)을 1 감소
    int decreaseRemainingSeats(Long scheduleId);

    // 6) 예약 취소 시 일정(scheduleId)의 remainingSeats를 1 증가
    int increaseRemainingSeats(Long scheduleId);

    // 7) 특정 일정(scheduleId)과 회원(username)에 대해 이미 예약된 내역이 있는지 카운트
    int countByScheduleAndUser(Map<String, Object> params);
}
