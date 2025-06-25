package com.spring.app.schedule;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import com.spring.app.user.UserVO;

import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
public class ScheduleVO {

	
    private Long scheduleId;       // 일정 ID (PK)
    private String username;       // 트레이너 ID (FK)
    private Long facilityId;       // 시설 ID (FK)
    private LocalDate scheduleDate; // 예약 날짜
    private LocalTime startTime;   // 시작 시간
    private LocalTime endTime;     // 종료 시간
    private LocalDateTime createdAt; // 생성 일시
    private Long remainingSeats; // 남은 좌석 수 
    
    private UserVO userVO; //트레이너 정보
	
	
}
