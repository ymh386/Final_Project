package com.spring.app.board.qna;

import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;  // Spring Boot 3.x 이후
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.spring.app.security.jwt.JwtTokenManager;  // JwtTokenManager 를 import

import lombok.RequiredArgsConstructor;

/**
 * QnaController (Token 기반 인증: JwtTokenManager)
 *
 * - 클라이언트는 모든 인증이 필요한 요청에 HTTP 헤더 “Authorization: Bearer <token>”을 포함해야 합니다.
 * - JwtTokenManager를 통해 토큰을 검증하고, username과 권한을 추출하여 권한을 확인합니다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping("/qna")
public class QnaController {

    private final QnaService qnaService;
    private final JwtTokenManager jwtTokenManager;

    /**
     * Authorization 헤더에서 토큰 문자열만 추출
     */
    private String extractToken(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            return header.substring(7);
        }
        return null;
    }

    /** 1) 목록 페이지 (페이지, 사이즈 파라미터) */
    @GetMapping("/list")
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login.jsp";
        }
        // 토큰 검증 및 클레임 획득
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login.jsp";
        }

        Map<String, Object> data = qnaService.getList(page, size);
        model.addAttribute("total", data.get("total"));
        model.addAttribute("list", data.get("list"));
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "qna/list";  // /WEB-INF/views/qna/list.jsp
    }

    /** 2) 원글 작성 폼 */
    @GetMapping("/write")
    public String writeForm(HttpServletRequest request) {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login.jsp";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login.jsp";
        }
        return "qna/write";  // /WEB-INF/views/qna/write.jsp
    }

    /** 3) 원글 작성 처리 */
    @PostMapping("/write")
    public String write(
            @ModelAttribute QnaVO vo,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login.jsp";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login.jsp";
        }

        vo.setUserName(username);
        if (vo.getIsSecret() == null) {
            vo.setIsSecret(0);
        }
        qnaService.write(vo);
        return "redirect:/qna/list";
    }

    /** 4) 답글 작성 폼 (원글 ref, step, depth를 쿼리스트링으로 전달) */
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
            return "redirect:/users/login.jsp";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login.jsp";
        }

        QnaVO parent = new QnaVO();
        parent.setBoardRef(ref);
        parent.setBoardStep(step);
        parent.setBoardDepth(depth);
        model.addAttribute("parent", parent);
        return "qna/reply";  // /WEB-INF/views/qna/reply.jsp
    }

    /** 5) 답글 작성 처리 */
    @PostMapping("/reply")
    public String reply(
            @ModelAttribute QnaVO vo,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login.jsp";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login.jsp";
        }

        vo.setUserName(username);
        if (vo.getIsSecret() == null) {
            vo.setIsSecret(0);
        }
        qnaService.reply(vo);
        return "redirect:/qna/list";
    }

    /** 6) 상세 조회 */
    @GetMapping("/view/{boardNum}")
    public String view(
            @PathVariable Long boardNum,
            Model model,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login.jsp";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login.jsp";
        }
        // 관리자 여부: "roles" 클레임에서 ROLE_ADMIN 포함 여부 확인
        boolean isAdmin = claims.get("roles", String.class)
                           .contains("ROLE_ADMIN");

        QnaVO vo = qnaService.getById(boardNum);
        if (vo.getIsSecret() != null && vo.getIsSecret() == 1) {
            if (!username.equals(vo.getUserName()) && !isAdmin) {
                model.addAttribute("errorMsg", "이 글은 비밀글입니다. 권한이 없습니다.");
                return "qna/error";  // /WEB-INF/views/qna/error.jsp
            }
        }
        model.addAttribute("qna", vo);
        return "qna/view";  // /WEB-INF/views/qna/view.jsp
    }

    /** 7) 수정 폼 (“update” 경로) */
    @GetMapping("/update/{boardNum}")
    public String updateForm(
            @PathVariable Long boardNum,
            Model model,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login.jsp";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login.jsp";
        }
        boolean isAdmin = claims.get("roles", String.class)
                           .contains("ROLE_ADMIN");

        QnaVO vo = qnaService.getById(boardNum);
        if (!username.equals(vo.getUserName()) && !isAdmin) {
            model.addAttribute("errorMsg", "수정 권한이 없습니다.");
            return "qna/error";
        }
        model.addAttribute("qna", vo);
        return "qna/update";  // /WEB-INF/views/qna/update.jsp
    }

    /** 8) 수정 처리 (“update” 경로) */
    @PostMapping("/update")
    public String update(
            @ModelAttribute QnaVO vo,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login.jsp";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login.jsp";
        }
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

    /** 9) 삭제 처리 */
    @PostMapping("/delete/{boardNum}")
    public String delete(
            @PathVariable Long boardNum,
            HttpServletRequest request
    ) throws Exception {
        String rawToken = extractToken(request);
        if (rawToken == null) {
            return "redirect:/users/login.jsp";
        }
        var claims = jwtTokenManager.validateToken(rawToken);
        String username = claims.getSubject();
        if (username == null) {
            return "redirect:/users/login.jsp";
        }
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
