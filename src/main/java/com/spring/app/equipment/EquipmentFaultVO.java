package com.spring.app.equipment;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EquipmentFaultVO {
	
	
	private Long reportId;
    private Long equipmentId;
    private String username;
    private LocalDateTime reportDate;
    private String description;
    private String faultStatus;
    private LocalDateTime resolvedAt;
	
	

}
