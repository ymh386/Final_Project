package com.spring.app.attendance;

import java.io.ByteArrayInputStream;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import com.spring.app.chart.AttendanceStatVO;
import com.spring.app.user.UserDAO;
import com.spring.app.user.UserVO;

@Service
public class AttendanceService {

	@Autowired
	public AttendanceDAO attendanceDAO;
	
	@Autowired
	public UserDAO userDAO;
	
	@Autowired
	private AttendanceExcelUtil attendanceExcelUtil;
	
	
	/**
     * 출근 처리
     *
     * @param username 로그인된 사용자 아이디
     * @return 방금 삽입된 AttendanceVO 객체 (attendanceId 포함)
     * @throws AttendanceException 이미 오늘 출근을 한 경우 예외 발생
     */
    public AttendanceVO checkIn(String username) throws AttendanceException {
        // ① “Asia/Seoul” 기준 오늘 날짜와 현재 시각 가져오기
        LocalDate today   = LocalDate.now(ZoneId.of("Asia/Seoul"));
        LocalTime nowTime = LocalTime.now(ZoneId.of("Asia/Seoul"));

        // ①-1) “9:00 이전=정상출근, 9:00~9:30=지각, 9:30 이후=결근”
        LocalTime nine   = LocalTime.of(9, 0);
        LocalTime nine30 = LocalTime.of(9, 30);
        String status;
        if (!nowTime.isAfter(nine)) {
            status = "정상출근"; // 정상출근
        } else if (nowTime.isBefore(nine30)) {
            status = "지각";    // 지각
        } else {
            status = "결근";  // 결근 처리
        }

        // ② 오늘자 동일 사용자 기록 조회 (중복 출근 방지)
        AttendanceVO existing = attendanceDAO.selectByUserAndDate(username, today);
        if (existing != null) {
            throw new AttendanceException("이미 오늘 출근을 하셨습니다.");
        }

        // ③ 출근 기록 삽입
        AttendanceVO vo = new AttendanceVO();
        vo.setUsername(username);
        vo.setAttendanceDate(today);
        vo.setCheckinTime(nowTime);
        vo.setStatus(status);

        try {
            attendanceDAO.insertCheckIn(vo);
        } catch (DuplicateKeyException ex) {
            // 혹시 모를 중복키(Unique) 예외 처리
            throw new AttendanceException("이미 오늘 출근 기록이 존재하여 등록할 수 없습니다.");
        }

        // insertCheckIn 호출 후 vo.attendanceId 값이 자동으로 채워집니다(useGeneratedKeys 설정)
        return vo;
    }

    /**
     * 퇴근 처리
     *
     * @param attendanceId 방금 출근한 레코드의 ID
     * @return 업데이트된 AttendanceVO 객체 (퇴근 시간이 포함된 상태)
     * @throws AttendanceException 잘못된 ID이거나 이미 퇴근된 경우 예외 발생
     */
    public AttendanceVO checkOut(Long attendanceId) throws AttendanceException {
        // 0) 기존 출근 레코드 조회 → 유효성 검사
        AttendanceVO vo = attendanceDAO.selectById(attendanceId);
        if (vo == null) {
            throw new AttendanceException("해당 출근 기록을 찾을 수 없습니다.");
        }
        if ("퇴근".equals(vo.getStatus())) {
            throw new AttendanceException("이미 퇴근 처리된 기록입니다.");
        }

        // 1) 현재 시각 가져오기
        LocalTime nowSeoul = LocalTime.now(ZoneId.of("Asia/Seoul"));
        vo.setCheckoutTime(nowSeoul);

        // 2) 정상출근한 경우만 상태를 '퇴근'으로 변경
        if ("정상출근".equals(vo.getStatus())) {
            vo.setStatus("퇴근");
        }
        // 지각/결근이면 상태는 그대로 둠 (checkoutTime만 업데이트됨)

        // 3) DB 업데이트
        try {
            attendanceDAO.updateCheckOut(vo);
        } catch (Exception ex) {
            throw new AttendanceException("퇴근 처리에 실패했습니다.");
        }

        // 4) 업데이트된 데이터 다시 조회
        return attendanceDAO.selectById(attendanceId);
    }

    
    
    

    public List<AttendanceVO> getAttendanceByUser(String username) {
        return attendanceDAO.selectByUser(username);
    }

	  
	  
	  public List<AttendanceVO> listByUser(String username){
		  
		  return attendanceDAO.selectByUser(username);
		  
	  }
	  
	  public List<Map<String, Object>> listByDate(LocalDate date){
		  
		  return attendanceDAO.selectByDate(date);
	  }
	  
	  public List<AttendanceVO> listAll(){
		  
		  return attendanceDAO.selectAll();
	  }
	  
	  
	  public void updateAttendance(AttendanceVO vo) {
	        attendanceDAO.updateAttendance(vo);
	    }

	  
	 

	    public ByteArrayInputStream exportAttendanceToExcel(String date) {
	        LocalDate searchDate = LocalDate.parse(date);
	        List<Map<String, Object>> data = listByDate(searchDate);
	        return attendanceExcelUtil.generateAttendanceExcel(data, date);
	    }
	  
	  
	  
	  
	  
	  

}