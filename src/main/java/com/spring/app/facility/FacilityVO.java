package com.spring.app.facility;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;


@Setter
@Getter
public class FacilityVO {

	
	private Long facilityId; // 시설 ID (FK)
    private String name; // 비품명
    private String description;
    private String Location;
	
	
}
