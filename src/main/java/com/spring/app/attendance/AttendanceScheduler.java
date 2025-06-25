package com.spring.app.attendance;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class AttendanceScheduler {

	
	@Autowired
	private AttendanceDAO attendanceDAO;
	
    @Scheduled(cron = "0 0 0 * * ?")
	public void processAutoAbsence() {
		try {
			
			//전날 날짜 계산 
			LocalDate yesterday = LocalDate.now().minusDays(1);
			System.out.println();
			String startDate = yesterday + " 00:00:00";
			String endDate = yesterday + " 23:59:59";
			String autoCheckOutTime = yesterday + " 23:59:59";
			
			//파라미터 설정
			Map<String, Object> params = new HashMap<>();
			params.put("startDate", startDate);
			params.put("endDate", endDate);
			// 미체크아웃 기록 조회
			List<AttendanceVO> uncheckedOutList=
					attendanceDAO.selectUncheckedOutAttendances(params);
			List<Long> attendanceIds = new ArrayList();
			
			
			
			
			if (!uncheckedOutList.isEmpty()) {
				attendanceIds = uncheckedOutList.stream()
						.map(AttendanceVO::getAttendanceId)
						.collect(Collectors.toList());
			}
			
			if (attendanceIds.isEmpty()) {
			    System.out.println("자동 결석 처리 대상 없음");
			    return;
			}
			
			// 업데이트 파라미터 설정
			Map<String, Object> updateParams = new HashMap<>();
			updateParams.put("attendanceIds", attendanceIds);
			updateParams.put("autoCheckOutTime", autoCheckOutTime);
			updateParams.put("status","결근");
			
            int updatedCount = attendanceDAO.updateToAutoAbsent(updateParams);
            
            System.out.println("자동 결석 처리 완료: " + updatedCount + "건");

			
			
			
		}catch (Exception e) {
            System.err.println("자동 결석 처리 오류: " + e.getMessage());

		}
		
		
	}
	
}
