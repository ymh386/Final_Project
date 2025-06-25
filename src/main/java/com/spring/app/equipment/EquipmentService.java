package com.spring.app.equipment;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

import javax.management.Notification;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.websocket.NotificationManager;

@Service
@Transactional
public class EquipmentService {

	
	@Autowired
	private EquipmentDAO equipmentDAO;
	
	@Autowired
	private EquipmentFaultDAO faultDAO;
	
	
	
	
    // 모든 비품 조회
    public List<EquipmentVO> getAllEquipment() {
        return equipmentDAO.selectAllEquipment();
    }
    
    // 비품 상세 조회
    public EquipmentVO getEquipmentById(Long equipmentId) {
        return equipmentDAO.selectEquipmentById(equipmentId);
    }
    
    // 상태별 비품 조회
    public List<EquipmentVO> getEquipmentByStatus(String status) {
        return equipmentDAO.selectEquipmentByStatus(status);
    }
    
    // 정상 상태 비품만 조회
    public List<EquipmentVO> getNormalEquipment() {
        return equipmentDAO.selectEquipmentByStatus("정상");
    }
    
    // 비품 등록
    public boolean addEquipment(EquipmentVO equipment) {
        equipment.setCreatedAt(LocalDateTime.now());
        return equipmentDAO.insertEquipment(equipment) > 0;
    }
    
    // 비품 수정
    public boolean updateEquipment(EquipmentVO equipment) {
        return equipmentDAO.updateEquipment(equipment) > 0;
    }
    
    // 비품 상태 변경
    public boolean updateEquipmentStatus(Long equipmentId, String status) {
        return equipmentDAO.updateEquipmentStatus(equipmentId, status) > 0;
    }
    
    // 고장 신고 처리 (비품 상태도 함께 변경)
    @Transactional
    public boolean reportEquipmentFault(EquipmentFaultVO faultReport) {
        try {
            // 1. 고장 신고 등록
            faultReport.setReportDate(LocalDateTime.now());
            faultReport.setFaultStatus("신고접수");
            
            int reportResult = faultDAO.insertFaultReport(faultReport);
            
            // 2. 비품 상태를 '고장'으로 변경
            int statusResult = equipmentDAO.updateEquipmentStatus(faultReport.getEquipmentId(), "고장");
            
           
            
            return reportResult > 0 && statusResult > 0;
        } catch (Exception e) {
            throw new RuntimeException("고장 신고 처리 중 오류가 발생했습니다.", e);
        }
    }
    
    // 모든 고장 신고 조회
    public List<EquipmentFaultVO> getAllFaultReports() {
        return faultDAO.selectAllFaultReports();
    }
    
    // 미처리 고장 신고 조회
    public List<EquipmentFaultVO> getPendingFaultReports() {
        return faultDAO.selectFaultReportsByStatus("신고접수");
    }
    
    // 고장 신고 처리 상태 변경
    public boolean updateFaultStatus(Long reportId, String faultStatus) {
        return faultDAO.updateFaultStatus(reportId, faultStatus) > 0;
    }
    
    // 고장 신고 처리 완료
    @Transactional
    public boolean resolveFaultReport(Long reportId, Long equipmentId) {
        try {
        	
        	
        	EquipmentFaultVO vo = new EquipmentFaultVO();
            vo.setReportId(reportId);
            vo.setResolvedAt(LocalDateTime.now(ZoneId.of("Asia/Seoul")));
            // 1. 신고 처리 완료
            int reportResult = faultDAO.resolveFaultReport(vo);
            
            // 2. 비품 상태를 '정상'으로 변경
            int statusResult = equipmentDAO.updateEquipmentStatus(equipmentId, "정상");
            
            return reportResult > 0 && statusResult > 0;
        } catch (Exception e) {
            throw new RuntimeException("고장 신고 처리 완료 중 오류가 발생했습니다.", e);
        }
    }
    
    public int getTotalFaultReportsCount() {
        return faultDAO.getTotalFaultReportsCount();
    }
    
    public List<EquipmentFaultVO> getFaultReportsByPage(int offset, int size) {
        return faultDAO.getFaultReportsByPage(offset, size);
    }
    

    public List<EquipmentVO> selectByFacilityId(Long facilityId){
    	return equipmentDAO.selectByFacilityId(facilityId);
    	
    }
    

    public EquipmentFaultVO selectFaultReportById(Long reportId) {
    	return faultDAO.selectFaultReportById(reportId);
    }

    
}

	
	
	
	
	
	

