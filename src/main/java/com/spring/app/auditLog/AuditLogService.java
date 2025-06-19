package com.spring.app.auditLog;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class AuditLogService {
	
	@Autowired
	private AuditLogDAO auditLogDAO;
	
	public void log(String username, String actionType, String targetTable,
            String targetId, String description, HttpServletRequest request) throws Exception {
		AuditLogVO auditLogVO = new AuditLogVO();
		
		auditLogVO.setUsername(username);
		auditLogVO.setActionType(actionType);
		auditLogVO.setTargetTable(targetTable);
		auditLogVO.setTargetId(targetId);
		auditLogVO.setDescription(description);
		
		//행위자 Ip주소 가져오기
		auditLogVO.setIpAddress(getClientIp(request));
		//사용 브라우저 정보 (예 : Chrome)
		auditLogVO.setUserAgent(request.getHeader("User-Agent"));
		//현재 서울 시각 넣기
		LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Seoul"));
		Timestamp timestamp = Timestamp.valueOf(now);
		auditLogVO.setCreatedAt(timestamp);
		
		auditLogDAO.addAuditLog(auditLogVO);
	}
	
	//행위자 Ip주소 가져오기
	private String getClientIp(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if(ip == null) ip = request.getRemoteAddr();
		return ip;
	}

}
