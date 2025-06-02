package com.spring.app.schedule;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ScheduleDAO {

	
	public List<ScheduleVO> selectAll();
	public List<ScheduleVO> selectById(String username);
	public void insertSchedule(ScheduleVO vo);
	public void deleteSchedule(Long scheduleId);
	
	
}
