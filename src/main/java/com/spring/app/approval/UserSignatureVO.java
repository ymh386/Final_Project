package com.spring.app.approval;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class UserSignatureVO {
	
	private Long signatureId;
	private String username;
	private String fileName;
	private String oriName;
	private String signatureType;
	private Date uploadedAt;

}
