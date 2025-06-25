package com.spring.app.auditLog;

import java.util.List;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.home.util.Pager;

import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/admin/auditLog/*")
public class AuditLogController {
	
	@Autowired
	private AuditLogService auditLogService;

	//카테고리의 검색어 기준으로 감사 기록 리스트
	@GetMapping("list")
	public String getList(Pager pager, Model model) throws Exception {

		List<AuditLogVO> ar = auditLogService.getList(pager);
		
		model.addAttribute("ar", ar);
		model.addAttribute("pager", pager);
		
		return "auditLog/list";
	}
	
	//엑셀파일로 리스트 한 줄 내려받기
	@GetMapping("excel")
	public void exportExcel(Pager pager, HttpServletResponse response) throws Exception {
		
		List<AuditLogVO> logs = auditLogService.getList(pager);
		
		Workbook workbook = new XSSFWorkbook();
		Sheet sheet = workbook.createSheet("감사 로그");
		
		 // 헤더 행 생성
	    Row header = sheet.createRow(0);
	    header.createCell(0).setCellValue("ID");
	    header.createCell(1).setCellValue("사용자");
	    header.createCell(2).setCellValue("행위");
	    header.createCell(3).setCellValue("테이블");
	    header.createCell(4).setCellValue("ROW_ID");
	    header.createCell(5).setCellValue("IP");
	    header.createCell(6).setCellValue("User-Agent");
	    header.createCell(7).setCellValue("일시");
	    
	    // 데이터 행 채우기
	    int rowIdx = 1;
	    for (AuditLogVO log : logs) {
	        Row row = sheet.createRow(rowIdx++);
	        row.createCell(0).setCellValue(log.getAuditLogId());
	        row.createCell(1).setCellValue(log.getUsername());
	        row.createCell(2).setCellValue(log.getActionType());
	        row.createCell(3).setCellValue(log.getTargetTable());
	        row.createCell(4).setCellValue(log.getTargetId());
	        row.createCell(5).setCellValue(log.getIpAddress());
	        row.createCell(6).setCellValue(log.getUserAgent());
	        row.createCell(7).setCellValue(log.getCreatedAt().toString());
	    }
	    
	    // 응답 설정
	    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	    response.setHeader("Content-Disposition", "attachment; filename=audit_log.xlsx");
	    
	    // 출력 스트림에 쓰기
	    workbook.write(response.getOutputStream());
	    workbook.close();
	}
}
