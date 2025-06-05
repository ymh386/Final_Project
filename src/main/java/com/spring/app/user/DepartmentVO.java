package com.spring.app.user;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DepartmentVO {
	
	private Long departmentId;
	private String departmentName;
	private String description;
	private Date createdAt;
	private Date updatedAt;

}
