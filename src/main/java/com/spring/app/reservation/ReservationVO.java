package com.spring.app.reservation;


	import java.time.LocalDateTime;
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

	
	
	
}
