package com.spring.app.equipment;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface EquipmentFaultDAO {

	
	 // 모든 고장 신고 조회 (비품 정보 포함)
    List<EquipmentFaultVO> selectAllFaultReports();
    
    // 신고 ID로 조회
    EquipmentFaultVO selectFaultReportById(@Param("reportId") Long reportId);
    
    // 비품 ID로 신고 내역 조회
    List<EquipmentFaultVO> selectFaultReportsByEquipmentId(@Param("equipmentId") Long equipmentId);
    
    // 신고 상태로 조회
    List<EquipmentFaultVO> selectFaultReportsByStatus(@Param("faultStatus") String faultStatus);
    
    // 고장 신고 등록
    int insertFaultReport(EquipmentFaultVO faultReport);
    
    // 신고 상태 수정
    int updateFaultStatus(@Param("reportId") Long reportId, @Param("faultStatus") String faultStatus);
    
    // 신고 처리 완료
    int resolveFaultReport(@Param("reportId") Long reportId);
    
    // 신고 삭제
    int deleteFaultReport(@Param("reportId") Long reportId);
	
	
	
	
}
