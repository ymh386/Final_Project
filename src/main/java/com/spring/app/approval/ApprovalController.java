package com.spring.app.approval;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.app.user.DepartmentVO;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/approval/*")
@Slf4j
public class ApprovalController {
	
	@Autowired
	private ApprovalService approvalService;
	@Autowired
	private UserService userService;
	
	//결재양식 등록 UI
	@GetMapping("formRegister")
	public String formRegister(Model model) throws Exception {
		
		return "form/formRegister";
	}
	
	//결재양식 등록 프로세스
	@PostMapping("formRegister")
	public String formRegister(FormVO formVO) throws Exception {
		
		int result = approvalService.formRegister(formVO);
		
		return "redirect:/";
	}
	
	//전자결재 작성 UI
	@GetMapping("addDocument")
	public String addDocument(Model model) throws Exception {
		List<FormVO> ar = new ArrayList<>();
		ar = approvalService.getForms();
		model.addAttribute("ar", ar);
		
		return "approval/addDocument";
	}
	
	//전자결재 작성 프로세스(document와 approval DB에 추가)
	@PostMapping("addDocument")
	public String addDocument(@RequestParam("approvalLineJson") String approvalLineJson, DocumentVO documentVO, @AuthenticationPrincipal UserVO userVO) throws Exception {
		//JSON <-> Java객체 변환을 도와줌
		ObjectMapper mapper = new ObjectMapper();
		//JSON 문자열을 읽어서 원하는 타입으로 바꿔줌
	    List<ApprovalVO> approverList = mapper.readValue(
	        approvalLineJson,
	        //바뀐 List<ApprovalVO>는 아직 불안정하기 떄문에 제네릭 타입을 ObjectMapper에 정확하게 알려주기 위함
	        new TypeReference<List<ApprovalVO>>() {}
	    );
	    
	    documentVO.setWriterId(userVO.getUsername());
	    //approverList 이제 사용 가능
	    approvalService.addDocument(documentVO, approverList);
	    
	    return "redirect:/";
	}
	
	//전자결재 작성 시 양식 렌더링하기
	@ResponseBody
	@GetMapping("getForm")
	public FormVO getForm(FormVO formVO) throws Exception {
		formVO = approvalService.getForm(formVO);
		 
		return formVO;
	}
	
	@GetMapping("getLine")
	@ResponseBody
	public List<Map<String, Object>> getLine() throws Exception {
		
		//1. 트레이너등급 이상 회원들의 부서정보와 함께 조희
		List<UserVO> users = userService.getUsersWithDepartment();
		
		//2. 부서 정보 가져오기
		List<DepartmentVO> depts = userService.getDepartments();
		
		//3. 부서별 사용자 그룹핑
		Map<Long, List<UserVO>> usersByDept = users.stream()
				.filter(user -> user.getDepartmentVO() != null)
				.collect(Collectors.groupingBy(user -> user.getDepartmentVO().getDepartmentId(),
				Collectors.collectingAndThen(Collectors.toList(), list -> {
		            list.sort(Comparator.comparing(user -> !"DP1".equals(user.getPosition()))); // 부서장 먼저
		            return list;
		            })
				));
		 
		
		
		//4. 부서 트리 가져오기
		List<Map<String, Object>> tree = new ArrayList<>();
		
		//트리에서 먼저 보여질 부서들 정보 맵에 넣기
		Map<String, Object> deptNode = null;
		deptNode = new HashMap<>();
		deptNode.put("id", "admin");
		deptNode.put("text", "관리자");
		deptNode.put("data", Map.of("username", "admin", "name", "admin"));
		tree.add(deptNode);
		for (DepartmentVO dept : depts) {
			deptNode = new HashMap<>();
	        deptNode.put("id", "dept-" + dept.getDepartmentId());
	        deptNode.put("text", dept.getDepartmentName());
	        deptNode.put("children", new ArrayList<>());
	        
	        //부서별 부서원들 해당 부서맵안에 넣기
	        List<Map<String, Object>> childNodes = new ArrayList<>();
	        for (UserVO user : usersByDept.getOrDefault(dept.getDepartmentId(), List.of())) {
	            Map<String, Object> userNode = new HashMap<>();
	            userNode.put("id", "user-" + user.getUsername());
	            userNode.put("text", (user.getPosition().equals("DP1") ? "[부서장] " : "") + user.getName());
	            userNode.put("data", Map.of("username", user.getUsername(), "name", user.getName()));
	            childNodes.add(userNode);
	        }
	        
	        deptNode.put("children", childNodes);
	        tree.add(deptNode);
			
		}
		
		return tree;
	}

}
