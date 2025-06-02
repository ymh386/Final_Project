package com.spring.app.attendance;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
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
	
	
	
	
	
	//RequestParam 사용 이유 쿼리스트링에 넘겨온 값을 깔끔하게 바인딩 하기위함
	@PostMapping("checkIn")
    @ResponseBody
	public AttendanceVO checkIn(@RequestParam String username) {
		
		return attendanceService.checkIn(username);
	}
	
    @PostMapping("checkout")
    @ResponseBody
    public AttendanceVO checkOut(@RequestParam Long attendanceId) {
    	
        return attendanceService.checkOut(attendanceId);
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
