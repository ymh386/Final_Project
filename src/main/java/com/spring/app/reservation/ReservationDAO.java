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
    List<ReservationVO> getReservationsByUsernameWithPaging(
            @Param("username") String username, 
            @Param("startRow") int startRow, 
            @Param("pageSize") int pageSize);

    /** 3) 새 예약 삽입 */
    int insertReservation(ReservationVO vo);

    /** 4) 예약 취소 처리 */
    void cancelReservation(ReservationVO vo);
    
    List<Map<String,Object>> selectMember(@Param ("username")String username);
    
    int countByUserAndSchedule(
            @Param("username")   String username,
            @Param("scheduleId") Long scheduleId
        );
    
    // 한 달 동안 user가 한 예약 수 
    int countByUsernameAndMonth(@Param ("username") String username,
    							@Param ("year") int year,
    							@Param ("month") int month);
    
    
    /**
     * 사용자의 전체 예약 개수 조회
     */
    long countReservationsByUsername(String username);
    
    ReservationVO selectOneMember(ReservationVO reservationVO) throws Exception;
    
    List<Map<String, Object>> reservationHome(@Param("username")String username) throws Exception;
    
    
    
}
