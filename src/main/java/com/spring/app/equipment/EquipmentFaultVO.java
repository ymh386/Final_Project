package com.spring.app.equipment;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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
    private String equipmentName;
   
	
	
    // reportDate를 yyyy-MM-dd HH:mm:ss 형식의 문자열로 반환
    public String getReportDateStr() {
        return reportDate != null
            ? reportDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))
            : "-";
    }

    // resolvedAt을 MM-dd HH:mm 형식의 문자열로 반환
    public String getResolvedAtStr() {
        return resolvedAt != null
            ? resolvedAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))
            : "-";
    }
    
    
    
    
    
    

}
