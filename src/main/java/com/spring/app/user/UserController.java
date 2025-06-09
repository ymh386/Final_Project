package com.spring.app.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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


import com.spring.app.approval.ApprovalService;
import com.spring.app.approval.DocumentVO;
import com.spring.app.approval.FormVO;
import com.spring.app.approval.UserSignatureVO;

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
	
	@Autowired
	private PasswordEncoder encoder;
	
	@Autowired
	private UserService userService;
	
	@Autowired

	private ApprovalService approvalService;

	private SubscriptService subscriptService;

	
	@Value("${board.file.path}")
	private String path;
	
	@GetMapping("join/join")
	void join() {}
	
	@GetMapping("join/memberJoin")
	void memberJoin() {}
	
	@GetMapping("mypage")
	void myPage(@AuthenticationPrincipal UserVO userVO, Model model) throws Exception {
		
		//로그인한 유저의 서명정보 담기
		UserSignatureVO userSignatureVO = new UserSignatureVO();
		userSignatureVO.setUsername(userVO.getUsername());
		
		userSignatureVO = userService.getSign(userSignatureVO);
		
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
	String memberJoin(UserVO userVO) throws Exception{
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
	String memberLogin(@AuthenticationPrincipal UserVO userVO) {
		if (userVO != null) {
			return "redirect:/";
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
	
	@GetMapping("getDocument")
	public String getDocument(DocumentVO documentVO, Model model) throws Exception {
		
		documentVO = userService.getDocument(documentVO);
		log.info("documentVO : {}", documentVO);
		
		model.addAttribute("vo", documentVO);
		
		return "user/document/detail";
		
	}
}
