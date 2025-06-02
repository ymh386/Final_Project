package com.spring.app.approval;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class FormVO {
	
	private Long formId;
	private String formTitle;
	private String contentHtml;
	private Date createdAt;
	private Long categoryId;

}
