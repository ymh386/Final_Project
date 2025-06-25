package com.spring.app.equipment;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.spring.app.facility.FacilityVO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EquipmentVO {

	    private Long equipmentId;
	    private String name;
	    private String description;
	    private Long facilityId;
	    private LocalDateTime lastMaintenanceAt;
	    private String status;
	    private LocalDateTime createdAt;
	    
	    private FacilityVO facilityVO;
	    
	
	
	    public String getLastMaintenanceAtStr() {
	        return lastMaintenanceAt != null
	            ? lastMaintenanceAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))
	            : "-";
	    }

	    // 추가: 등록일을 "yyyy-MM-dd" 형식의 문자열로 반환
	    public String getCreatedAtStr() {
	        return createdAt != null
	            ? createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))
	            : "-";
	    }
	
	
	
}
