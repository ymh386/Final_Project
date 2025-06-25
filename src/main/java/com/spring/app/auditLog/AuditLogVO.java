package com.spring.app.auditLog;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AuditLogVO {
	
	   private Long auditLogId; 
	   private String username;
	   private String actionType;
       private String targetTable;
	   private String targetId;
	   private String description;
	   private String ipAddress;
	   private String userAgent;
	   private Timestamp createdAt;
}   
    