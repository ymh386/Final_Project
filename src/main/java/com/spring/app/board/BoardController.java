package com.spring.app.board;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.spring.app.board.comment.CommentVO;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.home.util.Pager;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;

@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired private BoardService boardService;

    @GetMapping("/list")
    public String list(Pager pager, Model m) throws Exception {
        m.addAttribute("list", boardService.getList(pager));
        m.addAttribute("pager", pager);
        return "board/list";
    }

    @GetMapping("/detail")
    public String detail(BoardVO boardVO, Model m,
                         @AuthenticationPrincipal User user) throws Exception {
        BoardVO detail = boardService.getDetail(boardVO);
        boolean isLiked = user!=null && boardService.isLiked(detail.getBoardNum(), user.getUsername());
        m.addAttribute("detail", detail);
        m.addAttribute("files", boardService.getFileList(boardVO));
        m.addAttribute("comments", boardService.getCommentList(boardVO));
        m.addAttribute("likeCount", boardService.getInteractionCount(boardVO));
        m.addAttribute("isLiked", isLiked);
        return "board/detail";
    }

    @GetMapping("/add")
    public String addForm() { return "board/add"; }

    @PostMapping("/add")
    public String add(BoardVO vo,
                      @RequestParam(value="files", required=false) MultipartFile[] files,
                      @AuthenticationPrincipal User user,
                      Model m) throws Exception {
        if (files!=null && files.length>5) {
            m.addAttribute("msg","첨부파일은 최대 5개까지 가능합니다.");
            m.addAttribute("path","/board/add");
            return "common/result";
        }
        vo.setUserName(user.getUsername());
        boardService.add(vo, files!=null?files:new MultipartFile[0]);
        return "redirect:/board/list";
    }

    @PostMapping("/update")
    public String update(BoardVO vo) throws Exception {
        boardService.update(vo);
        return "redirect:/board/detail?boardNum="+vo.getBoardNum();
    }

    @PostMapping("/delete")
    public String delete(BoardVO vo) throws Exception {
        boardService.delete(vo);
        return "redirect:/board/list";
    }

    @GetMapping("/fileDown")
    public String fileDown(BoardFileVO fileVO, Model m) throws Exception {
        m.addAttribute("fileVO", boardService.getFileDetail(fileVO));
        return "fileDownView";
    }

    @PostMapping("/like")
    @ResponseBody
    public Long addLike(@RequestBody InteractionVO vo,
                        @AuthenticationPrincipal User user) throws Exception {
        vo.setUserName(user.getUsername());
        boardService.addInteraction(vo);
        return boardService.getInteractionCount(new BoardVO(vo.getBoardNum()));
    }

    @PostMapping("/unlike")
    @ResponseBody
    public Long removeLike(@RequestBody InteractionVO vo,
                           @AuthenticationPrincipal User user) throws Exception {
        vo.setUserName(user.getUsername());
        boardService.removeInteraction(vo);
        return boardService.getInteractionCount(new BoardVO(vo.getBoardNum()));
    }

    @PostMapping("/commentAdd")
    @ResponseBody
    public List<CommentVO> commentAdd(@RequestBody CommentVO vo,
                                      @AuthenticationPrincipal User user) throws Exception {
        vo.setUserName(user.getUsername());
        boardService.addComment(vo);
        return boardService.getCommentList(new BoardVO(vo.getBoardNum()));
    }

    @PostMapping("/commentDelete")
    @ResponseBody
    public List<CommentVO> commentDelete(@RequestBody CommentVO vo) throws Exception {
        boardService.deleteComment(vo);
        return boardService.getCommentList(new BoardVO(vo.getBoardNum()));
    }
}
