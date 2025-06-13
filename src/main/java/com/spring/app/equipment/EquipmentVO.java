package com.spring.app.equipment;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EquipmentVO {

	    private Long equipmentId;
	    private String name;
	    private String description;
	    private String location;
	    private LocalDateTime lastMaintenanceAt;
	    private String status;
	    private LocalDateTime createdAt;
	
	
	
	
	
	
}
