package com.spring.app.approval;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
	

}
