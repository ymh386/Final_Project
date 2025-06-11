package com.spring.app.user;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DepartmentVO {
	
	private Long departmentId;
	private String departmentName;
	private String description;
	private Date createdAt;
	private Date updatedAt;

}
