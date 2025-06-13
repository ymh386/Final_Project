
// src/main/java/com/spring/app/board/BoardController.java
package com.spring.app.board;


import java.io.File;
import java.io.FileInputStream;

import java.io.OutputStream;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


import com.spring.app.board.comment.CommentVO;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.home.util.Pager;
import com.spring.app.user.UserVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
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

    

    /**
     * 상세 보기: 조회수(hit) 비동기 업데이트는 /hitUpdateAsync 로 분리
     */
    @GetMapping("/detail")
    public String detail(
            @RequestParam("boardNum") Long boardNum,
            @AuthenticationPrincipal UserVO user,
            Model m
    ) throws Exception {
        // 기존에는 여기서 hitUpdate() 했는데, AJAX로 분리했습니다.

        // 상세 데이터 조회
        BoardVO detail = boardService.getDetail(new BoardVO(boardNum));

        // 좋아요 정보
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

    /**
     * AJAX용 조회수 증가 → 업데이트된 조회수(long) 반환
       /**
     * AJAX 조회수 증가 + 증가된 값을 바로 리턴
     */
    @PostMapping("/hitUpdateAsync")
    @ResponseBody
    public String hitUpdateAsync(@RequestParam Long boardNum) throws Exception {
        boardService.hitUpdate(new BoardVO(boardNum));
        // 증가된 조회수를 다시 읽어서 리턴
        BoardVO vo = boardService.getDetail(new BoardVO(boardNum));
        return String.valueOf(vo.getBoardHits());
    }
    /**
     * 좋아요 추가 → 다시 detail 리다이렉트
     */
    @PostMapping("/addInteraction")
    public String addInteraction(
            HttpServletRequest request,
            @AuthenticationPrincipal UserVO user,
            RedirectAttributes rttr
    ) throws Exception {
        if (user == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }
        Long boardNum = Long.valueOf(request.getParameter("boardNum"));
        InteractionVO vo = new InteractionVO();
        vo.setBoardNum(boardNum);
        vo.setUserName(user.getUsername());
        vo.setType("LIKE");

        boardService.addInteraction(vo);

        rttr.addAttribute("boardNum", boardNum);
        return "redirect:/board/detail";
    }

    /**
     * 좋아요 취소 → 다시 detail 리다이렉트
     */
    @PostMapping("/removeInteraction")
    public String removeInteraction(
            HttpServletRequest request,
            @AuthenticationPrincipal UserVO user,
            RedirectAttributes rttr
    ) throws Exception {
        if (user == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }
        Long boardNum = Long.valueOf(request.getParameter("boardNum"));
        InteractionVO vo = new InteractionVO();
        vo.setBoardNum(boardNum);
        vo.setUserName(user.getUsername());
        vo.setType("LIKE");

        boardService.removeInteraction(vo);

        rttr.addAttribute("boardNum", boardNum);
        return "redirect:/board/detail";
    }


    @PostMapping("/addComment")
    public String addComment(
            @RequestParam("boardNum") Long boardNum,
            @RequestParam("commentContents") String commentContents,
            @AuthenticationPrincipal UserVO user,
            RedirectAttributes rttr
    ) throws Exception {
        if (user == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }

        CommentVO vo = new CommentVO();
        vo.setBoardNum(boardNum);
        vo.setCommentContents(commentContents);
        vo.setUserName(user.getUsername());

        // 댓글 등록
        boardService.addComment(vo);

        // 상세보기로 돌아갈 때 boardNum 쿼리스트링에 포함
        rttr.addAttribute("boardNum", boardNum);
        return "redirect:/board/detail";
    }


    @PostMapping("/deletecomment")
    @ResponseBody
    public List<CommentVO> deleteComment(@RequestParam("commentNum") Long commentNum,
                                         @RequestParam("boardNum") Long boardNum) throws Exception {
        CommentVO vo = new CommentVO();
        vo.setCommentNum(commentNum);
        vo.setBoardNum(boardNum);
        boardService.deleteComment(vo);
        return boardService.getCommentList(new BoardVO(boardNum));
    }

    @Value("${board.file.path}")
    private String uploadDir;

    /**
     * 파일 다운로드
     * GET /board/fileDown?fileNum={fileNum}
     */
    @GetMapping("/fileDown")
    public void fileDown(
            @RequestParam("fileNum") Long fileNum,
            HttpServletResponse response
    ) throws Exception {
        BoardFileVO param = new BoardFileVO();
        param.setFileNum(fileNum);
        BoardFileVO file = boardService.getFileDetail(param);
        if (file == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File diskFile = new File(uploadDir, file.getFileName());
        if (!diskFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // set headers
        response.setContentType("application/octet-stream");
        String encoded = java.net.URLEncoder.encode(file.getOldName(), "UTF-8").replaceAll("\\+", "%20");
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);
        response.setContentLengthLong(diskFile.length());

        // stream file
        try (FileInputStream in = new FileInputStream(diskFile);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int len;
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
            
        }
    }
}
    

