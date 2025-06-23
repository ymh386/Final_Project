package com.spring.app.auditLog;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.spring.app.home.util.Pager;

@Mapper
public interface AuditLogDAO {
	
	//감사 기록 리스트
	public List<AuditLogVO> getList(Pager pager) throws Exception;
	
	//감사 기록 총 개수(해당 카테고리의 검색어 기준)
	public Long getAuditLogCount(Pager pager) throws Exception;
	
	//감사 기록
	public int addAuditLog(AuditLogVO auditLogVO) throws Exception;

}
