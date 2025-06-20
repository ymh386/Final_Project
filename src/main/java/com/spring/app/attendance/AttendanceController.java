package com.spring.app.attendance;

import java.security.Principal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.user.UserService;
import com.spring.app.auditLog.AuditLogService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/attendance")
public class AttendanceController {

	@Autowired
	private AttendanceService attendanceService;
	
	@Autowired
	private UserService userService;
	private AuditLogService auditLogService;
	
	
	@GetMapping("/page")
	public String attendancePage() {
		
		
		return "attendance/page";
	}
	
	
	
	
	
	 @PostMapping("/checkIn")
	 @PreAuthorize("hasRole('TRAINER')")
	 @ResponseBody
	    public ResponseEntity<?> checkIn(Principal principal, HttpServletRequest request) {
	        String username = principal.getName();
	        try {
	            AttendanceVO vo = attendanceService.checkIn(username);
	            
	         // 로그/감사 기록용
				try {
					auditLogService.log(
							vo.getUsername(),
					        "CHECKIN",
					        "ATTENDANCE",
					        vo.getAttendanceId().toString(),
					        vo.getUsername() + "이 "
					        + vo.getAttendanceDate() + " 날짜의 "
					        + vo.getCheckinTime() + "에 출근",
					        request
					    );
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	            
	            return ResponseEntity.ok(vo);
	        } catch (AttendanceException ex) {
	            // 이미 출근했거나 기타 오류 메시지
	            return ResponseEntity.status(HttpStatus.CONFLICT)
	                                 .body(ex.getMessage());
	        }
	    }

	    /**
	     * 퇴근 처리 (ROLE_TRAINER 권한)
	     * POST /attendance/checkOut?attendanceId=xxx
	     */
	    @PostMapping("/checkOut")
	    @PreAuthorize("hasRole('TRAINER')")
	    @ResponseBody
	    public ResponseEntity<?> checkOut(@RequestParam("attendanceId") Long attendanceId, HttpServletRequest request) {
	        try {
	            AttendanceVO vo = attendanceService.checkOut(attendanceId);
	            
	         // 로그/감사 기록용
				try {
					auditLogService.log(
							vo.getUsername(),
					        "CHECKOUT",
					        "ATTENDANCE",
					        vo.getAttendanceId().toString(),
					        vo.getUsername() + "이 "
					        + vo.getAttendanceDate() + " 날짜의 "
					        + vo.getCheckinTime() + "에 퇴근",
					        request
					    );
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	            
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
