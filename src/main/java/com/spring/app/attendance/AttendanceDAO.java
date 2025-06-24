package com.spring.app.attendance;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AttendanceDAO {

	
	public int insertCheckIn(AttendanceVO Vo);
	public int updateCheckOut(AttendanceVO Vo);
	public List<AttendanceVO> selectByUser(String username);
	public List<Map<String, Object>>  selectByDate(LocalDate date);
	public List<AttendanceVO> selectAll();
    public AttendanceVO selectByUserAndDate(
            @Param("username") String username,
            @Param("attendanceDate") LocalDate attendanceDate
        );
    
    public AttendanceVO selectById(@Param("attendanceId") Long attendanceId);
    
    public void updateAttendance(AttendanceVO Vo);
    
    // 체크아웃 하지 않은 출석 기록 조회
    List<AttendanceVO> selectUncheckedOutAttendances(Map<String, Object> params);
    // 자동 결석 처리
    int updateToAutoAbsent(Map<String, Object> params);

	
	
}
