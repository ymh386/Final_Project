package com.spring.app.board.qna;

import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/qna")
public class QnaController {

    private final QnaService qnaService;

    // 1. 전체 목록 (최신글 위, 답글은 부모글 아래 순서)
    @GetMapping("/list")
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal UserDetails userDetails,
            Model model
    ) throws Exception {
        Map<String, Object> data = qnaService.getList(page, size);
        model.addAttribute("total", data.get("total"));
        model.addAttribute("list", data.get("list"));
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);

        boolean isAdmin = false;
        if (userDetails != null) {
            isAdmin = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        }
        model.addAttribute("isAdmin", isAdmin);

        return "qna/list";
    }

    // 2. 글 상세보기 (비밀글 권한 체크 및 비밀번호 검증)
    @GetMapping("/detail/{boardNum}")
    public String view(
            @PathVariable Long boardNum,
            Model model,
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(value = "secretPassword", required = false) String secretPassword
    ) throws Exception {
        QnaVO vo = qnaService.getById(boardNum);

        if (vo == null) {
            model.addAttribute("errorMsg", "존재하지 않는 글입니다.");
            return "qna/error";
        }

        if (vo.getIsSecret() != null && Boolean.TRUE.equals(vo.getIsSecret())) {
            if (userDetails == null) {
                model.addAttribute("errorMsg", "비밀글입니다. 로그인 후 확인하세요.");
                return "qna/error";
            }
            String username = userDetails.getUsername();
            boolean isAdmin = userDetails.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

            if (!username.equals(vo.getUserName()) && !isAdmin) {
                if (secretPassword == null || !secretPassword.equals(vo.getSecretPassword())) {
                    model.addAttribute("errorMsg", "비밀글입니다. 비밀번호가 틀렸거나 권한이 없습니다.");
                    return "qna/error";
                }
            }
        }

        model.addAttribute("qna", vo);

        boolean isAdmin = false;
        String username = null;
        if (userDetails != null) {
            isAdmin = userDetails.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
            username = userDetails.getUsername();
        }
        model.addAttribute("isAdmin", isAdmin);
        model.addAttribute("username", username);

        return "qna/detail";
    }

    // 3. 글쓰기 폼 (로그인한 회원만)
    @GetMapping("/add")
    public String addForm(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        if (userDetails == null) {
            return "redirect:/users/login";
        }
        model.addAttribute("username", userDetails.getUsername());
        return "qna/add";
    }

    // 4. 글쓰기 처리
    @PostMapping("/add")
    public String add(
            @ModelAttribute QnaVO vo,
            @AuthenticationPrincipal UserDetails userDetails
    ) throws Exception {
        if (userDetails == null) {
            return "redirect:/users/login";
        }
        vo.setUserName(userDetails.getUsername());

        if (vo.getIsSecret() == null) {
            vo.setIsSecret(false);
            vo.setSecretPassword(null);
        } else if (Boolean.TRUE.equals(vo.getIsSecret())) {
            if (vo.getSecretPassword() == null || vo.getSecretPassword().isBlank()) {
                throw new RuntimeException("비밀글일 경우 비밀번호를 입력하세요.");
            }
        }

        // 새 글인 경우 boardRef = boardNum (신규 등록 후 세팅)
        qnaService.write(vo);

        return "redirect:/qna/list";
    }

    // 5. 답글 폼 (로그인한 회원만)
    @GetMapping("/reply")
    public String replyForm(
            @RequestParam Long ref,
            @RequestParam Long step,
            @RequestParam Long depth,
            Model model,
            @AuthenticationPrincipal UserDetails userDetails
    ) {
        if (userDetails == null) {
            return "redirect:/users/login";
        }
        // 부모글 정보 세팅
        QnaVO parent = new QnaVO();
        parent.setBoardRef(ref);
        parent.setBoardStep(step);
        parent.setBoardDepth(depth);
        model.addAttribute("parent", parent);
        model.addAttribute("username", userDetails.getUsername());
        return "qna/reply";
    }

    // 6. 답글 등록 (관리자만 가능)
    @PostMapping("/reply")
    public String reply(@ModelAttribute QnaVO vo, @AuthenticationPrincipal UserDetails userDetails) throws Exception {
        if (userDetails == null) {
            return "redirect:/users/login";
        }
        boolean isAdmin = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        if (!isAdmin) {
            throw new RuntimeException("답글 작성 권한이 없습니다.");
        }

        vo.setUserName(userDetails.getUsername());

        // 부모 글 조회 및 유효성 검사
        if (vo.getBoardRef() == null || vo.getBoardRef() <= 0) {
            throw new RuntimeException("부모 글 번호(boardRef)가 올바르지 않습니다.");
        }

        QnaVO parent = qnaService.getById(vo.getBoardRef());
        if (parent == null) {
            throw new RuntimeException("부모 게시글을 찾을 수 없습니다.");
        }

        // 부모 글 비밀글 여부에 따라 답글 비밀글 설정
        if (Boolean.TRUE.equals(parent.getIsSecret())) {
            vo.setIsSecret(true);
        } else {
            if (vo.getIsSecret() == null) {
                vo.setIsSecret(false);
            }
        }

        // 비밀글 비밀번호 체크
        if (Boolean.TRUE.equals(vo.getIsSecret())) {
            if (vo.getSecretPassword() == null || vo.getSecretPassword().isBlank()) {
                throw new RuntimeException("비밀글일 경우 비밀번호를 입력하세요.");
            }
        } else {
            vo.setSecretPassword(null);
        }

        // 답글 제목 처리
        if (vo.getBoardTitle() == null || vo.getBoardTitle().isBlank()) {
            vo.setBoardTitle("[답글] " + parent.getBoardTitle());
        }

        // 답글 순서 밀기
        qnaService.updateStepForReply(parent.getBoardRef(), parent.getBoardStep());

        // 답글 정보 설정
        vo.setBoardRef(parent.getBoardRef());
        vo.setBoardStep(parent.getBoardStep() + 1);
        vo.setBoardDepth(parent.getBoardDepth() + 1);

        // 답글 등록
        qnaService.reply(vo);

        // 리스트로 리다이렉트
        return "redirect:/qna/list";
    }

    // 7. 수정 폼 (본인 또는 관리자만)
    @GetMapping("/update/{boardNum}")
    public String updateForm(
            @PathVariable Long boardNum,
            Model model,
            @AuthenticationPrincipal UserDetails userDetails
    ) throws Exception {
        if (userDetails == null) {
            return "redirect:/users/login";
        }
        String username = userDetails.getUsername();
        boolean isAdmin = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

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
            @AuthenticationPrincipal UserDetails userDetails
    ) throws Exception {
        if (userDetails == null) {
            return "redirect:/users/login";
        }
        String username = userDetails.getUsername();
        boolean isAdmin = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        QnaVO existing = qnaService.getById(vo.getBoardNum());
        if (!username.equals(existing.getUserName()) && !isAdmin) {
            throw new RuntimeException("수정 권한이 없습니다.");
        }

        if (vo.getIsSecret() == null) {
            vo.setIsSecret(false);
            vo.setSecretPassword(null);
        } else if (Boolean.TRUE.equals(vo.getIsSecret())) {
            if (vo.getSecretPassword() == null || vo.getSecretPassword().isBlank()) {
                throw new RuntimeException("비밀글일 경우 비밀번호를 입력하세요.");
            }
        }

        vo.setUserName(username);
        vo.setBoardRef(existing.getBoardRef());
        vo.setBoardStep(existing.getBoardStep());
        vo.setBoardDepth(existing.getBoardDepth());

        qnaService.update(vo);
        
        return "redirect:/qna/detail/" + vo.getBoardNum();
    }

    // 9. 삭제 처리
    @PostMapping("/delete/{boardNum}")
    public String delete(
            @PathVariable Long boardNum,
            @AuthenticationPrincipal UserDetails userDetails
    ) throws Exception {
        if (userDetails == null) {
            return "redirect:/users/login";
        }
        String username = userDetails.getUsername();
        boolean isAdmin = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        QnaVO existing = qnaService.getById(boardNum);
        if (!username.equals(existing.getUserName()) && !isAdmin) {
            throw new RuntimeException("삭제 권한이 없습니다.");
        }

        qnaService.delete(boardNum);
        return "redirect:/qna/list";
    }
}
