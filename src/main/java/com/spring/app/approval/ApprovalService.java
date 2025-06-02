package com.spring.app.approval;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ApprovalService {
	
	@Autowired
	private ApprovalDAO approvalDAO;
	
	//카테고리 목록 가져오기
	public List<CategoryVO> addDocument() throws Exception {
		return approvalDAO.getCategory();
	}
	
	//결재 작성 시 양식 렌더링
	public FormVO getForm(CategoryVO categoryVO) throws Exception {
		return approvalDAO.getForm(categoryVO);
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

}
