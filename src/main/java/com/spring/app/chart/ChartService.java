package com.spring.app.chart;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.attendance.AttendanceDAO;
import com.spring.app.user.DepartmentVO;
import com.spring.app.user.UserDAO;
import com.spring.app.user.UserVO;

@Service
public class ChartService {
	
	@Autowired
	private AttendanceDAO attendanceDAO;
	
	@Autowired
	private UserDAO userDAO;
	
	//범위설정 가능(관리자용)
	public List<AttendanceStatVO> getMonthlyStats(Integer year, String scope, Long departmentId, String username) throws Exception {
		List<AttendanceStatVO> rawStats;
		
		//주재별로 쿼리문 사용해서 리스트에 담음
	    if ("dept".equals(scope)) {
	    	rawStats = attendanceDAO.getDeptMonthlyStats(year, departmentId);
	    } else if ("user".equals(scope)) {
	    	rawStats = attendanceDAO.getUserMonthlyStats(year, username);
	    } else {
	    	rawStats = attendanceDAO.getAllMonthlyStats(year);
	    }
	    
	 // 1~12월 데이터가 모두 있는지 확인하고 누락된 월은 0으로 채움
	    Map<Integer, AttendanceStatVO> statMap = new HashMap<>();
	    for (AttendanceStatVO stat : rawStats) {
	    	//월별로 통계 데이터를 담음(데이터가 안들어간 월은 안담김)
	        statMap.put(stat.getMonth(), stat);
	    }

	    List<AttendanceStatVO> fullStats = new ArrayList<>();
	    for (int i = 1; i <= 12; i++) {
	        if (statMap.containsKey(i)) {
	        	//맵에 담겨져있는 월
	            fullStats.add(statMap.get(i));
	        } else {
	        	//맵에 안담겨져있는 월(즉 0%)
	            AttendanceStatVO empty = new AttendanceStatVO();
	            empty.setMonth(i);
	            empty.setTotal(0);
	            empty.setPresent(0);
	            empty.setLate(0);
	            empty.setAbsent(0);
	            fullStats.add(empty);
	        }
	    }

	    return fullStats;
	}
	
	//자신것만 조회(유저용)
	public List<AttendanceStatVO> getMonthlyStats(Integer year, String username) throws Exception {
		List<AttendanceStatVO> rawStats;
		
		rawStats = attendanceDAO.getUserMonthlyStats(year, username);
		
		// 1~12월 데이터가 모두 있는지 확인하고 누락된 월은 0으로 채움
	    Map<Integer, AttendanceStatVO> statMap = new HashMap<>();
	    for (AttendanceStatVO stat : rawStats) {
	    	//월별로 통계 데이터를 담음(데이터가 안들어간 월은 안담김)
	        statMap.put(stat.getMonth(), stat);
	    }

	    List<AttendanceStatVO> fullStats = new ArrayList<>();
	    for (int i = 1; i <= 12; i++) {
	        if (statMap.containsKey(i)) {
	        	//맵에 담겨져있는 월
	            fullStats.add(statMap.get(i));
	        } else {
	        	//맵에 안담겨져있는 월(즉 0%)
	            AttendanceStatVO empty = new AttendanceStatVO();
	            empty.setMonth(i);
	            empty.setTotal(0);
	            empty.setPresent(0);
	            empty.setLate(0);
	            empty.setAbsent(0);
	            fullStats.add(empty);
	        }
	    }

	    return fullStats;
	}
	
	//트레이너 이상 등급의 부서별 회원들 조회
	public List<UserVO> getUsersOfDepartment(DepartmentVO departmentVO) throws Exception {
		return userDAO.getUsersOfDepartment(departmentVO);
	}

}
