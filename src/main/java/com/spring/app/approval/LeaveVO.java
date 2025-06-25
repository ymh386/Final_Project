package com.spring.app.approval;

import java.time.Year;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LeaveVO {
	
	private Long typeId; //휴가 종류
	private Long usedDays; //사용 일수
	private String username; //사용자Id
	private Year year; //사용 년도
}
