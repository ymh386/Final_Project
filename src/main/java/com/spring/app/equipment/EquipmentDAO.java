package com.spring.app.equipment;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface EquipmentDAO {

	
	 // 모든 비품 조회
    List<EquipmentVO> selectAllEquipment();
    
    // 비품 ID로 조회
    EquipmentVO selectEquipmentById(@Param("equipmentId") Long equipmentId);
    
    // 비품 상태로 조회
    List<EquipmentVO> selectEquipmentByStatus(@Param("status") String status);
    
    // 비품 등록
    int insertEquipment(EquipmentVO equipment);
    
    // 비품 정보 수정
    int updateEquipment(EquipmentVO equipment);
    
    // 비품 상태 수정
    int updateEquipmentStatus(@Param("equipmentId") Long equipmentId, @Param("status") String status);
    
    // 비품 삭제
    int deleteEquipment(@Param("equipmentId") Long equipmentId);
	
    //시설로 id로 조회 
	List<EquipmentVO> selectByFacilityId(Long facilityId);
	
}
	