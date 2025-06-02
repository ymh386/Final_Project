package com.spring.app.attendance;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AttendanceService {

	@Autowired
	public AttendanceDAO attendanceDAO;
	
	
	  public AttendanceVO checkIn(String username) {
		    AttendanceVO vo = new AttendanceVO();
		    vo.setAttendanceDate(LocalDate.now());
		    vo.setCheckinTime(LocalTime.now());
		    vo.setUsername(username);
		    attendanceDAO.insertCheckIn(vo);
		    return vo;
	
}
	  
	  	  
	  public AttendanceVO checkOut(Long attendanceId) {
	    AttendanceVO vo = new AttendanceVO();
	    vo.setAttendanceId(attendanceId);
	    vo.setCheckoutTime(LocalTime.now());
	    attendanceDAO.updateCheckOut(vo);
	    return vo;
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