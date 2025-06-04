package com.spring.app.approval;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/approval/")
@Slf4j
public class ApprovalController {
	
	@Autowired
	private ApprovalService approvalService;
	
	@GetMapping("formRegister")
	public String formRegister(Model model) throws Exception {
		
		return "form/formRegister";
	}
	
	@PostMapping("formRegister")
	public String formRegister(FormVO formVO) throws Exception {
		
		int result = approvalService.formRegister(formVO);
		
		return "redirect:/";
	}
	
	@GetMapping("addDocument")
	public String addDocument(Model model) throws Exception {
		List<CategoryVO> ar = new ArrayList<>();
		ar = approvalService.addDocument();
		model.addAttribute("ar", ar);
		
		return "approval/addDocument";
	}
	
	//전자결재 작성 시 양식 렌더링하기
	@ResponseBody
	@GetMapping("getForm")
	public FormVO getForm(CategoryVO categoryVO) throws Exception {
		FormVO formVO = approvalService.getForm(categoryVO);
		 
		return formVO;
	}

}
