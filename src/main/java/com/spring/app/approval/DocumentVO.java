package com.spring.app.approval;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class DocumentVO {
	
	private Long documentId;
	private Long formId;
	private String writerId;
	private String documentTitle;
	private String contentHtml;
	private String documentStatus;
	private Date createdAt;

}
