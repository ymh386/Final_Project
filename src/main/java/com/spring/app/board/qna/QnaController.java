package com.spring.app.board.qna;

import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.spring.app.security.jwt.JwtTokenManager;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/qna")
public class QnaController {

    private final QnaService qnaService;
    private final JwtTokenManager jwtTokenManager;

    // 인증이 필요한 경우에만 사용
    private String extractToken(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            return header.substring(7);
        }
        return null;
    }

    // 1. 전체 목록 (누구나 접근)
    @GetMapping("/list")
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model
    ) throws Exception {
        Map<String, Object> data = qnaService.getList(page, size);
        model.addAttribute("total", data.get("total"));
        model.addAttribute("list", data.get("list"));
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "qna/list";
    }

    // 2. 글 상세보기 (비밀글만 접근 제한)
    @GetMapping("/view/{boardNum}")
    public String view(
            @PathVariable Long boardNum,
            Model model,
            HttpServletRequest request
    ) throws Exception {
        QnaVO vo = qnaService.getById(boardNum);

        // 비밀글이면
        if (vo.getIsSecret() != null && vo.getIsSecret() == 1) {
            String rawToken = extractToken(request);
            if (rawToken == null) {
                model.addAttribute("errorMsg", "비밀글입니다. 로그인 후 확인하세요.");
                return "qna/error";
            }
            var claims = jwtTokenManager.validateToken(rawToken);
            String username = claims.getSubject();
            boolean isAdmin = claims.get("roles", String.class)
                    .contains("ROLE_ADMIN");

            if (!username.equals(vo.getUserName()) && !isAdmin) {
                model.addAttribute("errorMsg", "비밀글입니다. 권한이 없습니다.");
                return "qna/error";
            }
        }
        model.addAttribute("qna", vo);
        return "qna/detail";
    }

    // 3. 글쓰기 폼 (인증 필요)
    @GetMapping("/add")
    public String writeForm(HttpServletRequest request, Model model) {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login"; // 로그인 페이지로
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login";
        }
        model.addAttribute("username", username);
        return "qna/add";
    }

    // 4. 글쓰기 처리 (인증 필요)
    @PostMapping("/write")
    public String write(
            @ModelAttribute QnaVO vo,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login";
        }
        vo.setUserName(username);
        if (vo.getIsSecret() == null) {
            vo.setIsSecret(0);
        }
        qnaService.write(vo);
        return "redirect:/qna/list";
    }

    // 5. 답글 폼 (인증 필요)
    @GetMapping("/reply")
    public String replyForm(
            @RequestParam Long ref,
            @RequestParam Long step,
            @RequestParam Long depth,
            Model model,
            HttpServletRequest request
    ) {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login";
        }
        QnaVO parent = new QnaVO();
        parent.setBoardRef(ref);
        parent.setBoardStep(step);
        parent.setBoardDepth(depth);
        model.addAttribute("parent", parent);
        return "qna/reply";
    }

    // 6. 답글 처리 (인증 필요)
    @PostMapping("/reply")
    public String reply(
            @ModelAttribute QnaVO vo,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login";
        }
        vo.setUserName(username);
        if (vo.getIsSecret() == null) {
            vo.setIsSecret(0);
        }
        qnaService.reply(vo);
        return "redirect:/qna/list";
    }

    // 7. 수정 폼 (인증 필요, 본인/관리자만)
    @GetMapping("/update/{boardNum}")
    public String updateForm(
            @PathVariable Long boardNum,
            Model model,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        boolean isAdmin = claims.get("roles", String.class)
                .contains("ROLE_ADMIN");

        QnaVO vo = qnaService.getById(boardNum);
        if (!username.equals(vo.getUserName()) && !isAdmin) {
            model.addAttribute("errorMsg", "수정 권한이 없습니다.");
            return "qna/error";
        }
        model.addAttribute("qna", vo);
        return "qna/update";
    }

    // 8. 수정 처리
    @PostMapping("/update")
    public String update(
            @ModelAttribute QnaVO vo,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        boolean isAdmin = claims.get("roles", String.class)
                .contains("ROLE_ADMIN");

        QnaVO existing = qnaService.getById(vo.getBoardNum());
        if (!username.equals(existing.getUserName()) && !isAdmin) {
            request.setAttribute("errorMsg", "수정 권한이 없습니다.");
            return "qna/error";
        }
        if (vo.getIsSecret() == null) {
            vo.setIsSecret(0);
        }
        vo.setUserName(username);
        vo.setBoardRef(existing.getBoardRef());
        vo.setBoardStep(existing.getBoardStep());
        vo.setBoardDepth(existing.getBoardDepth());
        qnaService.modify(vo);
        return "redirect:/qna/view/" + vo.getBoardNum();
    }

    // 9. 삭제 처리 (인증 필요, 본인/관리자만)
    @PostMapping("/delete/{boardNum}")
    public String delete(
            @PathVariable Long boardNum,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        boolean isAdmin = claims.get("roles", String.class)
                .contains("ROLE_ADMIN");

        QnaVO existing = qnaService.getById(boardNum);
        if (!username.equals(existing.getUserName()) && !isAdmin) {
            request.setAttribute("errorMsg", "삭제 권한이 없습니다.");
            return "qna/error";
        }
        qnaService.remove(boardNum);
        return "redirect:/qna/list";
    }
}
