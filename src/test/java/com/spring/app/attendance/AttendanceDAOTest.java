package com.spring.app.attendance;

import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDate;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;



@SpringBootTest
class AttendanceDAOTest {
	
	
    @Autowired
    private AttendanceService service;

    @Test
    void testCheckIn() {
        // 출근
        AttendanceVO vo = service.checkIn("testUser");
        assertNotNull(vo.getAttendanceId(), "출근 후 generated key가 있어야 합니다");
        // 실제 DB에 저장되었는지 확인
        List<AttendanceVO> list = service.listByDate(LocalDate.now());
        assertTrue(
            list.stream().anyMatch(a -> a.getAttendanceId().equals(vo.getAttendanceId())),
            "listByDate 결과에 방금 체크인한 레코드가 있어야 합니다"
        );
    }
}
