package com.spring.app.reservation;


	import java.time.LocalDateTime;

import com.spring.app.facility.FacilityVO;
import com.spring.app.schedule.ScheduleVO;
import com.spring.app.user.UserVO;

import lombok.Getter;
	import lombok.Setter;

	@Getter
	@Setter
	public class ReservationVO {

	    private Long reservationId;    // 예약 ID (PK, AUTO_INCREMENT)
	    private Long scheduleId;       // 일정 ID (FK)
	    private String username;       // 회원 ID (FK)
	    private Long facilityId;       // 시설 ID (FK)
	    private LocalDateTime createdAt;      // 예약 일시
	    private LocalDateTime canceledAt;     // 취소 일시
	    private String canceledReason;        // 취소 사유
	    private LocalDateTime updatedAt;      // 업데이트 일시
	    
	    private ScheduleVO scheduleVO; // 예약스케쥴 정보
	    private FacilityVO facilityVO; // 예약시설 정보
	    private UserVO userVO; 		   // 예약자 정보
	 

	
	
	
}
