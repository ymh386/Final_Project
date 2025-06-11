// src/main/java/com/spring/app/board/BoardController.java
package com.spring.app.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.spring.app.board.comment.CommentVO;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.home.util.Pager;

@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired
    private BoardService boardService;
    
    // 목록 매핑: /board/ 또는 /board/index
    @GetMapping({"/", "/index"})
    public String index(
            @ModelAttribute Pager pager,
            @RequestParam(value="searchField", required=false) String searchField,
            @RequestParam(value="searchWord",  required=false) String searchWord,
            Model m) throws Exception {
        // 페이징·검색 로직 동일
        pager.setSearchField(searchField);
        pager.setSearchWord(searchWord);
        pager.makeRow();

        long totalCount = boardService.getTotalCount(pager);
        pager.makePage(totalCount);

        m.addAttribute("boards", boardService.getList(pager));
        m.addAttribute("pager",  pager);
        return "board/index";  // 뷰 파일명: /WEB-INF/views/board/index.jsp
    }

    
    /** 1) 목록 + 페이징 + 검색 */
    @GetMapping("/list")
    public String list(
            @ModelAttribute Pager pager,
            @RequestParam(value="searchField", required=false) String searchField,
            @RequestParam(value="searchWord",  required=false) String searchWord,
            Model m) throws Exception {

        pager.setSearchField(searchField);
        pager.setSearchWord(searchWord);
        pager.makeRow();

        long totalCount = boardService.getTotalCount(pager);
        pager.makePage(totalCount);

        List<BoardVO> boards = boardService.getList(pager);
        m.addAttribute("boards", boards);
        m.addAttribute("pager",  pager);
        return "board/list";
    }

    /** 2) 상세 */
    @GetMapping("/detail")
    public String detail(
            BoardVO boardVO,
            Model m,
            @AuthenticationPrincipal User user) throws Exception {

        BoardVO detail = boardService.getDetail(boardVO);

        long likeCount = 0;
        boolean isLiked = false;
        if (detail != null) {
            InteractionVO iq = new InteractionVO();
            iq.setBoardNum(detail.getBoardNum());
            iq.setType("LIKE");
            likeCount = boardService.getInteractionCount(iq);
            if (user != null) {
                iq.setUserName(user.getUsername());
                isLiked = boardService.isLiked(iq);
            }
        }

        m.addAttribute("detail",    detail);
        m.addAttribute("files",     boardService.getFileList(boardVO));
        m.addAttribute("comments",  boardService.getCommentList(boardVO));
        m.addAttribute("likeCount", likeCount);
        m.addAttribute("isLiked",   isLiked);
        return "board/detail";
    }

    /** 3) 등록 폼 (로그인 체크 포함) */
    @GetMapping("/add")
    public String addForm(
            @AuthenticationPrincipal User user,
            Model model) {

        if (user == null) {
            model.addAttribute("msg",  "글 작성은 로그인 후에 가능합니다.");
            model.addAttribute("path", "/board/login");   // ← 수정
            return "commons/result";                       // 폴더명도 common으로
        }
        model.addAttribute("boardVO", new BoardVO());
        return "board/add";
    }

    /** 4) 등록 처리 */
    @PostMapping("/add")
    public String add(
            @ModelAttribute BoardVO vo,
            @RequestParam(value="files", required=false) MultipartFile[] files,
            @AuthenticationPrincipal User user,
            Model m) throws Exception {

        if (user == null) {
            m.addAttribute("msg",  "글 작성은 로그인 후에 가능합니다.");
            m.addAttribute("path", "/board/login");     // ← 수정
            return "commons/result";
        }
        if (files != null && files.length > 5) {
            m.addAttribute("msg",  "첨부파일은 최대 5개까지 가능합니다.");
            m.addAttribute("path", "/board/add");
            return "commons/result";
        }
        vo.setUserName(user.getUsername());
        boardService.add(vo, files != null ? files : new MultipartFile[0]);
        return "redirect:/board/index";  // 목록 URL도 index로 바꿨다면 이렇게
    }

    /** 5) /board/login → user/login.jsp 포워딩 */
    @GetMapping("/login")
    public String loginFromBoard() {
        return "user/login";
    }

    /** 5) 수정 처리 */
    @PostMapping("/update")
    public String update(BoardVO vo) throws Exception {
        boardService.update(vo);
        return "redirect:/board/detail?boardNum=" + vo.getBoardNum();
    }

    /** 6) 삭제 처리 */
    @PostMapping("/delete")
    public String delete(BoardVO vo) throws Exception {
        boardService.delete(vo);
        return "redirect:/board/index";
    }

    /** 7) 파일 다운로드 */
    @GetMapping("/fileDown")
    public String fileDown(BoardFileVO fileVO, Model m) throws Exception {
        m.addAttribute("fileVO", boardService.getFileDetail(fileVO));
        return "fileDownView";
    }

    /** 8) 좋아요 등록(Ajax) */
    @PostMapping("/like")
    @ResponseBody
    public Long addLike(
            @RequestBody InteractionVO vo,
            @AuthenticationPrincipal User user) throws Exception {

        vo.setUserName(user.getUsername());
        vo.setType("LIKE");
        boardService.addInteraction(vo);
        return boardService.getInteractionCount(vo);
    }

    /** 9) 좋아요 취소(Ajax) */
    @PostMapping("/unlike")
    @ResponseBody
    public Long removeLike(
            @RequestBody InteractionVO vo,
            @AuthenticationPrincipal User user) throws Exception {

        vo.setUserName(user.getUsername());
        vo.setType("LIKE");
        boardService.removeInteraction(vo);
        return boardService.getInteractionCount(vo);
    }

    /** 10) 댓글 등록(Ajax) */
    @PostMapping("/commentAdd")
    @ResponseBody
    public List<CommentVO> commentAdd(
            @RequestBody CommentVO vo,
            @AuthenticationPrincipal User user) throws Exception {

        vo.setUserName(user.getUsername());
        boardService.addComment(vo);

        BoardVO bvo = new BoardVO();
        bvo.setBoardNum(vo.getBoardNum());
        return boardService.getCommentList(bvo);
    }

    /** 11) 댓글 삭제(Ajax) */
    @PostMapping("/commentDelete")
    @ResponseBody
    public List<CommentVO> commentDelete(
            @RequestBody CommentVO vo) throws Exception {

        boardService.deleteComment(vo);

        BoardVO bvo = new BoardVO();
        bvo.setBoardNum(vo.getBoardNum());
        return boardService.getCommentList(bvo);
    }
}
