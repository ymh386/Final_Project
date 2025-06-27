package com.spring.app.facility;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface FacilityDAO {

	public List<FacilityVO> getAllFacilities();
	
	
}
