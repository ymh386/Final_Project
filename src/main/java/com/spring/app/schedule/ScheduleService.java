package com.spring.app.schedule;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ScheduleService {

	
	@Autowired
	private ScheduleDAO scheduleDAO;
	
	
    public List<ScheduleVO> getAllSchedules() {
        return scheduleDAO.selectAll();
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
    
	
}
