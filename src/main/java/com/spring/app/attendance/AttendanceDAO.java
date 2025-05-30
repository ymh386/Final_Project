package com.spring.app.attendance;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AttendanceDAO {

	
	public int insertCheckIn(AttendanceVO Vo);
	public int updateCheckOut(AttendanceVO Vo);
	
	
	
}
