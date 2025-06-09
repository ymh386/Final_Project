package com.spring.app.board.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.spring.app.home.util.Pager;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;

@Controller
@RequestMapping("/notice")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    // 1) 목록 (페이징)
    @GetMapping("/list")
    public String list(Pager pager, Model model) throws Exception {
        List<NoticeVO> list = noticeService.getList(pager);
        model.addAttribute("list", list);
        model.addAttribute("pager", pager);
        return "notice/list";
    }

    // 2) 상세 (조회수 증가)
    @GetMapping("/detail")
    public String detail(NoticeVO noticeVO, Model model) throws Exception {
        noticeService.hitUpdate(noticeVO);
        NoticeVO detail = noticeService.getDetail(noticeVO);
        model.addAttribute("detail", detail);
        return "notice/detail";
    }

    // 3) 등록 폼 (관리자만 접근)
    @GetMapping("/add")
    public String addForm(@AuthenticationPrincipal User user, Model model) throws Exception {
        boolean isAdmin = user != null && user.getAuthorities().stream()
                                .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));
        if (!isAdmin) {
            model.addAttribute("msg", "등록 권한이 없습니다. 관리자만 등록할 수 있습니다.");
            model.addAttribute("path", "/notice/list");
            return "common/result";
        }
        return "notice/add";
    }

    // 4) 등록 처리 (관리자만 가능)
    @PostMapping("/add")
    public String add(NoticeVO noticeVO,
                      @AuthenticationPrincipal User user,
                      Model model) throws Exception {
        boolean isAdmin = user != null && user.getAuthorities().stream()
                                .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));
        if (!isAdmin) {
            model.addAttribute("msg", "등록 권한이 없습니다. 관리자만 등록할 수 있습니다.");
            model.addAttribute("path", "/notice/list");
            return "common/result";
        }
        noticeVO.setUserName(user.getUsername());
        noticeService.add(noticeVO);
        return "redirect:/notice/list";
    }

    // 5) 수정 폼 (관리자만 접근)
    @GetMapping("/update")
    public String updateForm(NoticeVO noticeVO,
                             @AuthenticationPrincipal User user,
                             Model model) throws Exception {
        boolean isAdmin = user != null && user.getAuthorities().stream()
                                .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));
        if (!isAdmin) {
            model.addAttribute("msg", "수정 권한이 없습니다. 관리자만 수정할 수 있습니다.");
            model.addAttribute("path", "/notice/list");
            return "common/result";
        }
        model.addAttribute("detail", noticeService.getDetail(noticeVO));
        return "notice/update";
    }

    // 6) 수정 처리 (관리자만 가능)
    @PostMapping("/update")
    public String update(NoticeVO noticeVO,
                         @AuthenticationPrincipal User user,
                         Model model) throws Exception {
        boolean isAdmin = user != null && user.getAuthorities().stream()
                                .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));
        if (!isAdmin) {
            model.addAttribute("msg", "수정 권한이 없습니다. 관리자만 수정할 수 있습니다.");
            model.addAttribute("path", "/notice/list");
            return "common/result";
        }
        noticeService.update(noticeVO);
        return "redirect:/notice/detail?boardNum=" + noticeVO.getBoardNum();
    }

    // 7) 삭제 처리 (관리자만 가능)
    @PostMapping("/delete")
    public String delete(NoticeVO noticeVO,
                         @AuthenticationPrincipal User user,
                         Model model) throws Exception {
        boolean isAdmin = user != null && user.getAuthorities().stream()
                                .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));
        if (!isAdmin) {
            model.addAttribute("msg", "삭제 권한이 없습니다. 관리자만 삭제할 수 있습니다.");
            model.addAttribute("path", "/notice/list");
            return "common/result";
        }
        noticeService.delete(noticeVO);
        return "redirect:/notice/list";
    }
}
