package com.spring.app.chart;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.user.DepartmentVO;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;

@Controller
@RequestMapping("/chart/*")
public class ChartController {
	
	@Autowired
	private ChartService chartService;
	
	@Autowired
	private UserService userService;
	
	@GetMapping("admin/stats")
    public String getAttendanceStats(@RequestParam(required = false) Integer year,
            @RequestParam(defaultValue = "all") String scope,
            @RequestParam(required = false) Long departmentId,
            @RequestParam(required = false) String username,
            Model model) throws Exception {
		
		 // 현재 연도 기준으로 yearList 생성
	    Integer currentYear = LocalDate.now(ZoneId.of("Asia/Seoul")).getYear();
	    List<Integer> yearList = new ArrayList<>();
	    for (int y = 2020; y <= currentYear; y++) {
	        yearList.add(y);
	    }
    	
		if (year == null) {
	        // 기본 연도 설정
	        year = currentYear;
		}
		
    	List<AttendanceStatVO> stats = chartService.getMonthlyStats(year, scope, departmentId, username);
    	
		model.addAttribute("year", year);
		model.addAttribute("yearList", yearList);
	    model.addAttribute("scope", scope);
	    model.addAttribute("stats", stats);
	    
	    
	    model.addAttribute("userList", userService.getUsersWithDepartment());
	    model.addAttribute("deptList", userService.getDepartments());
	    
	    return "chart/stats";
    

	}
	
	
	@GetMapping("admin/usersOfDepartment")
	@ResponseBody
	public List<UserVO> getUsersOfDepartment(DepartmentVO departmentVO) throws Exception {
		List<UserVO> ar = chartService.getUsersOfDepartment(departmentVO);
		
		return ar;
	}
}
