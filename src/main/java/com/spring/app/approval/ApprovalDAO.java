package com.spring.app.approval;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;

import com.spring.app.user.UserVO;

@Mapper
public interface ApprovalDAO {
	
	public List<CategoryVO> getCategory() throws Exception; //양식의 카테고리 리스트 가져오기
	
	public CategoryVO getCategoryDetail(CategoryVO categoryVO) throws Exception; //양식 등록할때 적은 카테고리 이름 가져오기 위함
	
	public List<FormVO> getForms() throws Exception; //양식 리스트 가져오기
	
	public FormVO getForm(FormVO formVO) throws Exception; //결재 작성 시 양식 렌더링
	
	public int addForm(FormVO formVO) throws Exception; //양식 추가
	
	public int updateForm(FormVO formVO) throws Exception; //양식 수정
	
	public int deleteForm(FormVO formVO) throws Exception; //양식 삭제
	
	public int addCategory(CategoryVO categoryVO) throws Exception; //양식 추가 시 해당 카테고리도 같이 추가
	
	public int updateCategory(CategoryVO categoryVO) throws Exception; //양식 수정 시 해당 카테고리도 같이 수정
	
	public int deleteCategory(CategoryVO categoryVO) throws Exception; //양식 삭제 시 해당 카테고리도 같이 삭제
	
	public int addDocument(DocumentVO documentVO) throws Exception; //전자결재 문서 추가
	
	//DB에서 생성된 키 사용 -> auto_increment로 생성된 값 자바에서 가져와 사용하기(본인은 xml에서 처리함)
//	@Options(useGeneratedKeys = true, keyProperty = "approvalId")
	public int addApproval(ApprovalVO approvalVO) throws Exception; //결재라인의 결재자 추가
	
	//결재문서 삭제
	public int deleteDocument(DocumentVO documentVO) throws Exception;
	
	//해당 결재문서에서 승인이나 반려된 정보들 조회
	public List<ApprovalVO> getAppOrRej(ApprovalVO approvalVO) throws Exception;
	
	//승인가능 목록 가져오기
	public List<ApprovalVO> getAwaitList(ApprovalVO approvalVO) throws Exception;
	
	//승인용건 디테일정보 가져오기
	public ApprovalVO getAwaitDetail(ApprovalVO approvalVO) throws Exception;
	
	//서명/도장 등록
	public int addSign(UserSignatureVO userSignatureVO) throws Exception;
	
	//서명/도장 삭제
	public int deleteSign(UserVO userVO) throws Exception;
	
	//현재승인자 승인상태 업데이트
	public int updateApprovalStatus(ApprovalVO approvalVO) throws Exception;
	
	//다음승인자 승인상태 업데이트
	public int updateChildStatus(ApprovalVO approvalVO) throws Exception;
	
	//최종 승인시 결재상태 업데이트
	public int updateDocumentStatus(DocumentVO documentVO) throws Exception;

	//결재문서별로 승인리스트 조회
	public List<ApprovalVO> getListByDocument(ApprovalVO approvalVO) throws Exception;
	
	//ContentHTML 업데이트
	public int updateContent(DocumentVO documentVO) throws Exception;
	
	//로그인한 유저의 승인내역 리스트
	public List<ApprovalVO> getList(Map<String, Object> map) throws Exception;
	
	//로그인한 유저의 승인내역 디테일
	public ApprovalVO getDetail(ApprovalVO approvalVO) throws Exception;
	
	//다음결재자 정보 조회
	public ApprovalVO getChild(ApprovalVO approvalVO) throws Exception;
}
