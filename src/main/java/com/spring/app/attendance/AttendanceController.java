package com.spring.app.attendance;

import java.security.Principal;
import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/attendance")
public class AttendanceController {

	@Autowired
	private AttendanceService attendanceService;
	
	
	@GetMapping("/page")
	public String attendancePage() {
		
		
		return "attendance/page";
	}
	
	
	
	
	
	 @PostMapping("/checkIn")
	    @PreAuthorize("hasRole('TRAINER')")
	    public ResponseEntity<?> checkIn(Principal principal) {
	        String username = principal.getName();
	        try {
	            AttendanceVO vo = attendanceService.checkIn(username);
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
    @GetMapping
    @ResponseBody
    public List<AttendanceVO> listByDate(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return attendanceService.listByDate(date);
    }

    @GetMapping("all")
    @ResponseBody
    public List<AttendanceVO> listAll() {
        return attendanceService.listAll();
    }
	
	

	
	
}
