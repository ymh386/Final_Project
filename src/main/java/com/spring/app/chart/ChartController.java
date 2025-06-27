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
	        // 기본 연도 설정(현재년도)
	        year = currentYear;
		}
		//근태율 차트
    	List<AttendanceStatVO> attendanceStats = chartService.getMonthlyStats(year, scope, departmentId, username);
    	//휴가율 차트
    	List<LeaveStatVO> leaveStats = chartService.getUsedLeaveByType(year, scope, departmentId, username);
    	
    	
    	//현재년도로 설정용
		model.addAttribute("year", year);
		//연도별 필터링 시 필요한 정보들
		model.addAttribute("yearList", yearList);
		//적용 범위 필터링 시
	    model.addAttribute("scope", scope);
	    
	    //통계를 차트화 할때 필요한 정보들
	    //근태율
	    model.addAttribute("attendanceStats", attendanceStats);
	    //휴가율
	    model.addAttribute("leaveStats", leaveStats);

	    
	    //직원별, 부서별 필터링 시 필요한 직원, 부서 정보들을 프론트로 넘김
	    model.addAttribute("userList", userService.getUsersWithDepartment());
	    model.addAttribute("deptList", userService.getDepartments());
	    
	    return "chart/stats";
    

	}
	
	//프론트에서 부서별 직원 불러오는 용도
	@GetMapping("admin/usersOfDepartment")
	@ResponseBody
	public List<UserVO> getUsersOfDepartment(DepartmentVO departmentVO) throws Exception {
		List<UserVO> ar = chartService.getUsersOfDepartment(departmentVO);
		
		return ar;
	}
}
