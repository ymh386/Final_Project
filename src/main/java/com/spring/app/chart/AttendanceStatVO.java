package com.spring.app.chart;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class AttendanceStatVO {
	
	private int month;	// 1~`12
	private int total;	// 총 기록 수
	private int present;// 출근 수
	private int late;	// 지각 수
	private int absent; // 결근 수
	
	
	
	

}
