package com.spring.app.attendance;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AttendanceDAO {

	
	public int insertCheckIn(AttendanceVO Vo);
	public int updateCheckOut(AttendanceVO Vo);
	public List<AttendanceVO> selectByUser(String username);
	public List<AttendanceVO> selectByDate(LocalDate date);
	public List<AttendanceVO> selectAll();
    public AttendanceVO selectByUserAndDate(
            @Param("username") String username,
            @Param("attendanceDate") LocalDate attendanceDate
        );
    
    public AttendanceVO selectById(@Param("attendanceId") Long attendanceId);
	
	
}
