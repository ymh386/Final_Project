package com.spring.app.attendance;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.security.Principal;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.user.UserService;

@Controller
@RequestMapping("/attendance")
public class AttendanceController {

	@Autowired
	private AttendanceService attendanceService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private Environment env;
	
	/**
	 * Excel 파일로 출석 데이터 내보내기
	 * GET /attendance/export/excel?date=2024-01-15
	 */
	@GetMapping("/export/excel")
	@PreAuthorize("hasRole('ADMIN')")
	public ResponseEntity<Resource> exportToExcel(@RequestParam String date) {
		
		try {
			// 1. 해당 날짜의 출석 데이터 조회 
			LocalDate searchDate = LocalDate.parse(date);
			List<Map<String, Object>> attendanceList = attendanceService.listByDate(searchDate);
			
			// 2. Excel 파일 생성
			ByteArrayInputStream excelFile = createExcelFile(attendanceList, date);
			
			// 3. 파일명 생성 (한글 인코딩 처리)
			String fileName = "출석현황_" + date + ".xlsx";
			String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
			
			// 4. Resource로 변환
			InputStreamResource resource = new InputStreamResource(excelFile);
			
			return ResponseEntity.ok()
					.header(HttpHeaders.CONTENT_DISPOSITION, 
							"attachment; filename*=UTF-8''" + encodedFileName)
					.contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
					.body(resource);
					
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.internalServerError().build();
		}
	}
	
