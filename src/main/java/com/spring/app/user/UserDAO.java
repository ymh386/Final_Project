package com.spring.app.user;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.spring.app.approval.DocumentVO;
import com.spring.app.approval.UserSignatureVO;

@Mapper
public interface UserDAO {
	
	int join(UserVO userVO) throws Exception;
	
	int giveTrainerRole(MemberRoleVO memberRoleVO) throws Exception;
	
	int trainerJoin(UserVO userVO) throws Exception;
	
	int changePw(UserVO userVO) throws Exception;
	
	String getEmail(String email) throws Exception;
	
	UserVO getUserByEmail(String email) throws Exception;
	
	String getPhone(String phone) throws Exception;
	
	UserVO getUserByPhone(String phone) throws Exception;
	
	Long getTrainerCode() throws Exception;
	
	UserVO detail(UserVO userVO) throws Exception;
	
	List<UserVO> awaitUserList(UserVO userVO) throws Exception;
	
	int updateUserState(MemberStateVO memberStateVO) throws Exception;
	
	List<MemberRoleVO> getRole(@Param("username") String username) throws Exception;
	
	MemberStateVO checkSubscript(@Param("username") String username) throws Exception;
	
	int startSubscript(MemberStateVO memberStateVO) throws Exception;
	
	int cancelSubscript(MemberStateVO memberStateVO) throws Exception;
	
	int stopSubscript(MemberStateVO memberStateVO) throws Exception;

	List<UserVO> selectUsersByUsernamePrefix(@Param("prefix") String prefix);
	
	int countUsersByUsernamePrefix(Map<String, Object> params);

	
	int update(UserVO userVO) throws Exception;
	
	//트레이너등급 이상 회원들의 부서정보와 함께 조희
	List<UserVO> getUsersWithDepartment() throws Exception;
	
	//트레이너등급 이상 부서가없는 회원들의 정보 조회
	List<UserVO> getUsersNoDepartment() throws Exception;
	
	//트레이너등급 이상 부서별 회원들의 정보 조회
	List<UserVO> getUsersOfDepartment(DepartmentVO departmentVO) throws Exception;
	
	//부서등 정보 가져오기
	List<DepartmentVO> getDepartments() throws Exception;
	
	//부서 정보 가져오기
	public DepartmentVO getDepartment(DepartmentVO departmentVO) throws Exception;
	
	//전재결재 작성목록 불러오기
	public List<DocumentVO> getDocuments(DocumentVO documentVO) throws Exception;
	
	//로그인한 유저의 전자결재 작성목록 총 개수
	public Long getDocumentCount(DocumentVO documentVO) throws Exception;
	
	//전자결재 작성 디테일 불러오기
	public DocumentVO getDocument(DocumentVO documentVO) throws Exception;
	
	//서명 OR 도장 가져오기
	public UserSignatureVO getSign(UserVO userVO) throws Exception;
	
	//부서 추가
	public int addDepartment(DepartmentVO departmentVO) throws Exception;
	
	//부서 수정
	public int updateDepartment(DepartmentVO departmentVO) throws Exception;
	
	//부서 삭제
	public int deleteDepartment(DepartmentVO departmentVO) throws Exception;
	
	//해당 회원의 부서정보 변경
	public int updateDeptByUser(Map<String, Object> map) throws Exception;
	
	//해당부서의 부서장 가져오기
	public UserVO getParent(DepartmentVO departmentVO) throws Exception;
	
	//현재 부서장 부서원으로
	public int deleteHead(DepartmentVO departmentVO) throws Exception;
	
	//새로운 부서장 임명
	public int addHead(UserVO userVO) throws Exception;
	
	//해당 부서의 나머지 부서원들의 상급자를 새로운 부서장으로 변경
	public int updateParent(Map<String, Object> map) throws Exception;
	
	//회원 탈퇴
	public int deleteUser(UserVO userVO) throws Exception;
	
	


}
