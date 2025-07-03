package com.spring.app.user;

import java.time.Duration;
import java.time.LocalDate;
import java.time.ZoneId;
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
import com.spring.app.attendance.AttendanceScheduler;
import com.spring.app.files.FileManager;
import com.spring.app.home.util.Pager;
import com.spring.app.auditLog.AuditLogService;
import com.spring.app.chart.AttendanceStatVO;
import com.spring.app.chart.ChartService;
import com.spring.app.chart.LeaveStatVO;
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

    private final AttendanceScheduler attendanceScheduler;
	
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
	
	@Autowired
	private AuditLogService auditLogService;
	
	@Autowired
	private ChartService chartService;

	
	@Value("${board.file.path}")
	private String path;

    UserController(PaymentService paymentService, WebSecurityCustomizer custom, AttendanceScheduler attendanceScheduler) {
        this.paymentService = paymentService;
        this.custom = custom;
        this.attendanceScheduler = attendanceScheduler;
    }
	
	@GetMapping("join/join")
	void join() {}
	
	@GetMapping("join/memberJoin")
	void memberJoin() {}
	
	@GetMapping("mypage")
	void myPage(@AuthenticationPrincipal UserVO userVO, @RequestParam(required = false) Integer year, Model model) throws Exception {
		
		////로그인한 유저의 근태율 차트
		// 현재 연도 기준으로 yearList 생성
	    Integer currentYear = LocalDate.now(ZoneId.of("Asia/Seoul")).getYear();
	    List<Integer> yearList = new ArrayList<>();
	    for (int y = 2020; y <= currentYear; y++) {
	        yearList.add(y);
	    }
	    
	    if (year == null) {
	        // 기본 연도 설정(현재년도)
	        year = currentYear;
		}
    	
	    //현재년도로 설정용
		model.addAttribute("year", year);
		//연도별 필터링 시 필요한 정보들
		model.addAttribute("yearList", yearList);
	    
	    List<AttendanceStatVO> attendanceStats = chartService.getMonthlyStats(year, userVO.getUsername());
	    //근태율 통계를 차트화 할때 필요한 정보들
	    model.addAttribute("attendanceStats", attendanceStats);
	    //휴가율 통계 차트화
	    List<LeaveStatVO> leaveStats = chartService.getUsedLeaveByType(year, userVO.getUsername());
	    model.addAttribute("leaveStats", leaveStats);
		
		
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
	String memberJoin(UserVO userVO, MultipartFile img, Model model, HttpServletRequest request) throws Exception{
		
		String oriName = img.getOriginalFilename().toString();
		
		if (oriName!="") {
			String file = oriName.substring(oriName.lastIndexOf(".")).toLowerCase();			
			if(!ALLOWED_EXTENSIONS.contains(file)){
				model.addAttribute("result", "이미지 파일(.png, .jpg, .jpeg, .gif)만 업로드할 수 있습니다.");
				model.addAttribute("path", "./registerSign");
				
				return "commons/result";
			}
			
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
				
		// 로그/감사 기록용
		auditLogService.log(
		        userVO.getUsername(),
		        "CREATE_MEMBER_USER",
		        "USER",
		        userVO.getUsername(),
		        "일반회원 회원가입",
		        request
		    );
		
		return "redirect:/";

	}
		
		
		
	
	@GetMapping("join/trainerJoin")
	void trainerJoin(Model model) throws Exception {
		String trainerId = "T"+userService.getTrainerCode();
		model.addAttribute("code", trainerId);
	}
	
	@PostMapping("join/trainerJoin")
	String trainerJoin(UserVO userVO, HttpServletRequest request, MultipartFile img, Model model) throws Exception{
		Long code = userService.getTrainerCode();
		userVO.setTrainerCode(code);
		
		String oriName = img.getOriginalFilename().toString();
		
		if (oriName!="") {
			String file = oriName.substring(oriName.lastIndexOf(".")).toLowerCase();			
			if(!ALLOWED_EXTENSIONS.contains(file)){
				model.addAttribute("result", "이미지 파일(.png, .jpg, .jpeg, .gif)만 업로드할 수 있습니다.");
				model.addAttribute("path", "./registerSign");
				
				return "commons/result";
			}
			
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
		
		// 로그/감사 기록용
		auditLogService.log(
		        userVO.getUsername(),
		        "CREATE_TRAINER_USER",
		        "USER",
		        userVO.getUsername(),
		        "트레이너 회원가입",
		        request
		    );
		
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
	String findId(@RequestParam("email") String input, UserVO userVO, Model model, HttpServletRequest request) throws Exception {
		
		String email = findInfoService.getEmail(input);
		userVO.setEmail(email);
		
		if (email!=null) {
			userVO=findInfoService.getUserByEmail(email);
			String username = userVO.getUsername();
			username=findInfoService.maskEmail(username, 3, 6);
			
			model.addAttribute("result", "아이디는 "+username+"입니다");
			model.addAttribute("path", "/user/login/login");
			
			// 로그/감사 기록용
			auditLogService.log(
			        userVO.getUsername(),
			        "FIND_ID",
			        "USER",
			        userVO.getUsername(),
			        userVO.getUsername().concat("이 아이디찾기 시도 - 성공"),
			        request
			    );
			return "commons/result";
		}else {
			model.addAttribute("result", "입력한 정보로 가입된 회원이 존재하지 않습니다.");
			model.addAttribute("path", "/user/findId");
			
			// 로그/감사 기록용
			auditLogService.log(
			        null,
			        "FIND_ID",
			        "USER",
			        "anonymous",
			        "anonymous이 아이디찾기 시도 - 실패",
			        request
			    );
			return "commons/result";
		}
	}
	
	@GetMapping("findPwByEmail")
	void findPwByEmail() throws Exception{}
	
	@PostMapping("findPwByEmail")
	String findPwEmail(@RequestParam("email") String input, Model model, UserVO userVO, HttpServletRequest request) throws Exception{
		String email = findInfoService.getEmail(input);
		
		if (email!=null) {
			userVO = findInfoService.getUserByEmail(email);
			
			String newPassword=findInfoService.randomPassword(12);
			userVO.setPassword(encoder.encode(newPassword));
			findInfoService.changePw(userVO);
			findInfoService.findPwByEmail(email, newPassword);
			
			model.addAttribute("result", "입력하신 이메일로 임시 비밀번호를 발송했습니다.");
			// 로그/감사 기록용
			auditLogService.log(
			        userVO.getUsername(),
			        "FIND_PW_EMAIL",
			        "USER",
			        userVO.getUsername(),
			        userVO.getUsername().concat("이 비밀번호 찾기 시도(이메일) - 성공"),
			        request
			    );
			return "commons/result";
		}else {
			model.addAttribute("result", "입력한 정보로 가입된 회원이 존재하지 않습니다.");
			// 로그/감사 기록용
			auditLogService.log(
			        null,
			        "FIND_PW_EMAIL",
			        "USER",
			        "anonymous",
			        "anonymous이 비밀번호 찾기 시도(이메일) - 성공",
			        request
			    );
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
	String findPwByPhone(@RequestParam("phone") String phone, Model model, HttpServletRequest request) throws Exception {
		
		List<UserVO> list = findInfoService.getUserListByPhone(phone);
		
		if (list.isEmpty()) {
			model.addAttribute("result", "입력한 정보로 가입된 회원이 존재하지 않습니다.");
			model.addAttribute("path", "/user/findId");
			
			auditLogService.log(
			        null,
			        "FIND_PW_PHONE",
			        "USER",
			        "anonymous",
			        "anonymous이 비밀번호 찾기 시도(폰번호) - 성공",
			        request
			    );
			
			return "commons/result";
		} else if (list.size()==1) {
			
			model.addAttribute("username", list.get(0));
			return "/user/findPwForm";
		}else {
			
			model.addAttribute("users", list);
			model.addAttribute("phone", phone);
			
			return "/user/chooseId";
		}
	}
	
	@PostMapping("findPw")
	String findPw(@RequestParam("phone") String input, @RequestParam("username") String username, Model model, UserVO userVO, HttpServletRequest request) throws Exception {
		
			System.out.println("휴대번호 : "+input);
			
			System.out.println("이름 : "+username);
			
			userVO = findInfoService.getUserByPhoneAndId(username, input);

			String newPassword=findInfoService.randomPassword(12);
			userVO.setPassword(encoder.encode(newPassword));
			findInfoService.changePw(userVO);
			
			System.out.println(input);
			
			findInfoService.findPwByPhone(input, newPassword);
			
			model.addAttribute("result", "입력하신 전화번호로 임시 비밀번호를 발송했습니다.");	
			
			// 로그/감사 기록용
			auditLogService.log(
			        userVO.getUsername(),
			        "FIND_PW_PHONE",
			        "USER",
			        userVO.getUsername(),
			        userVO.getUsername().concat("이 비밀번호 찾기 시도(폰번호) - 성공"),
			        request
			    );
		
			// 로그/감사 기록용
			auditLogService.log(
			        null,
			        "FIND_PW_PHONE",
			        "USER",
			        "anonymous",
			        "anonymous이 비밀번호 찾기 시도(폰번호) - 성공",
			        request
			    );
		
		
		
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
	String update(Model model, UserVO userVO, HttpServletRequest request) throws Exception {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		String username = auth.getName();
		
		userVO.setUsername(username);
		userVO=userService.detail(userVO);
		
		model.addAttribute("user", userVO);
		
		// 로그/감사 기록용
		auditLogService.log(
		        userVO.getUsername(),
		        "UPDATE_USER",
		        "USER",
		        userVO.getUsername(),
		        userVO.getUsername().concat("이 회원정보 수정"),
		        request
		    );
		
		return "user/update";
	}
	
	@PostMapping("update")
	String update(@ModelAttribute UserVO updateUser, HttpServletRequest request) throws Exception {
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
		
		// 로그/감사 기록용
		auditLogService.log(
		        userVO.getUsername(),
		        "UPDATE_USER",
		        "USER",
		        userVO.getUsername(),
		        userVO.getUsername().concat("이 유저정보 수정"),
		        request
		    );

		return "redirect:./mypage";
	}
	
	//로그인한 유저가 작성한 전자결재 목록
	@GetMapping("getDocuments")
	public String getDocuments(@AuthenticationPrincipal UserVO userVO, DocumentVO documentVO, Pager pager, Model model) throws Exception {
		
		//작성자에 로그인한 유저 ID넣기
		documentVO.setWriterId(userVO.getUsername());
		
		List<DocumentVO> ar = userService.getDocuments(documentVO, pager);
		model.addAttribute("ar", ar);
		model.addAttribute("pager", pager);
		model.addAttribute("documentStatus", documentVO.getDocumentStatus());
		
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
	
	//회원 탈퇴
	@PostMapping("deleteUser")
	@ResponseBody
	public int deleteUser(@AuthenticationPrincipal UserVO userVO, HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {
		int result = userService.deleteUser(userVO);
		
		session.invalidate();
		Cookie cookie = new Cookie("accessToken", "/");
		cookie.setMaxAge(0);
		cookie.setPath("/");
		response.addCookie(cookie);
		
		if(result > 0) {
			// 로그/감사 기록용
			auditLogService.log(
			        null,
			        "DELETE_USER",
			        "USER",
			        userVO.getUsername(),
			        userVO.getUsername().concat("이 회원 탈퇴"),
			        request
			    );
		}
		
		
		return result;
	}

	//비밀번호 일치하는지 확인
	@PostMapping("checkPassword")
	@ResponseBody
	public boolean checkPassword(@AuthenticationPrincipal UserVO userVO, String password) throws Exception {
		
		if (userVO.getSns()==null) {
			return encoder.matches(password, userService.getPasswordByUsername(userVO));			
		}else {
			if (password.equals("탈퇴 시 모든 정보는 삭제되며 복구되지 않습니다.")) {
				
				return true;
			} else {
				
				return false;
			}
		}
		
		
	}
}