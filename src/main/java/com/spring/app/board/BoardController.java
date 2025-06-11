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

    /** 1) 목록 + 페이징 + 검색 (/board/, /board/index) */
    @GetMapping({"/", "/index"})
    public String index(
            @ModelAttribute Pager pager,
            @RequestParam(value="searchField", required=false) String searchField,
            @RequestParam(value="searchWord",  required=false) String searchWord,
            Model m) throws Exception {
        pager.setSearchField(searchField);
        pager.setSearchWord(searchWord);
        pager.makeRow();

        long totalCount = boardService.getTotalCount(pager);
        pager.makePage(totalCount);

        m.addAttribute("boards", boardService.getList(pager));
        m.addAttribute("pager",  pager);
        return "board/index";
    }
    
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
    

    /** 2) 상세 (/board/detail) */
    @GetMapping("/detail")
    public String detail(
            @RequestParam("boardNum") Long boardNum,
            Model m,
            @AuthenticationPrincipal User user) throws Exception {

        BoardVO detail = boardService.getDetail(new BoardVO(boardNum));
        long likeCount = 0;
        boolean isLiked = false;
        if (detail != null) {
            InteractionVO iq = new InteractionVO();
            iq.setBoardNum(boardNum);
            iq.setType("LIKE");
            likeCount = boardService.getInteractionCount(iq);
            if (user != null) {
                iq.setUserName(user.getUsername());
                isLiked = boardService.isLiked(iq);
            }
        }

        m.addAttribute("detail",    detail);
        m.addAttribute("files",     boardService.getFileList(new BoardVO(boardNum)));
        m.addAttribute("comments",  boardService.getCommentList(new BoardVO(boardNum)));
        m.addAttribute("likeCount", likeCount);
        m.addAttribute("isLiked",   isLiked);
        return "board/detail";
    }

    /** 3) 등록 폼 (/board/add) */
    @GetMapping("/add")
    public String addForm(
            @AuthenticationPrincipal User user,
            Model m) {

        // 로그인 안 된 경우에만 메시지
//        if (user == null) {
//            m.addAttribute("msg",  "글 작성은 로그인 후에 가능합니다.");
//            m.addAttribute("path", "/user/login");
//            return "commons/result";
//        }

        // 로그인 된 경우만 등록 폼으로
        m.addAttribute("boardVO", new BoardVO());
        return "board/add";
    }

    /** 4) 등록 처리 (POST /board/add) */
    @PostMapping("/add")
    public String add(
            @ModelAttribute BoardVO vo,
            @RequestParam(value="files", required=false) MultipartFile[] files,
            @AuthenticationPrincipal User user,
            Model m) throws Exception {
//
//        // 로그인 안 된 경우에만 메시지
//        if (user == null) {
//            m.addAttribute("msg",  "글 작성은 로그인 후에 가능합니다.");
//            m.addAttribute("path", "/user/login");
//            return "commons/result";
//        }

        // 첨부파일 개수 제한
        if (files != null && files.length > 5) {
            m.addAttribute("msg",  "첨부파일은 최대 5개까지 가능합니다.");
            m.addAttribute("path", "/board/add");
            return "commons/result";
        }

        // 로그인된 사용자명 세팅 후 저장
        vo.setUserName(user.getUsername());
        boardService.add(vo, files != null ? files : new MultipartFile[0]);
        return "redirect:/board/index";
    }

    /** 5) 로그인 폼 포워딩 (/board/login) */
    @GetMapping("/login")
    public String loginFromBoard() {
        return "user/login";
    }

    /** 6) 수정 처리 (POST /board/update) */
    @PostMapping("/update")
    public String update(BoardVO vo) throws Exception {
        boardService.update(vo);
        return "redirect:/board/detail?boardNum=" + vo.getBoardNum();
    }

    /** 7) 삭제 처리 (POST /board/delete) */
    @PostMapping("/delete")
    public String delete(BoardVO vo) throws Exception {
        boardService.delete(vo);
        return "redirect:/board/index";
    }

    /** 8) 파일 다운로드 (/board/fileDown) */
    @GetMapping("/fileDown")
    public String fileDown(BoardFileVO fileVO, Model m) throws Exception {
        m.addAttribute("fileVO", boardService.getFileDetail(fileVO));
        return "fileDownView";
    }

    /** 9) 좋아요 등록 (Ajax POST /board/like) */
    @PostMapping("/like")
    @ResponseBody
    public Long addLike(
            @RequestBody InteractionVO vo,
            @AuthenticationPrincipal User user) throws Exception {

        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        vo.setUserName(user.getUsername());
        vo.setType("LIKE");
        boardService.addInteraction(vo);
        return boardService.getInteractionCount(vo);
    }

    /** 10) 좋아요 취소 (Ajax POST /board/unlike) */
    @PostMapping("/unlike")
    @ResponseBody
    public Long removeLike(
            @RequestBody InteractionVO vo,
            @AuthenticationPrincipal User user) throws Exception {

        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        vo.setUserName(user.getUsername());
        vo.setType("LIKE");
        boardService.removeInteraction(vo);
        return boardService.getInteractionCount(vo);
    }

    /** 11) 댓글 등록 (Ajax POST /board/commentAdd) */
    @PostMapping("/commentAdd")
    @ResponseBody
    public List<CommentVO> commentAdd(
            @RequestBody CommentVO vo,
            @AuthenticationPrincipal User user) throws Exception {

        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        vo.setUserName(user.getUsername());
        boardService.addComment(vo);
        BoardVO bvo = new BoardVO(vo.getBoardNum());
        return boardService.getCommentList(bvo);
    }

    /** 12) 댓글 삭제 (Ajax POST /board/commentDelete) */
    @PostMapping("/commentDelete")
    @ResponseBody
    public List<CommentVO> commentDelete(@RequestBody CommentVO vo) throws Exception {
        boardService.deleteComment(vo);
        BoardVO bvo = new BoardVO(vo.getBoardNum());
        return boardService.getCommentList(bvo);
    }
}
