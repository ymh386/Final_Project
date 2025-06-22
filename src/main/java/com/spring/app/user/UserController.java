package com.spring.app.user;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.app.approval.ApprovalService;
import com.spring.app.approval.DocumentVO;
import com.spring.app.approval.FormVO;
import com.spring.app.approval.UserSignatureVO;
import com.spring.app.files.FileManager;
import com.spring.app.payment.PaymentService;
import com.spring.app.subscript.SubscriptService;
import com.spring.app.subscript.SubscriptVO;


import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/user/*")
@Slf4j
public class UserController {
	
	private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".png", ".jpg", ".jpeg", ".gif");

    private final WebSecurityCustomizer custom;

    private final PaymentService paymentService;
	
	@Autowired
	private PasswordEncoder encoder;
	
	@Autowired
	private FileManager fileManager;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private FindInfoService findInfoService;
	
	@Autowired
	private ApprovalService approvalService;

	@Autowired
	private SubscriptService subscriptService;

	
	@Value("${board.file.path}")
	private String path;

    UserController(PaymentService paymentService, WebSecurityCustomizer custom) {
        this.paymentService = paymentService;
        this.custom = custom;
    }
	
	@GetMapping("join/join")
	void join() {}
	
	@GetMapping("join/memberJoin")
	void memberJoin() {}
	
	@GetMapping("mypage")
	void myPage(@AuthenticationPrincipal UserVO userVO, Model model) throws Exception {
		
		//로그인한 유저의 서명정보 담기
		UserSignatureVO userSignatureVO = userService.getSign(userVO);
		
		//서명이 없으면 프론트로 굳이 안보냄
		if(userSignatureVO != null) {
			model.addAttribute("userSignature", userSignatureVO);
		}
		
		if (userVO!=null) {
			String username = userVO.getUsername();
			List<SubscriptVO> list = subscriptService.getSubscriptByUser(username);
			model.addAttribute("list", list);
		}
	}
	
	@PostMapping("join/memberJoin")
	String memberJoin(UserVO userVO, MultipartFile img, Model model) throws Exception{
		
		String oriName = img.getOriginalFilename().toString();
		
		if (oriName!="") {
			String file = oriName.substring(oriName.lastIndexOf(".")).toLowerCase();			
			if(!ALLOWED_EXTENSIONS.contains(file)){
				model.addAttribute("result", "이미지 파일(.png, .jpg, .jpeg, .gif)만 업로드할 수 있습니다.");
				model.addAttribute("path", "./registerSign");
				
				return "commons/result";
			}
			System.out.println("oriName : "+oriName);
			
			//랜덤 문자열 가져오기
			String uuid = UUID.randomUUID().toString();
			//가져온 랜덤 문자열로 파일이름 만들기
			String fileName = uuid.concat(userVO.getUsername()).concat(".png");
			String file2=fileManager.saveFile(path.concat("user"), img);
			userVO.setFileName(file2);
			userVO.setOriName(oriName);
		}else {
			oriName="default.png";
			userVO.setFileName("default");
			userVO.setOriName(oriName);
		}
		
		
		
		int result = userService.join(userVO);
		
		return "redirect:/";
	}
	
	@GetMapping("join/trainerJoin")
	void trainerJoin(Model model) throws Exception {
		String trainerId = "T"+userService.getTrainerCode();
		model.addAttribute("code", trainerId);
	}
	
	@PostMapping("join/trainerJoin")
	String trainerJoin(UserVO userVO) throws Exception{
		Long code = userService.getTrainerCode();
		userVO.setTrainerCode(code);
		int result = userService.join(userVO);
		
		return "redirect:/";
	}
	
	@GetMapping("login/login")
	String memberLogin(@AuthenticationPrincipal UserVO userVO, @RequestParam(value = "error", required = false) String error, Model model) {
		if (userVO != null) {
			return "redirect:/";
		}
		if (error != null) {
			model.addAttribute("error", error);
		}
		
		return "user/login/login";
	}
	
	@GetMapping("login/trainerLogin")
	String trainerLogin(@AuthenticationPrincipal UserVO userVO, @RequestParam(value = "error", required = false) String error, Model model) {
		if (userVO != null) {
			return "redirect:/";
		}
		if (error != null) {
			model.addAttribute("error", error);
		}
		
		return "user/login/trainerLogin";
	}
	
	@GetMapping("findId")
	void findId() throws Exception{}
	
	@PostMapping("findId")
	String findId(@RequestParam("email") String input, UserVO userVO, Model model) throws Exception {
		
		String email = findInfoService.getEmail(input);
		userVO.setEmail(email);
		
		if (email!=null) {
			userVO=findInfoService.getUserByEmail(email);
			String username = userVO.getUsername();
			username=findInfoService.maskEmail(username, 3, 6);
			System.out.println(username);
			
			model.addAttribute("result", "아이디는 "+username+"입니다");
			model.addAttribute("path", "/user/login/login");
		}else {
			model.addAttribute("result", "입력한 정보로 가입된 회원이 존재하지 않습니다.");
			model.addAttribute("path", "/user/findId");
		}
		return "commons/result";
	}
	
	@GetMapping("findPwByEmail")
	void findPwByEmail() throws Exception{}
	
	@PostMapping("findPwByEmail")
	String findPwEmail(@RequestParam("email") String input, Model model, UserVO userVO) throws Exception{
		String email = findInfoService.getEmail(input);
		
		if (email!=null) {
			userVO = findInfoService.getUserByEmail(email);
			
			String newPassword=findInfoService.randomPassword(12);
			userVO.setPassword(encoder.encode(newPassword));
			findInfoService.changePw(userVO);
			findInfoService.findPwByEmail(email, newPassword);
			
			model.addAttribute("result", "입력하신 이메일로 임시 비밀번호를 발송했습니다.");
		}else {
			model.addAttribute("result", "입력한 정보로 가입된 회원이 존재하지 않습니다.");
		}
		
		List<MemberRoleVO> list = userService.getRole(userVO.getUsername());
		
		for(MemberRoleVO memberRoleVO : list) {
			if (memberRoleVO.equals("TRAINER")) {
				model.addAttribute("path", "/user/login/trainerLogin");
			}else {
				model.addAttribute("path", "/user/login/login");				
			}
		}
				
		return "commons/result";
	}
	
	@GetMapping("findPwByPhone")
	void findPwByPhone() throws Exception{}
	
	@PostMapping("findPwByPhone")
	String findPwByPhone(@RequestParam("phone") String input, Model model, UserVO userVO) throws Exception {
		
		String phone = findInfoService.getPhone(input);
		
		if (phone!=null) {
			userVO=findInfoService.getUserByPhone(phone);
			
			String newPassword=findInfoService.randomPassword(12);
			userVO.setPassword(encoder.encode(newPassword));
			findInfoService.changePw(userVO);
			
			findInfoService.findPwByPhone(phone, newPassword);
			
			model.addAttribute("result", "입력하신 전화번호로 임시 비밀번호를 발송했습니다.");			
		}else {
			model.addAttribute("result", "입력한 정보로 가입된 회원이 존재하지 않습니다.");
		}
		
		
		List<MemberRoleVO> list = userService.getRole(userVO.getUsername());
		
		for(MemberRoleVO memberRoleVO : list) {
			if (memberRoleVO.equals("TRAINER")) {
				model.addAttribute("path", "/user/login/trainerLogin");
			}else {
				model.addAttribute("path", "/user/login/login");				
			}
		}
		
		return "commons/result";
	}
	
	@GetMapping("logout")
	String logout(HttpSession session, HttpServletResponse response) throws Exception{
		session.invalidate();
		Cookie cookie = new Cookie("accessToken", "");
		cookie.setMaxAge(0);
		cookie.setPath("/");
		response.addCookie(cookie);
		
		return "redirect:/";
	}
	
	@GetMapping("update")
	String update(Model model, UserVO userVO) throws Exception {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		String username = auth.getName();
		
		userVO.setUsername(username);
		userVO=userService.detail(userVO);
		
		model.addAttribute("user", userVO);
		
		return "user/update";
	}
	
	@PostMapping("update")
	String update(@ModelAttribute UserVO updateUser) throws Exception {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		String username = auth.getName();
		UserVO userVO = new UserVO();
		
		userVO.setUsername(username);
		userVO = userService.detail(userVO);
		
		userVO.setName(updateUser.getName());
		userVO.setBirth(updateUser.getBirth());
		userVO.setEmail(updateUser.getEmail());
		userVO.setPassword(encoder.encode(updateUser.getPassword()));
		
		int result = userService.update(userVO);
		
		return "redirect:./mypage";
	}
	
	//로그인한 유저가 작성한 전자결재 목록
	@GetMapping("getDocuments")
	public String getDocuments(@AuthenticationPrincipal UserVO userVO, DocumentVO documentVO, Model model) throws Exception {
		//양식별로 결재문서 불러오기
		List<FormVO> forms = approvalService.getForms();
		
		//작성자에 로그인한 유저 ID넣기
		documentVO.setWriterId(userVO.getUsername());
		
		List<DocumentVO> ar = userService.getDocuments(documentVO);
		model.addAttribute("ar", ar);
		model.addAttribute("forms", forms);
		
		//양식목록을 바꾸면 해당 목록으로 selected되있게 하기위함
		model.addAttribute("selectedFormId", documentVO.getFormId());
		
		return "user/document/list";
	}
	
	//로그이한 유저가 작성한 전자결재의 한건 정보(디테일)
	@GetMapping("getDocument")
	public String getDocument(@AuthenticationPrincipal UserVO userVO, DocumentVO documentVO, Model model) throws Exception {
		documentVO.setWriterId(userVO.getUsername());
		
		documentVO = userService.getDocument(documentVO);
		log.info("documentVO : {}", documentVO);
		
		model.addAttribute("vo", documentVO);
		
		return "user/document/detail";
		
	}
	
	@GetMapping("department/list")
	public String getDepartments(Model model) throws Exception {
		List<DepartmentVO> ar = userService.getDepartments();
		model.addAttribute("ar", ar);
		
		return "user/department/list";
	}
	
	@GetMapping("department/add")
	public String addDepartment() throws Exception {
		return "user/department/add";
	}
	
	@PostMapping("department/add")
	public String addDepartment(DepartmentVO departmentVO) throws Exception {
		int result = userService.addDepartment(departmentVO);
		
		return "redirect:./list";
	}
	
	@GetMapping("department/update")
	public String updateDepartment(DepartmentVO departmentVO, Model model) throws Exception {
		departmentVO = userService.getDepartment(departmentVO);
		model.addAttribute("vo", departmentVO);
		
		return "user/department/update";
	}
	
	@PostMapping("department/update")
	public String updateDepartment(DepartmentVO departmentVO) throws Exception {
		int result = userService.updateDepartment(departmentVO);
		
		return "redirect:./list";
	}
	
	@GetMapping("department/delete")
	public String deleteDepartment(DepartmentVO departmentVO) throws Exception {
		int result = userService.deleteDepartment(departmentVO);
		
		return "redirect:./list";
	}
	
	//부서별 회원 관리
	@GetMapping("department/user")
	public String userByDepartment() throws Exception {
		return "user/department/user";
	}
	
	//부서가 있는/없는 회원들 정보 불러오기
	@GetMapping("department/getUsers")
	@ResponseBody
	public Map<String, Object> getUsers(@RequestParam(name="check") int check) throws Exception {
		Map<String, Object> map = new HashMap<>();
		List<UserVO> users = new ArrayList<>();
		
		List<DepartmentVO> departments = userService.getDepartments();
		map.put("departments", departments);
		
		if(check == 0) {
			users = userService.getUsersNoDepartment();
		}else {
			users = userService.getUsersWithDepartment();
		}
		
		map.put("users", users);
		
		return map;
		
	}
	
	//해당 회원의 부서정보 변경
	@PostMapping("department/updateUser")
	@ResponseBody
	public int updateUser(UserVO userVO, DepartmentVO departmentVO) throws Exception {
		int result = userService.updateDeptByUser(userVO, departmentVO);
		return result;
	}
	
	//부서장 임명
	@PostMapping("department/updateHead")
	@ResponseBody
	public int updateHead(UserVO userVO, DepartmentVO departmentVO) throws Exception {
		int result = userService.updateHeadOfDept(userVO, departmentVO);
		return result;
	}
}