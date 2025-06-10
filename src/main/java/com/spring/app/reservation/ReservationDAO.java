package com.spring.app.reservation;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.spring.app.schedule.ScheduleVO;

@Mapper
public interface ReservationDAO {
    /** 1) 예약 상세 조회 */
    ReservationVO selectReservation(Long reservationId);

    /** 2) 일정별 예약 목록 조회 */
    List<ReservationVO> selectBySchedule(Long scheduleId);
    
    // 유저 별 리스트 조회
    List<ReservationVO> selectByUsername(String username);

    /** 3) 새 예약 삽입 */
    void insertReservation(ReservationVO vo);

    /** 4) 예약 취소 처리 */
    void cancelReservation(ReservationVO vo);
    
    List<Map<String,Object>> selectMember(@Param ("username")String username);
    
    int countByUserAndSchedule(
            @Param("username")   String username,
            @Param("scheduleId") Long scheduleId
        );
    
    
    
    
}
