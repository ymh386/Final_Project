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
	

    @GetMapping("/export/excel")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Resource> exportToExcel(@RequestParam String date) {
        try {
            ByteArrayInputStream excelFile = attendanceService.exportAttendanceToExcel(date);
            String fileName = "출석현황_" + date + ".xlsx";
            String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename*=UTF-8''" + encodedFileName)
                    .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                    .body(new InputStreamResource(excelFile));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

	
	
	@GetMapping("/page")
	public String attendancePage(Model model) {
		
		String apiKey = env.getProperty("google.maps.api.key");
        model.addAttribute("googleMapApiKey", apiKey);
		
		return "attendance/page";
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