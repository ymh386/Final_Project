package com.spring.app.user;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UserVO {
	private String username;
	private String password;
	private String name;
	private String email;
	private String phone;
	private String birth;
	private String fileName;
	private String oriName;
	private boolean accountNonExpired;
	private boolean accountNonLocked;
	private boolean credentialsNonExpired;
	private boolean enabled;
	private String sns;
	private Date createdAt;
}