	/**
	 * Excel 파일을 생성하는 메서드
	 * @param attendanceList 출석 데이터 리스트
	 * @param date 조회 날짜
	 * @return ByteArrayInputStream Excel 파일 스트림
	 * @throws IOException
	 */
	private ByteArrayInputStream createExcelFile(List<Map<String, Object>> attendanceList, String date) throws IOException {
		// Apache POI를 사용하여 Excel 파일 생성
		Workbook workbook = new XSSFWorkbook();
		Sheet sheet = workbook.createSheet("출석현황");
		
		// 헤더 스타일 설정
		CellStyle headerStyle = workbook.createCellStyle();
		headerStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
		headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		headerStyle.setBorderTop(BorderStyle.THIN);
		headerStyle.setBorderBottom(BorderStyle.THIN);
		headerStyle.setBorderLeft(BorderStyle.THIN);
		headerStyle.setBorderRight(BorderStyle.THIN);
		headerStyle.setAlignment(HorizontalAlignment.CENTER);
		
		Font headerFont = workbook.createFont();
		headerFont.setBold(true);
		headerFont.setColor(IndexedColors.WHITE.getIndex());
		headerStyle.setFont(headerFont);
		
		// 데이터 셀 스타일 설정
		CellStyle dataStyle = workbook.createCellStyle();
		dataStyle.setBorderTop(BorderStyle.THIN);
		dataStyle.setBorderBottom(BorderStyle.THIN);
		dataStyle.setBorderLeft(BorderStyle.THIN);
		dataStyle.setBorderRight(BorderStyle.THIN);
		dataStyle.setAlignment(HorizontalAlignment.CENTER);
		
		// 제목 행 생성
		Row titleRow = sheet.createRow(0);
		Cell titleCell = titleRow.createCell(0);
		titleCell.setCellValue("출석 현황 - " + date);
		
		CellStyle titleStyle = workbook.createCellStyle();
		Font titleFont = workbook.createFont();
		titleFont.setBold(true);
		titleFont.setFontHeightInPoints((short) 16);
		titleStyle.setFont(titleFont);
		titleStyle.setAlignment(HorizontalAlignment.CENTER);
		titleCell.setCellStyle(titleStyle);
		
		// 제목 셀 병합
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 5));
		
		// 헤더 생성 (2번째 행)
		Row headerRow = sheet.createRow(2);
		String[] headers = {"트레이너명", "출근시간", "퇴근시간", "근무시간", "상태", "날짜"};
		
		for (int i = 0; i < headers.length; i++) {
			Cell cell = headerRow.createCell(i);
			cell.setCellValue(headers[i]);
			cell.setCellStyle(headerStyle);
		}
		
		// 데이터 행 생성 (3번째 행부터)
		for (int i = 0; i < attendanceList.size(); i++) {
			Row row = sheet.createRow(i + 3);
			Map<String, Object> attendance = attendanceList.get(i);
			
			// Map에서 데이터 추출 (실제 DB 컬럼명에 맞게 조정)
			String name = getStringValue(attendance, "name");  // 또는 "trainer_name", "username" 등
			Object checkinTime = attendance.get("checkinTime");  // 또는 "checkin_time"
			Object checkoutTime = attendance.get("checkoutTime"); // 또는 "checkout_time"
			
			// 각 셀에 데이터 입력 및 스타일 적용
			Cell nameCell = row.createCell(0);
			nameCell.setCellValue(name != null ? name : "미등록");
			nameCell.setCellStyle(dataStyle);
			
			Cell checkinCell = row.createCell(1);
			checkinCell.setCellValue(formatTimeFromObject(checkinTime));
			checkinCell.setCellStyle(dataStyle);
			
			Cell checkoutCell = row.createCell(2);
			checkoutCell.setCellValue(formatTimeFromObject(checkoutTime));
			checkoutCell.setCellStyle(dataStyle);
			
			Cell workHoursCell = row.createCell(3);
			workHoursCell.setCellValue(calculateWorkHoursFromObjects(checkinTime, checkoutTime));
			workHoursCell.setCellStyle(dataStyle);
			
			// 상태에 따른 색상 적용
			Cell statusCell = row.createCell(4);
			String status = getAttendanceStatusFromObject(checkinTime);
			statusCell.setCellValue(status);
			
			CellStyle statusStyle = workbook.createCellStyle();
			statusStyle.cloneStyleFrom(dataStyle);
			
			if ("지각".equals(status)) {
				statusStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
				statusStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			} else if ("결근".equals(status)) {
				statusStyle.setFillForegroundColor(IndexedColors.RED.getIndex());
				statusStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			} else if ("출근".equals(status)) {
				statusStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
				statusStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			}
			statusCell.setCellStyle(statusStyle);
			
			Cell dateCell = row.createCell(5);
			dateCell.setCellValue(date);
			dateCell.setCellStyle(dataStyle);
		}
		
		// 컬럼 너비 자동 조정
		for (int i = 0; i < headers.length; i++) {
			sheet.autoSizeColumn(i);
			// 최소 너비 설정
			if (sheet.getColumnWidth(i) < 3000) {
				sheet.setColumnWidth(i, 3000);
			}
		}
		
		// ByteArrayOutputStream으로 변환
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		workbook.write(outputStream);
		workbook.close();
		
		return new ByteArrayInputStream(outputStream.toByteArray());
	}
	
	// Map에서 String 값을 안전하게 가져오는 메서드
	private String getStringValue(Map<String, Object> map, String key) {
		Object value = map.get(key);
		return value != null ? value.toString() : null;
	}
	
	/**
	 * Object를 시간 문자열로 포맷팅
	 */
	private String formatTimeFromObject(Object timeObj) {
		if (timeObj == null) return "-";
		
		// LocalTime 객체인 경우
		if (timeObj instanceof LocalTime) {
			return timeObj.toString();
		}
		
		// String인 경우
		if (timeObj instanceof String) {
			return timeObj.toString();
		}
		
		// java.sql.Time인 경우
		if (timeObj instanceof java.sql.Time) {
			return timeObj.toString();
		}
		
		return timeObj.toString();
	}
	
	/**
	 * 근무시간을 계산하여 문자열로 반환
	 */
	private String calculateWorkHoursFromObjects(Object checkinObj, Object checkoutObj) {
		if (checkinObj == null || checkoutObj == null) return "-";
		
		try {
			LocalTime checkinTime = convertToLocalTime(checkinObj);
			LocalTime checkoutTime = convertToLocalTime(checkoutObj);
			
			if (checkinTime == null || checkoutTime == null) return "-";
			
			Duration duration = Duration.between(checkinTime, checkoutTime);
			long hours = duration.toHours();
			long minutes = duration.toMinutes() % 60;
			
			return hours + "시간 " + minutes + "분";
		} catch (Exception e) {
			return "-";
		}
	}
	
	/**
	 * 출석 상태를 판단하여 반환
	 */
	private String getAttendanceStatusFromObject(Object checkinObj) {
		if (checkinObj == null) return "결근";
		
		try {
			LocalTime checkinTime = convertToLocalTime(checkinObj);
			if (checkinTime == null) return "결근";
			
			// 9시 이후 출근 시 지각 처리
			if (checkinTime.isAfter(LocalTime.of(9, 0))) {
				return "지각";
			}
			return "출근";
		} catch (Exception e) {
			return "결근";
		}
	}
	
	/**
	 * 다양한 타입의 시간 객체를 LocalTime으로 변환
	 */
	private LocalTime convertToLocalTime(Object timeObj) {
		if (timeObj == null) return null;
		
		if (timeObj instanceof LocalTime) {
			return (LocalTime) timeObj;
		}
		
		if (timeObj instanceof String) {
			try {
				return LocalTime.parse(timeObj.toString());
			} catch (Exception e) {
				return null;
			}
		}
		
		if (timeObj instanceof java.sql.Time) {
			return ((java.sql.Time) timeObj).toLocalTime();
		}
		
		// java.util.Date나 java.sql.Timestamp 등 다른 타입도 처리 가능
		if (timeObj instanceof java.util.Date) {
			return ((java.util.Date) timeObj).toInstant()
					.atZone(java.time.ZoneId.systemDefault())
					.toLocalTime();
		}
		
		return null;
	}
	
	@GetMapping("/page")
	public String attendancePage(Model model) {
		
		String apiKey = env.getProperty("google.maps.api.key");
        model.addAttribute("googleMapApiKey", apiKey);
		
		return "attendance/page";
	}
	
    // ✅ 거리 계산 (Haversine 공식): 두 지점의 위/경도로 거리 계산
    private double haversine(double lat1, double lon1, double lat2, double lon2) {
        double R = 6371.0; // 지구 반지름 (km 단위)
        double dLat = Math.toRadians(lat2 - lat1); // 위도 차이 라디안으로 변환
        double dLon = Math.toRadians(lon2 - lon1); // 경도 차이 라디안으로 변환

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                   Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                   Math.sin(dLon / 2) * Math.sin(dLon / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return R * c * 1000; // 결과: 미터(m) 단위 거리 반환
    }
	
	@PostMapping("/checkIn")
	@PreAuthorize("hasRole('TRAINER')")
	@ResponseBody
	public ResponseEntity<?> checkIn(@RequestBody Map<String, Object> body,
	                                 Principal principal) {
	    String username = principal.getName();

	    try {
	        // 클라이언트에서 보낸 위치 정보 파싱
	        double lat = ((Number) body.get("lat")).doubleValue();
	        double lng = ((Number) body.get("lng")).doubleValue();

	        final double companyLat = 37.476502;
	        final double companyLng = 126.880193;

	        // 위치 거리 계산
	        double distance = haversine(lat, lng, companyLat, companyLng);
	        if (distance > 1000) {
	            return ResponseEntity.status(HttpStatus.FORBIDDEN)
	                                 .body("KM타워 반경 1000m 이내에서만 출근 가능합니다.");
	        }

	        // 정상 출근 처리
	        AttendanceVO vo = attendanceService.checkIn(username);
	        return ResponseEntity.ok(vo);

	    } catch (AttendanceException ex) {
	        return ResponseEntity.status(HttpStatus.CONFLICT)
	                             .body(ex.getMessage());
	    } catch (Exception ex) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
	                             .body("출근 처리 중 오류 발생: " + ex.getMessage());
	    }
	}

	/**
	 * 퇴근 처리 (ROLE_TRAINER 권한)
	 * POST /attendance/checkOut?attendanceId=xxx
	 */
	@PostMapping("/checkOut")
	@PreAuthorize("hasRole('TRAINER')")
	@ResponseBody
	public ResponseEntity<?> checkOut(@RequestParam("attendanceId") Long attendanceId) {
	    try {
	        AttendanceVO vo = attendanceService.checkOut(attendanceId);
	        return ResponseEntity.ok(vo);
	    } catch (AttendanceException ex) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
	                             .body(ex.getMessage());
	    }
	}

    @GetMapping("user")
    @ResponseBody
    public List<AttendanceVO> listByUser(@RequestParam String username) {
        return attendanceService.listByUser(username);
    }

    //DateTimeFormat 사용 이유 LocalDate 같은 날짜 타입 파라미터를 받을 때 스프링이 문자열을 어떻게 변환해야 할지 모르기 때문에 포맷을 알려줌
    @GetMapping("date/{date}")
    @ResponseBody
    public List<Map<String, Object>> listByDate(
    		@PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
    	System.out.println("날짜로 조회 요청: " + date);
        return attendanceService.listByDate(date);
    }
    
    @GetMapping("admin")
    public String adminAttendancePage() {
    	return "attendance/admin";
    }

    @GetMapping("all")
    @ResponseBody
    public List<AttendanceVO> listAll() {
        return attendanceService.listAll();
    }
	
    //오늘 출석 데이터 조회
    @GetMapping("/today")
    @ResponseBody
    public List<Map<String, Object>> listToday(){
    	return attendanceService.listByDate(LocalDate.now());
    }

    /**
     * 관리자용: 전체 트레이너 수 조회
     * GET /attendance/trainer-count
     */
    @GetMapping("/trainer-count")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public Map<String, Object> getTrainerCount() throws Exception{
        Long trainerCount = (long) userService.getTrainerCount();
        Map<String, Object> result = new HashMap();
        result.put("totalTrainers", trainerCount);
        return result;
    }
    
    @PostMapping("/admin/update")
    @PreAuthorize("hasRole('ADMIN')")
    @ResponseBody
    public ResponseEntity<?> updateAttendance(@RequestBody AttendanceVO vo) {
        
    	try {
        System.out.println("수정 요청: " + vo.getAttendanceId());
        System.out.println("출근: " + vo.getCheckinTime());
        System.out.println("퇴근: " + vo.getCheckoutTime());
        System.out.println("사유: " + vo.getUpdateReason());
        attendanceService.updateAttendance(vo);
        return ResponseEntity.ok().build();

    	} catch (Exception e) {
    		 e.printStackTrace();  // 콘솔에 예외 출력
    	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("수정 실패: " + e.getMessage());
    	}
    }
}