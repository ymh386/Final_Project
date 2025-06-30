package com.spring.app.schedule;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;

@Service
public class ScheduleService {
	
	

	
	@Autowired
	private ScheduleDAO scheduleDAO;
	
	@Autowired	
	private UserService userService;
	
    public List<ScheduleVO> getAllSchedules() {
        return scheduleDAO.selectAll();
    }
    
    public List<ScheduleVO> getSchedule(Long scheduleId){
    	return scheduleDAO.getSchedule(scheduleId);
    	
    }
    
    
    public List<ScheduleVO> getScheduleById(String nsername) {
    	return scheduleDAO.selectById(nsername);
    }
    
    
   // @Transactional 을 붙여서 DB Insert/Delete 시 트랜잭션 보장
    @Transactional
    public void createSchedule(ScheduleVO vo) {
        scheduleDAO.insertSchedule(vo);
    }
    
    @Transactional
    public void deleteSchedule(Long scheduleId) {
        scheduleDAO.deleteSchedule(scheduleId);
    }
    
    
    public List<String> getAllTrainerNames() {
        return scheduleDAO.selectAllTrainerNames();
    }
    
  //트레이너ID 하나 조회
    public ScheduleVO selectOneUsername(Long scheduleId) {
    	return scheduleDAO.selectOneUsername(scheduleId);
    }
    
    
 // ScheduleService.java
    public List<Map<String, Object>> convertToCalendarEvents(List<ScheduleVO> schedules) {
        List<Map<String, Object>> events = new ArrayList();

        for (ScheduleVO vo : schedules) {
            // 트레이너 정보 조회
            UserVO trainer = (UserVO) userService.loadUserByUsername(vo.getUsername());
            String trainerName = (trainer != null) ? trainer.getName() : vo.getUsername();

            // 시설명 매핑
            String facilityName = getFacilityName(vo.getFacilityId());

            // 시간 포맷팅
            String startTime = formatTime(vo.getStartTime());
            String endTime = formatTime(vo.getEndTime());

            Map<String, Object> event = new HashMap<>();
            event.put("id", vo.getScheduleId().toString());
            event.put("title", String.format("%s-%s\n%s\n%s", startTime, endTime, trainerName, facilityName));

            LocalDateTime startDT = LocalDateTime.of(vo.getScheduleDate(), vo.getStartTime());
            LocalDateTime endDT = LocalDateTime.of(vo.getScheduleDate(), vo.getEndTime());
            event.put("start", startDT.toString());
            event.put("end", endDT.toString());

            event.put("backgroundColor", getFacilityColor(vo.getFacilityId()));
            event.put("borderColor", getFacilityColor(vo.getFacilityId()));
            event.put("textColor", "#ffffff");

            Map<String, Object> extendedProps = new HashMap();
            extendedProps.put("scheduleId", vo.getScheduleId());
            extendedProps.put("username", vo.getUsername());
            extendedProps.put("trainerName", trainerName);
            extendedProps.put("facilityId", vo.getFacilityId());
            extendedProps.put("facilityName", facilityName);
            extendedProps.put("scheduleDate", vo.getScheduleDate().toString());
            extendedProps.put("startTime", startTime);
            extendedProps.put("endTime", endTime);
            event.put("extendedProps", extendedProps);

            events.add(event);
        }

        return events;
    }
    
   private String getFacilityName(Long facilityId) {
       if (facilityId == null) return "미지정";
       
       switch (facilityId.intValue()) {
           case 1: return "복싱장";
           case 2: return "헬스장";
           case 3: return "수영장";
           default: return "시설" + facilityId;
       }
   }
   
   /**
    * 시설별 색상 지정
    */
   private String getFacilityColor(Long facilityId) {
       if (facilityId == null) return "#95a5a6";
       
       switch (facilityId.intValue()) {
           case 1: return "#e74c3c"; // 복싱장 - 빨간색
           case 2: return "#3498db"; // 헬스장 - 파란색
           case 3: return "#2ecc71"; // 수영장 - 초록색
           default: return "#95a5a6"; // 기본 - 회색
       }
   }
   
  private String formatTime(java.time.LocalTime time) {
      if (time == null) return "00:00";
      return time.format(DateTimeFormatter.ofPattern("HH:mm"));
  }




    
    
	
}
