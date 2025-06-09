package com.spring.app.approval;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ApprovalVO {
	
	private Long approvalId;
	private Long documentId;
	private String approverId;
	private Long parentId;
	private Long approvalStep;
	private String approvalStatus;
	private Date approvedAt;

}
