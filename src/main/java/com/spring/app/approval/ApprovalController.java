package com.spring.app.approval;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.app.auditLog.AuditLogService;
import com.spring.app.files.FileManager;
import com.spring.app.user.DepartmentVO;
import com.spring.app.user.UserService;
import com.spring.app.user.UserVO;
import com.spring.app.websocket.NotificationManager;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/approval/*")
@Slf4j
public class ApprovalController {
	
	//이미지파일 확장자 리스트 -> 도장업로드시 이미지파일만 가능하게 하기위함
	private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".png", ".jpg", ".jpeg", ".gif");
	
	@Autowired
	private ApprovalService approvalService;
	@Autowired
	private UserService userService;  
	
	@Autowired
	private FileManager fileManager;
	
	@Autowired
	private NotificationManager notificationManager;
	
	@Autowired
	private AuditLogService auditLogService;
	
	@Value("${board.file.path}")
	private String path;
	
	//결재양식 리스트
	@GetMapping("formList")
	public String formList(Model model) throws Exception {
		List<FormVO> ar = approvalService.getForms();
		
		model.addAttribute("ar", ar);
		
		return "form/formList";
		
	}
	
	//결재양식 상세정보
	@GetMapping("formDetail")
	public String formDetail(FormVO formVO, Model model) throws Exception {
		formVO = approvalService.getForm(formVO);
		
		model.addAttribute("vo", formVO);
		
		return "form/formDetail";
	}
	
	//결재양식 등록 UI
	@GetMapping("formRegister")
	public String formRegister(Model model) throws Exception {
		
		return "form/formRegister";
	}
	
	//결재양식 등록 프로세스
	@PostMapping("formRegister")
	public String formRegister(FormVO formVO, @AuthenticationPrincipal UserVO userVO, HttpServletRequest request) throws Exception {
		
		int result = approvalService.formRegister(formVO);
		
		if(result > 0) {
			// 로그/감사 기록용
			auditLogService.log(
			        userVO.getUsername(),
			        "CREATE_FORM",
			        "FORM",
			        formVO.getFormId().toString(),
			        userVO.getUsername() + "이 " + formVO.getFormId() + "번 양식을 생성",
			        request
			    );
		}
		
		return "redirect:./formList";
	}
	
	//결재양식 수정 UI
	@GetMapping("formUpdate")
	public String formUpdate(FormVO formVO, Model model) throws Exception {
		formVO = approvalService.getForm(formVO);
		
		model.addAttribute("vo", formVO);
		
		return "form/formUpdate";
	}
	
	//결재양식 수정 프로세스
	@PostMapping("formUpdate")
	public String formUpdate(FormVO formVO, @AuthenticationPrincipal UserVO userVO, HttpServletRequest request) throws Exception {
		
		int result = approvalService.formUpdate(formVO);
		
		if(result > 0) {
			// 로그/감사 기록용
			auditLogService.log(
			        userVO.getUsername(),
			        "UPDATE_FORM",
			        "FORM",
			        formVO.getFormId().toString(),
			        userVO.getUsername() + "이 " + formVO.getFormId() + "번 양식을 수정",
			        request
			    );
		}
		
		return "redirect:./formDetail?formId=".concat(formVO.getFormId().toString());
		
	}
	
	//결재양식 삭제
	@GetMapping("formDelete")
	public String formDelete(FormVO formVO, @AuthenticationPrincipal UserVO userVO, HttpServletRequest request) throws Exception {
		
		int result = approvalService.formDelete(formVO);
		
		if(result > 0) {
			// 로그/감사 기록용
			auditLogService.log(
			        userVO.getUsername(),
			        "UPDATE_FORM",
			        "FORM",
			        formVO.getFormId().toString(),
			        userVO.getUsername() + "이 " + formVO.getFormId() + "번 양식을 삭제",
			        request
			    );
		}
		
		return "redirect:./formList";
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
	public String addDocument(@RequestParam("approvalLineJson") String approvalLineJson, DocumentVO documentVO, @AuthenticationPrincipal UserVO userVO, HttpServletRequest request) throws Exception {
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
	    approvalService.addDocument(documentVO, approverList, request);
	    
		
	    
	    return "redirect:/";
	}
	
	//전자결재 문서 삭제
	@GetMapping("deleteDocument")
	public String deleteDocument(@AuthenticationPrincipal UserVO userVO, DocumentVO documentVO, Model model, HttpServletRequest request) throws Exception {
		documentVO.setWriterId(userVO.getUsername());
		
		int result = approvalService.deleteDocument(documentVO, request);
		
		if(result > 0) {
			return "redirect:/user/getDocuments";
		}else {
			model.addAttribute("result", "승인절차가 한 번 이상 진행된 요청은 취소할 수 없습니다.");
			model.addAttribute("path", "/user/getDocument?documentId=".concat(documentVO.getDocumentId().toString()));
			
			return "commons/result";
		}
		
		
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
		
		//1. 트레이너등급 이상이며 승인을 받은 회원들을 부서정보와 함께 조희
		List<UserVO> users = userService.getUsersWithDepartment();
		
		//2. 부서 정보 가져오기
		List<DepartmentVO> depts = userService.getDepartments();
		
		//3. 부서별 사용자 그룹핑
		Map<Long, List<UserVO>> usersByDept = users.stream() //list를 stream으로 변환
				.filter(user -> user.getDepartmentVO() != null) //부서정보가 있는 사용자만 추출
				.collect(Collectors.groupingBy(user -> user.getDepartmentVO().getDepartmentId(), //부서ID를 기준으로 그룹을 나눔
				Collectors.collectingAndThen(Collectors.toList(), list -> { //그룹에 속한 사용자 리스트 수집 -> 그룹나눈 후 후처리(정렬)
		            list.sort(Comparator.comparing(user -> !"DP1".equals(user.getPosition()))); // 부서장 먼저(조건식이 false면 가장 앞으로 옴 -> DP1이 부서장이므로 부서장이면 !true = false)
		            return list;
		            })
				));
		 
		
		
		//4. 부서별로 하위노드에 해당 부서의 유저들을 모아둔 최상위 노드의 리스트(조직도)
		List<Map<String, Object>> tree = new ArrayList<>();
		
		//트리에서 먼저 보여질 부서들 정보 맵에 넣기
		Map<String, Object> deptMap = null;
		//관리자는 정해진 부서가 없고 부서와 같은 라인에 서야하므로 반복문 전에 미리 넣어준다.
		deptMap = new HashMap<>();
		deptMap.put("id", "admin");
		deptMap.put("text", "관리자");
		deptMap.put("data", Map.of("username", "admin", "name", "admin"));
		//조직도로 사용할 리스트tree에 map을 넣는다.
		tree.add(deptMap);
		//부서들중 부서하나씩 꺼내서 반복문 실행
		for (DepartmentVO dept : depts) {
			deptMap = new HashMap<>();
			//조직도에서 사용할 해당 부서의 정보들을 넣음
	        deptMap.put("id", dept.getDepartmentId());
	        deptMap.put("text", dept.getDepartmentName());
	        //children은 해당객체 클릭 시 하위 객체들 보여지는것 -> 조직도에서 부서 클릭 시 부서 안에 조직원들이 보여질 때 조직원들의 데이터
	        deptMap.put("children", new ArrayList<>());
	        
	        //위에 children에 넣을 값 -> 조직도에서 부서마다의 부서원들의 정보를 담은 Map의 List
	        List<Map<String, Object>> childMaps = new ArrayList<>();
	        //그룹핑시킨 Map에서 해당 dept의 departmentId키로 꺼낸 user리스트로 반복문 돌리기, getorDefault는 해당 부서의 유저가 없으면 List.of()로 에러방지
	        for (UserVO user : usersByDept.getOrDefault(dept.getDepartmentId(), List.of())) {
	            Map<String, Object> userMap = new HashMap<>();
	            //부서안에서 꺼낸 유저리스트에서 하나를꺼낸 유저의 정보를 넣음
	            userMap.put("id", user.getUsername());
	            //부서장 직책이면 이름앞에 [부서장]으로 강조
	            userMap.put("text", (user.getPosition().equals("DP1") ? "[부서장] " : "") + user.getName());
	            //data는 username과 name을 맵형태로 넣은 맵 -> 자바스크립트(프론트)에서 데이터로 사용예정
	            userMap.put("data", Map.of("username", user.getUsername(), "name", user.getName()));
	            //한 유저의 정보를 맵에 담음
	            childMaps.add(userMap);
	        }
	        //한 부서의 모든 유저의 정보를 답은 맵을 해당부서의 children(하위노드)로 넣음
	        deptMap.put("children", childMaps);
	        //해당부서를 tree(조직도)에 넣음
	        tree.add(deptMap);
			
		}
		
		return tree;
	}
	
	//로그인한 사용자 기준 승인대기중인 결재문서 목록 가져오기
	@GetMapping("awaitList")
	public String getAwaitList(@AuthenticationPrincipal UserVO userVO, ApprovalVO approvalVO, Model model) throws Exception {
		approvalVO.setApproverId(userVO.getUsername());
		List<ApprovalVO> ar = approvalService.getAwaitList(approvalVO);
		
		model.addAttribute("ar", ar);
		
		return "approval/awaitList";
	}
	
	//로그인한 사용자 기준 승인대기중인 결재문서 정보(디테일) 가져오기
	@GetMapping("awaitDetail")
	public String getAwaitDetail(@AuthenticationPrincipal UserVO userVO, ApprovalVO approvalVO, Model model) throws Exception {
		approvalVO.setApproverId(userVO.getUsername());
		approvalVO = approvalService.getAwaitDetail(approvalVO);
		
		model.addAttribute("vo", approvalVO);
		
		return "approval/awaitDetail";
	}
	
	//서명등록화면
	@GetMapping("registerSign")
	public String registerSign(@AuthenticationPrincipal UserVO userVO, Model model) throws Exception {
		
		//로그인한 사용자의 서명등록 여부 확인
		UserSignatureVO userSignatureVO = userService.getSign(userVO);
		
		//서명이 없으면 등록하러가기
		if(userSignatureVO == null) {
			return "approval/registerSign";
			//있으면 등록X
		}else {
			model.addAttribute("result", "이미 등록되어있습니다.");
			model.addAttribute("path", "/user/mypage");
			return "commons/result";
		}
		
		
		
	}
	
	@PostMapping("saveSign")
	public String saveSign(@AuthenticationPrincipal UserVO userVO, @RequestParam("imageData") String imageData, HttpServletRequest request) throws Exception {
		UserSignatureVO userSignatureVO = new UserSignatureVO();
		
		System.out.println(imageData);
		
		//data:image/png;base64,.... 형식의 문자열에서 base64 부분만 추출
		String base64Image = imageData.split(",")[1];
		//Base64로 디코딩하여 이미지로 변환 가능한 byte[] 배열로 만듬
		byte[] imageBytes = Base64.getDecoder().decode(base64Image);
		
		//랜덤 문자열 가져오기
		String uuid = UUID.randomUUID().toString();
		//가져온 랜덤 문자열로 파일이름 만들기
		String fileName = uuid.concat("_signature_").concat(userVO.getUsername()).concat(".png");
		
		//해당 경로안에 해당 디렉토리를 생성합니다 (이미 있으면 무시됨).
		Path uploadDir = Paths.get(path.concat("userSignature"));
		Files.createDirectories(uploadDir);
		
		//최종 파일 경로를 지정하고 디코딩된 이미지를 서버에 저장
		Path filePath = uploadDir.resolve(fileName);
		Files.write(filePath, imageBytes);
		
		//DB에 넣을 정보 담기
		userSignatureVO.setUsername(userVO.getUsername());
		userSignatureVO.setFileName(fileName);
		userSignatureVO.setOriName(null);
		userSignatureVO.setSignatureType("ST0");
		
		//DB에 INSERT
		int result = approvalService.addSign(userSignatureVO);
		
		if(result > 0) {
			// 로그/감사 기록용
			auditLogService.log(
			        userVO.getUsername(),
			        "ADD_SIGN",
			        "USER_SIGNATURE",
			        userSignatureVO.getSignatureId().toString(),
			        userVO.getUsername() + "이 서명 등록",
			        request
			    );
		}
		
		return "redirect:/user/mypage";
	}
	
	@PostMapping("saveStamp")
	public String saveStamp(@AuthenticationPrincipal UserVO userVO, MultipartFile stampFile, Model model, HttpServletRequest request) throws Exception {
		
		//파일 지정을 안했을 때 실행안함
		if (stampFile.isEmpty()) {
			model.addAttribute("result", "파일을 선택해주세요");
			model.addAttribute("path", "./registerSign");
			
			return "commons/result";
			
		}
		
		//원본 파일이름 꺼내기
		String oriName = stampFile.getOriginalFilename();
		//원본파일의 확장자만 자르기
		String extension = oriName.substring(oriName.lastIndexOf(".")).toLowerCase();
		
		//지정한 원본파일이 이미지파일(이미지파일의 확장자)가 아닐 시 실행 X
		if(!ALLOWED_EXTENSIONS.contains(extension)){
			model.addAttribute("result", "이미지 파일(.png, .jpg, .jpeg, .gif)만 업로드할 수 있습니다.");
			model.addAttribute("path", "./registerSign");
			
			return "commons/result";
		}
		
		UserSignatureVO userSignatureVO = new UserSignatureVO();
		
		//해당파일 HDD에 저장
		String fileName = fileManager.saveFile(path.concat("userSignature"), stampFile);
		
		//DB에 넣을 정보 담기
		userSignatureVO.setUsername(userVO.getUsername());
		userSignatureVO.setFileName(fileName);
		userSignatureVO.setOriName(oriName);
		userSignatureVO.setSignatureType("ST1");
		
		//DB에 INSERT
		int result = approvalService.addSign(userSignatureVO);
		
		if(result > 0) {
			// 로그/감사 기록용
			auditLogService.log(
			        userVO.getUsername(),
			        "ADD_SIGN",
			        "USER_SIGNATURE",
			        userSignatureVO.getSignatureId().toString(),
			        userVO.getUsername() + "이 도장 등록",
			        request
			    );
		}
		
		return "redirect:/user/mypage";
		
		
	}
	
	@GetMapping("deleteSign")
	public String deleteSign(@AuthenticationPrincipal UserVO userVO, Model model, HttpServletRequest request) throws Exception {
		//로그인한 유저의 서명/도장 정보 가져오기
		UserSignatureVO userSignatureVO = userService.getSign(userVO);
		//서명/도장이 없을 시 실행X
		if(userSignatureVO == null) {
			model.addAttribute("result", "삭제할 서명/도장이 없습니다.");
			model.addAttribute("path", "/user/mypage");
			return "commons/result";
		}
		//먼저 DB에서 지우고
		int result = approvalService.deleteSign(userVO);
		
		//DB에서 지워졌으면 HDD에서도 해당 파일 삭제
		if(result > 0) {
			fileManager.deleteFile(path.concat("userSignature"), userSignatureVO.getFileName());
			
			// 로그/감사 기록용
			auditLogService.log(
			        userVO.getUsername(),
			        "DELETE_SIGN",
			        "USER_SIGNATURE",
			        userSignatureVO.getSignatureId().toString(),
			        userVO.getUsername() + "이 서명/도장 삭제",
			        request
			    );
		}
		
		return "redirect:/user/mypage";
	}
	
	@PostMapping("appOrRej")
	@ResponseBody
	public int appOrRej(@AuthenticationPrincipal UserVO userVO, ApprovalVO approvalVO, DocumentVO documentVO, int type, HttpServletRequest request) throws Exception {		
		int result = 0;
		
		if(type == 1) {
			result = approvalService.approve(approvalVO, documentVO, userVO, request);
		}else {
			result = approvalService.rejection(approvalVO, documentVO, userVO, request);
		}
		
		
		return result;
	}
	
	@GetMapping("getSign")
	@ResponseBody
	public UserSignatureVO getSign(@AuthenticationPrincipal UserVO userVO) throws Exception {
		UserSignatureVO userSignatureVO = new UserSignatureVO();
		userSignatureVO = userService.getSign(userVO);
		
		return userSignatureVO;
	}
	
	@GetMapping("list")
	public String list(@AuthenticationPrincipal UserVO userVO, FormVO formVO, String search, Model model) throws Exception {
		ApprovalVO approvalVO = new ApprovalVO();
		approvalVO.setApproverId(userVO.getUsername());
		
		//양식별 카테고리 정보 DB로 넘기기용
		if(formVO.getFormId() != null) {
			approvalVO.setDocumentVO(new DocumentVO());
			approvalVO.getDocumentVO().setFormId(formVO.getFormId());
		}
		
		List<ApprovalVO> ar = approvalService.getList(approvalVO, search);
		model.addAttribute("ar", ar);
		
		//양식별로 결재문서 불러오기
		List<FormVO> forms = approvalService.getForms();
		model.addAttribute("forms", forms);
		
		//양식목록을 바꾸면 해당 목록으로 selected되있게 하기위함
		model.addAttribute("selectedFormId", formVO.getFormId());
		
		//양식목록을 바꾸면 해당 작성자로 검색되있게 하기위함
		model.addAttribute("writedId", search);
		
		return "approval/list";
	
	}
	
	@GetMapping("detail")
	public String detail(@AuthenticationPrincipal UserVO userVO, ApprovalVO approvalVO, Model model) throws Exception {
		
		
		approvalVO.setApproverId(userVO.getUsername());
		
		approvalVO = approvalService.getDetail(approvalVO);
		model.addAttribute("vo", approvalVO);
		
		return "approval/detail";
	}
			

}
