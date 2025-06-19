package com.spring.app.equipment;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.app.auditLog.AuditLogService;
import com.spring.app.home.util.Pager;
import com.spring.app.user.UserVO;
import com.spring.app.websocket.NotificationManager;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/equipment")
public class EquipmentController {

	@Autowired
	private EquipmentService equipmentService;
	
	@Autowired
	private NotificationManager notificationManager;
	
	@Autowired
	private AuditLogService auditLogService;
	
	
	   // 메인 페이지 - 비품 목록과 신고 폼

	@GetMapping("/main")
	public String mainPage(Model model,
	                      @RequestParam(defaultValue = "1") int page,
	                      @RequestParam(defaultValue = "3") int size) throws Exception {

	    // 1. 전체 장비 목록
	    List<EquipmentVO> equipmentList = equipmentService.getAllEquipment();

	    // 2. Pager 객체 생성 및 설정
	    Pager pager = new Pager();
	    pager.setCurPage(page);
	    pager.setPerPage(size);
	    pager.makeRow(); // startRow, pageSize 계산

	    // 3. 전체 신고 수 조회 및 페이징 처리
	    long totalReports = equipmentService.getTotalFaultReportsCount();
	    pager.makePage(totalReports);

	    // 4. 페이징된 신고 내역 조회
	    List<EquipmentFaultVO> faultReports = equipmentService.getFaultReportsByPage(
	        pager.getStartRow(), pager.getPageSize()
	    );

	    // 5. 모델에 데이터 추가
	    model.addAttribute("equipmentList", equipmentList);
	    model.addAttribute("faultReports", faultReports);
	    model.addAttribute("faultReport", new EquipmentFaultVO());
	    model.addAttribute("pager", pager);

	    return "equipment/main";
	}

    
    // 비품 목록 페이지
    @GetMapping("/list")
    public String equipmentList(Model model) {
        List<EquipmentVO> equipmentList = equipmentService.getAllEquipment();
        model.addAttribute("equipmentList", equipmentList);
        return "equipment/list";
    }
    
    // 고장 신고 처리
    @PostMapping("/report")
    public String reportFault(@ModelAttribute EquipmentFaultVO faultReport, 
                             RedirectAttributes redirectAttributes, HttpServletRequest request) {
        try {
            boolean success = equipmentService.reportEquipmentFault(faultReport);
            
            
            
            if (success) {
            	// 신고 접수 알림
            	faultReport = equipmentService.selectFaultReportById(faultReport.getReportId());
            	notificationManager.reportNotification(faultReport);
            	
				// 로그/감사 기록용
				auditLogService.log(
				        faultReport.getUsername(),
				        "REPORT_FAULT",
				        "EQUIPMENT_FAULT",
				        faultReport.getReportId().toString(),
				        faultReport.getUsername()
				        + "이 " + faultReport.getEquipmentLocation()
				        + "의 " + faultReport.getEquipmentName() + " 고장 신고",
				        request
				    );
            	
                redirectAttributes.addFlashAttribute("message", "고장 신고가 성공적으로 접수되었습니다.");
                redirectAttributes.addFlashAttribute("messageType", "success");
            } else {
                redirectAttributes.addFlashAttribute("message", "고장 신고 접수에 실패했습니다.");
                redirectAttributes.addFlashAttribute("messageType", "error");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "오류가 발생했습니다: " + e.getMessage());
            redirectAttributes.addFlashAttribute("messageType", "error");
        }
        
        return "redirect:/equipment/main";
    }
    
    // 관리자 페이지 - 신고 처리
    @GetMapping("/admin")
    public String adminPage(Model model) {
        List<EquipmentFaultVO> pendingReports = equipmentService.getPendingFaultReports();
        List<EquipmentFaultVO> allReports = equipmentService.getAllFaultReports();
        
        model.addAttribute("pendingReports", pendingReports);
        model.addAttribute("allReports", allReports);
        
        return "equipment/admin";
    }
    
