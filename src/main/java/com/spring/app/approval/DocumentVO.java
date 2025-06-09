package com.spring.app.approval;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class DocumentVO {
	
	private Long documentId;
	private Long formId;
	private String writerId;
	private String documentTitle;
	private String contentHtml;
	private String documentStatus;
	private Date createdAt;
	
	private FormVO formVO;

}
