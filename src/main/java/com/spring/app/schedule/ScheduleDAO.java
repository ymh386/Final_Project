package com.spring.app.schedule;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ScheduleDAO {

	
	public List<ScheduleVO> selectAll();
	public List<ScheduleVO> selectById(String username);
    public List<ScheduleVO> getSchedule(Long scheduleId);
	public void insertSchedule(ScheduleVO vo);
	public void deleteSchedule(Long scheduleId);
    // 남은 좌석 감소/증가
    void decrementRemainingSeats(@Param("scheduleId") Long scheduleId);
    void incrementRemainingSeats(@Param("scheduleId") Long scheduleId);
	
    /** 1) 스케줄에 등록된 모든 트레이너 이름(distinct) */
    List<String> selectAllTrainerNames();
    
    //트레이너ID 하나 조회
    public ScheduleVO selectOneUsername(Long scheduleId);


}
