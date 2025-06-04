package com.spring.app.attendance;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

@Service
public class AttendanceService {

	@Autowired
	public AttendanceDAO attendanceDAO;
	
	
    public AttendanceVO checkIn(String username) throws AttendanceException {
        LocalDate today = LocalDate.now();
        LocalTime nowTime = LocalTime.now();

        // ① “9:00 이전=정상출근, 9:00~9:30=지각, 9:30 이후=결근”
        LocalTime nine   = LocalTime.of(9, 0);
        LocalTime nine30 = LocalTime.of(9, 30);
        String status;
        if (nowTime.isBefore(nine) || nowTime.equals(nine)) {
            status = "정상출근";
        } else if (nowTime.isAfter(nine) && nowTime.isBefore(nine30)) {
            status = "지각";
        } else {
            status = "결근";
        }

        // ② 오늘자 동일 사용자 기록 조회
        AttendanceVO existing = attendanceDAO.selectByUserAndDate(username, today);
        if (existing != null) {
            throw new AttendanceException("이미 오늘 출근을 하셨습니다.");
        }

        // ③ 출근 기록 삽입
        AttendanceVO vo = new AttendanceVO();
        vo.setUsername(username);
        vo.setAttendanceDate(today);
        vo.setCheckinTime(nowTime);
        vo.setStatus(status);

        try {
            attendanceDAO.insertCheckIn(vo);
        } catch (DuplicateKeyException ex) {
            // 혹시 모를 중복키 예외 처리
            throw new AttendanceException("이미 오늘 출근 기록이 존재하여 등록할 수 없습니다.");
        }
        return vo;
    }

    public AttendanceVO checkOut(Long attendanceId) throws AttendanceException {
        // ① 퇴근 업데이트
        AttendanceVO vo = new AttendanceVO();
        vo.setAttendanceId(attendanceId);

        try {
            attendanceDAO.updateCheckOut(vo);
        } catch (Exception ex) {
            throw new AttendanceException("퇴근 처리에 실패했습니다.");
        }

        // ② 업데이트된 데이터를 다시 조회해서 리턴
        AttendanceVO updated = attendanceDAO.selectById(attendanceId);
        return updated;
    }
    
    
    

    public List<AttendanceVO> getAttendanceByUser(String username) {
        return attendanceDAO.selectByUser(username);
    }

	  
	  
	  public List<AttendanceVO> listByUser(String username){
		  
		  return attendanceDAO.selectByUser(username);
		  
	  }
	  
	  public List<AttendanceVO> listByDate(LocalDate date){
		  
		  return attendanceDAO.selectByDate(date);
	  }
	  
	  public List<AttendanceVO> listAll(){
		  
		  return attendanceDAO.selectAll();
	  }
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  

}