    // 신고 상태 변경
    @PostMapping("/updateStatus")
    public String updateFaultStatus(@AuthenticationPrincipal UserVO userVO, @RequestParam Long reportId, 
                                   @RequestParam String faultStatus,
                                   RedirectAttributes redirectAttributes, HttpServletRequest request) {
        try {
            boolean success = equipmentService.updateFaultStatus(reportId, faultStatus);
            
            
            if (success) {
            	//비품 신고처리중 알림
            	EquipmentFaultVO equipmentFaultVO = equipmentService.selectFaultReportById(reportId);
            	notificationManager.reportingNotification(equipmentFaultVO);
            	
				// 로그/감사 기록용
				auditLogService.log(
						userVO.getUsername(),
				        "RESOLVE_FAULT",
				        "EQUIPMENT_FAULT",
				        equipmentFaultVO.getReportId().toString(),
				        "admin이 " + equipmentFaultVO.getUsername() + "이 신고한 "
				        + equipmentFaultVO.getEquipmentLocation()+ "의 "
				        + equipmentFaultVO.getEquipmentName()
				        + " 고장 신고 처리중",
				        request
				    );
            	
                redirectAttributes.addFlashAttribute("message", "신고 상태가 변경되었습니다.");
                redirectAttributes.addFlashAttribute("messageType", "success");
            } else {
                redirectAttributes.addFlashAttribute("message", "상태 변경에 실패했습니다.");
                redirectAttributes.addFlashAttribute("messageType", "error");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "오류가 발생했습니다: " + e.getMessage());
            redirectAttributes.addFlashAttribute("messageType", "error");
        }
        
        return "redirect:/equipment/admin";
    }
    
    // 신고 처리 완료
    @PostMapping("/resolve")
    public String resolveFaultReport(@AuthenticationPrincipal UserVO userVO, @RequestParam Long reportId, 
                                   @RequestParam Long equipmentId,
                                   RedirectAttributes redirectAttributes, HttpServletRequest request) {
        try {
            boolean success = equipmentService.resolveFaultReport(reportId, equipmentId);
            
            if (success) {
            	//비품 신고 처리완료 알림
            	EquipmentFaultVO equipmentFaultVO = equipmentService.selectFaultReportById(reportId);
            	notificationManager.reportingNotification(equipmentFaultVO);
            	
				// 로그/감사 기록용
				auditLogService.log(
						userVO.getUsername(),
				        "RESOLVE_FAULT",
				        "EQUIPMENT_FAULT",
				        equipmentFaultVO.getReportId().toString(),
				        "admin이 " + equipmentFaultVO.getUsername() + "이 신고한 "
				        + equipmentFaultVO.getEquipmentLocation()+ "의 "
				        + equipmentFaultVO.getEquipmentName()
				        + " 고장 신고 처리완료",
				        request
				    );
            	
                redirectAttributes.addFlashAttribute("message", "고장 신고가 처리 완료되었습니다.");
                redirectAttributes.addFlashAttribute("messageType", "success");
            } else {
                redirectAttributes.addFlashAttribute("message", "처리 완료에 실패했습니다.");
                redirectAttributes.addFlashAttribute("messageType", "error");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "오류가 발생했습니다: " + e.getMessage());
            redirectAttributes.addFlashAttribute("messageType", "error");
        }
        
        return "redirect:/equipment/admin";
    }
    
    // Ajax용 비품 목록 조회
    @GetMapping("/api/list")
    @ResponseBody
    public List<EquipmentVO> getEquipmentListApi() {
        return equipmentService.getAllEquipment();
    }
    
    // Ajax용 신고 내역 조회
    @GetMapping("/api/reports")
    @ResponseBody
    public List<EquipmentFaultVO> getFaultReportsApi() {
        return equipmentService.getAllFaultReports();
    }


}
	
	
	
	
	

