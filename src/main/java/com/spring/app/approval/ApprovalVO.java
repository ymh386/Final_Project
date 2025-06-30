package com.spring.app.approval;

import java.sql.Date;

import com.spring.app.home.util.Pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ApprovalVO {
	
	private Long approvalId;
	private Long documentId;
	private String approverId;
	private Long parentId;
	private Long approvalStep;
	private String approvalStatus;
	private Date approvedAt;
	
	private DocumentVO documentVO;
	
	private Pager pager;

}
