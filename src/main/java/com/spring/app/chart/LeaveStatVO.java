package com.spring.app.chart;

import com.spring.app.approval.LeaveVO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LeaveStatVO {
	
	private Long typeId; // 휴가 타입
    private Long usedDays; // 사용일수
    
    private LeaveVO leaveVO;

}
