package com.spring.app.reservation;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class FacilityVO {

	private Long facilityId;
	private String name;
	private String description;
	private String location;
	
}
