package com.spring.app.approval;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.app.user.UserVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ApprovalService {
	
	@Autowired
	private ApprovalDAO approvalDAO;
	
	//카테고리 목록 가져오기
	public List<FormVO> getForms() throws Exception {
		return approvalDAO.getForms();
	}
	
	//결재 작성 시 양식 렌더링
	public FormVO getForm(FormVO formVO) throws Exception {
		return approvalDAO.getForm(formVO);
	}
	
	//결재 양식 등록
	public int formRegister(FormVO formVO) throws Exception {
		CategoryVO categoryVO = new CategoryVO();
		categoryVO.setCategoryName(formVO.getFormTitle());
		int result = approvalDAO.addCategory(categoryVO); //양식을 등록하면서 해당 카테고리이름으로 카테고리도 같이등룩
		
		if(result > 0) {
			categoryVO = approvalDAO.getCategoryDetail(categoryVO); //양식 만들 때 작성한 카테고리 이름으로 디테일 가져오기
			
			formVO.setCategoryId(categoryVO.getCategoryId()); //가져온 categoryVO의 ID formVO에 categoryID 넣기
			
			result = approvalDAO.addForm(formVO);
		}
		
		return result;
	}
	
	//결재 양식 수정
	public int formUpdate(FormVO formVO) throws Exception {
		CategoryVO categoryVO = new CategoryVO();
		categoryVO.setCategoryId(formVO.getCategoryId());
		categoryVO.setCategoryName(formVO.getFormTitle());
		int result = approvalDAO.updateCategory(categoryVO); //양식을 수정하면서 해당 카테고리이름을 카테고리도 같이수정
		
		if(result > 0) {
			
			result = approvalDAO.updateForm(formVO);
		}
		
		return result;
	}
	
	//결재 양식 삭제
	public int formDelete(FormVO formVO) throws Exception {
		formVO = approvalDAO.getForm(formVO); //categoryId 가져오기 위함
		CategoryVO categoryVO = new CategoryVO();
		categoryVO.setCategoryId(formVO.getCategoryId());
		
		int result = approvalDAO.deleteForm(formVO); //양식 먼저 삭제
		
		//양식 삭제가 성공했을 때
		if(result > 0) {
			//카테고리도 삭제
			result = approvalDAO.deleteCategory(categoryVO);
		}
		
		return result;
	}
	
	public void addDocument(DocumentVO documentVO, List<ApprovalVO> approverList) throws Exception {
		//결재문서 먼저 INSERT
		int result = approvalDAO.addDocument(documentVO);
		//결재문서 INSERT가 성공했을 때
		if(result > 0) {
			//첫 결재자의 parentId는 null
			Long parentId = null;
			//첫 결재자의 상태
			String approvalStatus = "AS0";
			for(ApprovalVO vo : approverList) {
				vo.setDocumentId(documentVO.getDocumentId());
				vo.setParentId(parentId);
				vo.setApprovalStatus(approvalStatus);
				//결재자 INSERT
				approvalDAO.addApproval(vo);
				//방금 넣은 결재자의 approvalId parentId에 넣기
				parentId = vo.getApprovalId();
				//2번째 결재자부턴 상태 '미도달'
				approvalStatus = "AS3";
			}
		}
	}
	
	//결재문서 삭제
	public int deleteDocument(DocumentVO documentVO) throws Exception {
		ApprovalVO approvalVO = new ApprovalVO();
		approvalVO.setDocumentId(documentVO.getDocumentId());
		
		//승인절차가 한번이라도 진행된 것들
		List<ApprovalVO> ar = approvalDAO.getAppOrRej(approvalVO);
		
		//없으면 삭제 실행
		if(ar.size() <= 0) {
			return approvalDAO.deleteDocument(documentVO);
		}else {
			return 0;
		}
		
		
	}
	
	//승인가능 목록 가져오기
	public List<ApprovalVO> getAwaitList(ApprovalVO approvalVO) throws Exception {
		return approvalDAO.getAwaitList(approvalVO);
	}
	
	//승인용건 디테일정보 가져오기
	public ApprovalVO getAwaitDetail(ApprovalVO approvalVO) throws Exception {
		return approvalDAO.getAwaitDetail(approvalVO);
	}
	
	//서명 or 도장 등록
	public int addSign(UserSignatureVO userSignatureVO) throws Exception {
		return approvalDAO.addSign(userSignatureVO);
	}
	
	//서명/도장 삭제
	public int deleteSign(UserVO userVO) throws Exception {
		return approvalDAO.deleteSign(userVO);
	}
	
	//결재 승인 처리
	public int approve(ApprovalVO approvalVO, DocumentVO documentVO) throws Exception {

		//1. 현재 승인정보의 상태를 승인으로 변경
		approvalVO.setApprovalStatus("AS1");
		int result = approvalDAO.updateApprovalStatus(approvalVO);
		
		//1번 성공 시
		if(result > 0) {
			//2. 다음 승인정보를 진행중으로 변경
			approvalVO.setApprovalStatus("AS0");
			result = approvalDAO.updateChildStatus(approvalVO);
			
			//2번 실패 시 -> 다음결재자가 없음(최종승인 됨)
			if(result <= 0) {
				//3. 해당 결재문서의 모든 승인정보 조회
				List<ApprovalVO> ar = approvalDAO.getListByDocument(approvalVO);
				//3번에서 조회한 리스트에서 상태가 승인인 정보를 제외한 정보들만 가져옴
				List<ApprovalVO> ar2 =  ar.stream()
						.filter(a -> !"AS1".equals(a.getApprovalStatus()))
						.collect(Collectors.toList());
				//3번에서 최종으로 가져온 리스트가 NULL 즉, 모두가 승인상태라면 결재문서의 상태를 승인으로 변경
				if(ar2.size() < 1) {
					documentVO.setDocumentStatus("D1");
					result = approvalDAO.updateDocumentStatus(documentVO);
				}
			}
		}
		
		//모든과정이 다 성공하면 새로 렌더링된 문서 저장
		if(result > 0) {
			approvalDAO.updateContent(documentVO);
		}
		
		return result;
	}
	
	public int rejection(ApprovalVO approvalVO, DocumentVO documentVO) throws Exception {
		
		//1. 현재 승인정보의 상태를 반려로 변경
		approvalVO.setApprovalStatus("AS2");
		int result = approvalDAO.updateApprovalStatus(approvalVO);
		
		if(result > 0) {
			//2. 해당 결재문서의 모든 승인정보 조회
			List<ApprovalVO> ar = approvalDAO.getListByDocument(approvalVO);
			//2번에서 조회한 리스트에서 상태가 반려인 정보를 제외한 정보들만 가져옴
			List<ApprovalVO> ar2 =  ar.stream()
					.filter(a -> "AS2".equals(a.getApprovalStatus()))
					.collect(Collectors.toList());
			
			//3. 2번에서 최종으로 가져온 리스트가 NOT NULL 즉, 하나라도 반려상태라면 결재문서의 상태를 반려로 변경
			if(ar2.size() > 0) {
				documentVO.setDocumentStatus("D2");
				result = approvalDAO.updateDocumentStatus(documentVO);
			}
		}
		
		return result;
	}
	
	//로그인한 유저의 승인내역 리스트
	public List<ApprovalVO> getList(ApprovalVO approvalVO, String search) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("approvalVO", approvalVO);
		map.put("search", search);
		
		return approvalDAO.getList(map);
	}
	
	//로그인한 유저의 승인내역 디테일
	public ApprovalVO getDetail(ApprovalVO approvalVO) throws Exception {
		return approvalDAO.getDetail(approvalVO);
	}

}
