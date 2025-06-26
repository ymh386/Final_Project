package com.spring.app.chart;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.approval.ApprovalDAO;
import com.spring.app.approval.LeaveVO;
import com.spring.app.attendance.AttendanceDAO;
import com.spring.app.user.DepartmentVO;
import com.spring.app.user.UserDAO;
import com.spring.app.user.UserVO;

@Service
public class ChartService {
	
	@Autowired
	private AttendanceDAO attendanceDAO;
	
	@Autowired
	private ApprovalDAO approvalDAO;
	
	@Autowired
	private UserDAO userDAO;
	
	//근태율 범위설정 가능(관리자용)
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
	
	
	
	//근태율 자신것만 조회(유저용)
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
	
	//근태율 현재월만 조회(자기자신)
	// 이번 달 근태 통계 조회 (유저용)
	public AttendanceStatVO getCurrentMonthStats(Integer year, Integer month, String username) throws Exception {
		//차트에 담을 정보
	    AttendanceStatVO stat = attendanceDAO.getCurrentMonthStats(year, month, username);

	    if (stat == null) {
	        // 조회 결과가 없으면 0으로 채워진 객체 생성
	        stat = new AttendanceStatVO();
	        stat.setTotal(0);
	        stat.setPresent(0);
	        stat.setLate(0);
	        stat.setAbsent(0);
	    }

	    return stat;
	}
	
	//휴가율 범위설정 가능(관리자용)
	public List<LeaveStatVO> getUsedLeaveByType(Integer year, String scope, Long departmentId, String username) throws Exception {
		//타입별 휴가사용량을 담을 리스트
		List<LeaveStatVO> leaveStats = new ArrayList<>();
		//LeaveStatVO안에 담을 LeaveVO 객체
		LeaveStatVO leaveStatVO = null;
		//총 휴가타읍들을 담음
		List<LeaveVO> leaveList = approvalDAO.getLeaveTypes();
		//휴가타입 하나씩 꺼내서 사용량을 가져와 leaveStats에 담음
	    for (LeaveVO leaveVO : leaveList) {
	    	leaveStatVO = new LeaveStatVO();
	    	leaveStatVO.setTypeId(leaveVO.getTypeId());
	        Long used = approvalDAO.getUsedLeavesByType(year, scope, departmentId, username, leaveVO.getTypeId());
	        leaveStatVO.setUsedDays(used);
	        leaveStatVO.setLeaveVO(leaveVO);
	        leaveStats.add(leaveStatVO);
	    }
	    return leaveStats;
	}
	
	//휴가율 자신것만 조회(유저용)
	public List<LeaveStatVO> getUsedLeaveByType(Integer year, String username) throws Exception {
		//타입별 휴가사용량을 담을 리스트
		List<LeaveStatVO> leaveStats = new ArrayList<>();
		//LeaveStatVO안에 담을 LeaveVO 객체
		LeaveStatVO leaveStatVO = null;
		//총 휴가타읍들을 담음
		List<LeaveVO> leaveList = approvalDAO.getLeaveTypes();
		//휴가타입 하나씩 꺼내서 사용량을 가져와 leaveStats에 담음
	    for (LeaveVO leaveVO : leaveList) {
	    	leaveStatVO = new LeaveStatVO();
	    	leaveStatVO.setTypeId(leaveVO.getTypeId());
	        Long used = approvalDAO.getUsedLeavesByUser(year, username, leaveVO.getTypeId());
	        leaveStatVO.setUsedDays(used);
	        leaveStatVO.setLeaveVO(leaveVO);
	        leaveStats.add(leaveStatVO);
	    }
	    return leaveStats;
	}
	
	
	//트레이너 이상 등급의 부서별 회원들 조회
	public List<UserVO> getUsersOfDepartment(DepartmentVO departmentVO) throws Exception {
		return userDAO.getUsersOfDepartment(departmentVO);
	}

}
