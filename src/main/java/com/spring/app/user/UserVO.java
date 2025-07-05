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

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.spring.app.chat.ChatRoomVO;

import jakarta.persistence.criteria.Join;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UserVO implements UserDetails, OAuth2User {
	
	
	@NotBlank(groups=JoinGroup.class)
	private String username;
	@Size(min=8,max=16)
	@NotBlank(groups=JoinGroup.class)
	private String password;
	private String passwordCheck;
	@NotBlank(groups = {JoinGroup.class, UpdateGroup.class})
	private String name;
	@Email(groups = {JoinGroup.class, UpdateGroup.class})
	private String email;
	@NotBlank(groups = {JoinGroup.class, UpdateGroup.class})
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
	private Long roleNum;
	@JsonIgnore //json으로 가져올 시 직렬화 문제 해결
	private List<RoleVO> roleList;
	@JsonIgnore
	private List<StateVO> stateList;
	@JsonIgnore
	private Map<String, Object> attributes;
	@JsonIgnore
	private String accessToken;
	
	private ChatRoomVO chatRoomVO;
	private Long roomId;
	
	@JsonIgnore
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
