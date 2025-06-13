
// src/main/java/com/spring/app/board/BoardController.java
package com.spring.app.board;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.spring.app.board.comment.CommentVO;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.home.util.Pager;
import com.spring.app.user.UserVO;

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
    
 // 게시글 작성 폼 페이지
    @GetMapping("/add")
    public String add() {
        return "board/add";
    }

    // 게시글 작성 처리
    @PostMapping("/add")
    public String add(@ModelAttribute BoardVO boardVO,
                      @RequestParam(value="files", required=false) MultipartFile[] files,
                      @AuthenticationPrincipal UserVO user) throws Exception {
        
        if (user == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }
        
        // 작성자 정보 설정
        boardVO.setUserName(user.getUsername());
        
        // 게시글 저장
        int result = boardService.add(boardVO, files);
        
        if (result > 0) {
            return "redirect:/board/detail?boardNum=" + boardVO.getBoardNum();
        } else {
            throw new RuntimeException("게시글 작성에 실패했습니다.");
        }
    }

    

    @GetMapping("/detail")
    public String detail(@RequestParam("boardNum") Long boardNum,
                         Model m,
                         @AuthenticationPrincipal UserVO user) throws Exception {

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

        m.addAttribute("detail", detail);
        m.addAttribute("files", boardService.getFileList(new BoardVO(boardNum)));
        m.addAttribute("comments", boardService.getCommentList(new BoardVO(boardNum)));
        m.addAttribute("likeCount", likeCount);
        m.addAttribute("isLiked", isLiked);
        return "board/detail";
    }

    @PostMapping("/like")
    @ResponseBody
    public long addLike(@RequestParam("boardNum") Long boardNum,
                        @AuthenticationPrincipal UserVO user) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        InteractionVO vo = new InteractionVO();
        vo.setBoardNum(boardNum);
        vo.setUserName(user.getUsername());
        vo.setType("LIKE");
        boardService.addInteraction(vo);
        return boardService.getInteractionCount(vo);
    }

    @PostMapping("/unlike")
    @ResponseBody
    public long removeLike(@RequestParam("boardNum") Long boardNum,
                           @AuthenticationPrincipal UserVO user) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        InteractionVO vo = new InteractionVO();
        vo.setBoardNum(boardNum);
        vo.setUserName(user.getUsername());
        vo.setType("LIKE");
        boardService.removeInteraction(vo);
        return boardService.getInteractionCount(vo);
    }

    @PostMapping("/commentAdd")
    @ResponseBody
    public List<CommentVO> commentAdd(@RequestParam("boardNum") Long boardNum,
                                      @RequestParam("commentContents") String commentContents,
                                      @AuthenticationPrincipal UserVO user) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        CommentVO vo = new CommentVO();
        vo.setBoardNum(boardNum);
        vo.setCommentContents(commentContents);
        vo.setUserName(user.getUsername());
        boardService.addComment(vo);
        return boardService.getCommentList(new BoardVO(boardNum));
    }

    @PostMapping("/commentDelete")
    @ResponseBody
    public List<CommentVO> commentDelete(@RequestParam("commentNum") Long commentNum,
                                         @RequestParam("boardNum") Long boardNum) throws Exception {
        CommentVO vo = new CommentVO();
        vo.setCommentNum(commentNum);
        vo.setBoardNum(boardNum);
        boardService.deleteComment(vo);
        return boardService.getCommentList(new BoardVO(boardNum));
    }
}
