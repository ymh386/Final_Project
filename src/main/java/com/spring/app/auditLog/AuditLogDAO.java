package com.spring.app.auditLog;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AuditLogDAO {
	
	public int addAuditLog(AuditLogVO auditLogVO) throws Exception;

}
