package com.spring.app.attendance;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AttendanceVO {

	    /** 근태 ID */
	    private Long attendanceId;

	    /** 일자 */
	    private LocalDate attendanceDate;

	    /** 출근 시간 */
	    private LocalTime checkinTime;

	    /** 퇴근 시간 */
	    private LocalTime checkoutTime;

	    /** 상태 */
	    private String status;

	    /** 기록 일시 */
	    private LocalDateTime recordedAt;

	    /** 트레이너 ID */
	    private String username;

	    /** 수정 일시 */
	    private LocalDateTime updateAt;

	    /** 수정 사유 */
	    private String updateReason;
	    
	}