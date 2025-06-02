package com.spring.app.approval;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ApprovalDAO {
	
	public List<CategoryVO> getCategory() throws Exception; //양식의 카테고리 리스트 가져오기
	
	public CategoryVO getCategoryDetail(CategoryVO categoryVO) throws Exception; //양식 등록할때 적은 카테고리 이름 가져오기 위함
	
	public FormVO getForm(CategoryVO categoryVO) throws Exception; //결재 작성 시 양식 렌더링
	
	public int addForm(FormVO formVO) throws Exception; //양식 추가
	
	public int addCategory(CategoryVO categoryVO) throws Exception; //양식 추가 시 해당 카테고리도 같이 추가

}
