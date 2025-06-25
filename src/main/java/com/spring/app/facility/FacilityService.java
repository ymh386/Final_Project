package com.spring.app.facility;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FacilityService {

	@Autowired
	private FacilityDAO facilityDAO;
	
	
	public List<FacilityVO> getAllFacilities() {
		
		return facilityDAO.getAllFacilities(); 
		
	}
	
}
