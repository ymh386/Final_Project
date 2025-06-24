package com.spring.app.board.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.spring.app.board.BoardService;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.home.util.Pager;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import com.spring.app.user.UserVO;

@Controller
@RequestMapping("/notice")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    @Autowired
    private BoardService boardService;

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
    public String detail(@RequestParam("boardNum") Long boardNum, Model model) throws Exception {
        NoticeVO noticeVO = new NoticeVO();
        noticeVO.setBoardNum(boardNum);

        noticeService.hitUpdate(noticeVO);  // 조회수 증가
        NoticeVO detail = noticeService.getDetail(noticeVO);
        model.addAttribute("detail", detail);
        return "notice/detail";
    }

    // 3) 등록 폼 (관리자만 접근)
    @GetMapping("/add")
    public String addForm(@AuthenticationPrincipal UserVO user, Model model) throws Exception {
        if (!isAdmin(user)) {
            model.addAttribute("msg", "등록 권한이 없습니다. 관리자만 등록할 수 있습니다.");
            model.addAttribute("path", "/notice/list");
            return "commons/result";
        }
        return "notice/add";
    }

    // 4) 등록 처리
    @PostMapping("/add")
    public String add(NoticeVO noticeVO,
                      @AuthenticationPrincipal UserVO user,
                      Model model) throws Exception {
        if (!isAdmin(user)) {
            model.addAttribute("msg", "등록 권한이 없습니다. 관리자만 등록할 수 있습니다.");
            model.addAttribute("path", "/notice/list");
            return "commons/result";
        }
        noticeVO.setUserName(user.getUsername());
        noticeService.add(noticeVO);
        return "redirect:/notice/list";
    }

    // 5) 수정 폼 (GET) - 관리자만 접근
    @GetMapping("/update")
    public String updateForm(@RequestParam("boardNum") Long boardNum,
                             @AuthenticationPrincipal UserVO user,
                             Model model) throws Exception {
        if (!isAdmin(user)) {
            model.addAttribute("msg", "수정 권한이 없습니다. 관리자만 수정할 수 있습니다.");
            model.addAttribute("path", "/notice/list");
            return "commons/result";
        }
        NoticeVO vo = new NoticeVO();
        vo.setBoardNum(boardNum);
        NoticeVO detail = noticeService.getDetail(vo);
        model.addAttribute("notice", detail);
        return "notice/update";
    }

    // 6) 수정 처리 (POST) - 관리자만 접근
    @PostMapping("/update")
    public String update(NoticeVO noticeVO,
                         @AuthenticationPrincipal UserVO user,
                         Model model) throws Exception {
        if (!isAdmin(user)) {
            model.addAttribute("msg", "수정 권한이 없습니다. 관리자만 수정할 수 있습니다.");
            model.addAttribute("path", "/notice/list");
            return "commons/result";
        }
        noticeService.update(noticeVO);
        return "redirect:/notice/detail?boardNum=" + noticeVO.getBoardNum();
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("boardNum") Long boardNum,
                         @AuthenticationPrincipal UserVO user,
                         Model model) throws Exception {
        if (!isAdmin(user)) {
            model.addAttribute("msg", "삭제 권한이 없습니다. 관리자만 삭제할 수 있습니다.");
            model.addAttribute("path", "/notice/list");
            return "commons/result";
        }

        NoticeVO vo = new NoticeVO();
        vo.setBoardNum(boardNum);
        vo.setUserName(user.getUsername());

        int deletedCount = noticeService.delete(vo);  // 반환값으로 삭제 성공 여부 받아오기

        if (deletedCount == 0) {
            model.addAttribute("msg", "삭제할 공지사항을 찾을 수 없거나 삭제 권한이 없습니다.");
            model.addAttribute("path", "/notice/list");
            return "commons/result";
        }

        return "redirect:/notice/list";
    }

    // 8) 좋아요 등 인터랙션 추가
    @PostMapping("/addInteraction")
    public String addInteraction(@RequestParam("noticeNum") Long noticeNum,
                                 @AuthenticationPrincipal UserVO user) throws Exception {

        if (user == null) throw new RuntimeException("로그인이 필요합니다.");

        InteractionVO vo = new InteractionVO();
        vo.setBoardNum(noticeNum);  // Notice 고유번호
        vo.setType("NOTICE");        // 타입 구분
        vo.setUserName(user.getUsername());

        boardService.addInteraction(vo);

        return "redirect:/notice/detail?boardNum=" + noticeNum;
    }

    // 9) 인터랙션 제거
    @PostMapping("/removeInteraction")
    public String removeInteraction(@RequestParam("noticeNum") Long noticeNum,
                                    @AuthenticationPrincipal UserVO user) throws Exception {

        if (user == null) throw new RuntimeException("로그인이 필요합니다.");

        InteractionVO vo = new InteractionVO();
        vo.setBoardNum(noticeNum);
        vo.setType("NOTICE");
        vo.setUserName(user.getUsername());

        boardService.removeInteraction(vo);

        return "redirect:/notice/detail?boardNum=" + noticeNum;
    }

    // 관리자 여부 체크 메서드 (중복 제거)
    private boolean isAdmin(UserVO user) {
        return user != null && user.getRoleList() != null &&
               user.getRoleList().stream()
                   .anyMatch(role -> "ROLE_ADMIN".equals(role.getRoleName()));
    }
}
