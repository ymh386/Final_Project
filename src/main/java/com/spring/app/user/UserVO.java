package com.spring.app.user;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UserVO implements UserDetails, OAuth2User {
	
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
	private String position;
	private String parent;
	private DepartmentVO departmentVO;
	private Long trainerCode;
	private Long stateNum;
	private String state;
	
	private List<RoleVO> roleList;
	private List<StateVO> stateList;
	private Map<String, Object> attributes;
	private String accessToken;
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		// TODO Auto-generated method stub
		List<GrantedAuthority> ar = new ArrayList<>();
		
		for (RoleVO roleVO : this.roleList) {
			GrantedAuthority g = new SimpleGrantedAuthority(roleVO.getRoleName());
			ar.add(g);
		}
		
		if (this.stateList!=null) {
			for (StateVO stateVO : this.stateList) {
				GrantedAuthority g = new SimpleGrantedAuthority(stateVO.getState());
				ar.add(g);
			}
		}
		return ar;
	}
	
}
