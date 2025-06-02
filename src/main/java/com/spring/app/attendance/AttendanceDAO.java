package com.spring.app.attendance;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AttendanceDAO {

	
	public int insertCheckIn(AttendanceVO Vo);
	public int updateCheckOut(AttendanceVO Vo);
	public List<AttendanceVO> selectByUser(String username);
	public List<AttendanceVO> selectByDate(LocalDate date);
	public List<AttendanceVO> selectAll();
	
	
	
}
