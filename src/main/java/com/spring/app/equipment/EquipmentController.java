package com.spring.app.equipment;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/equipment")
public class EquipmentController {

	@Autowired
	private EquipmentService equipmentService;
	
	
	   // 메인 페이지 - 비품 목록과 신고 폼
    @GetMapping("/main")
    public String mainPage(Model model) {
        List<EquipmentVO> equipmentList = equipmentService.getAllEquipment();
        List<EquipmentFaultVO> faultReports = equipmentService.getAllFaultReports();
        
        model.addAttribute("equipmentList", equipmentList);
        model.addAttribute("faultReports", faultReports);
        model.addAttribute("faultReport", new EquipmentFaultVO());
        
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
                             RedirectAttributes redirectAttributes) {
        try {
            boolean success = equipmentService.reportEquipmentFault(faultReport);
            
            if (success) {
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
    public String updateFaultStatus(@RequestParam Long reportId, 
                                   @RequestParam String faultStatus,
                                   RedirectAttributes redirectAttributes) {
        try {
            boolean success = equipmentService.updateFaultStatus(reportId, faultStatus);
            
            if (success) {
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
    public String resolveFaultReport(@RequestParam Long reportId, 
                                   @RequestParam Long equipmentId,
                                   RedirectAttributes redirectAttributes) {
        try {
            boolean success = equipmentService.resolveFaultReport(reportId, equipmentId);
            
            if (success) {
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
	
	
	
	
	

