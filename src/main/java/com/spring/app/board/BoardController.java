package com.spring.app.board;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
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

/**
 * 게시판 컨트롤러 (CRUD)
 */
@Slf4j
@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired
    private BoardService boardService;

    @Value("${board.file.path}")
    private String uploadDir;

    /** 목록 (검색/페이징) */
    @GetMapping({"/", "/list"})
    public String list(
            @ModelAttribute Pager pager,
            @RequestParam(value = "searchField", required = false) String searchField,
            @RequestParam(value = "searchWord", required = false) String searchWord,
            Model m) throws Exception {
        pager.setSearchField(searchField);
        pager.setSearchWord(searchWord);
        pager.makeRow();
        long totalCount = boardService.getTotalCount(pager);
        pager.makePage(totalCount);
        m.addAttribute("boards", boardService.getList(pager));
        m.addAttribute("pager", pager);
        return "board/list";
    }

    /** 글쓰기 폼 */
    @GetMapping("/add")
    public String addForm(@RequestParam(value = "category", required = false) String category, Model m) {
        m.addAttribute("category", category);
        return "board/add";
    }

    /** 글 등록 */
    @PostMapping("/add")
    public String add(
            @ModelAttribute BoardVO boardVO,
            @RequestParam(value = "files", required = false) MultipartFile[] files,
            @RequestParam(value = "isSecret", required = false) Boolean isSecret,
            @RequestParam(value = "secretPassword", required = false) String secretPassword,
            @AuthenticationPrincipal UserVO user,
            RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        boardVO.setUserName(user.getUsername());
        boardVO.setIsSecret(isSecret != null && isSecret);
        if (boardVO.getIsSecret() != null && boardVO.getIsSecret()) boardVO.setSecretPassword(secretPassword);
        else boardVO.setSecretPassword(null);

        int result = boardService.add(boardVO, files);
        if (result > 0) {
            rttr.addAttribute("boardNum", boardVO.getBoardNum());
            return "redirect:/board/detail";
        } else {
            throw new RuntimeException("게시글 작성에 실패했습니다.");
        }
    }

    /** 상세 보기 (비밀글 처리) */
    @GetMapping("/detail")
    public String detail(
            @RequestParam("boardNum") Long boardNum,
            @RequestParam(value = "inputPassword", required = false) String inputPassword,
            @AuthenticationPrincipal UserVO user,
            Model m) throws Exception {
        BoardVO detail = boardService.getDetail(new BoardVO(boardNum));
        boolean canRead = false;
        boolean isOwnerOrAdmin = false;
        boolean isAdmin = user != null && user.getRoleList() != null && user.getRoleList().contains("ADMIN");

        if (detail != null) {
            // 비밀글 아니면 공개
            if (detail.getIsSecret() == null || !detail.getIsSecret()) {
                canRead = true;
            }
            // 비밀글: 글쓴이, 관리자, 비번 일치자만
            else if (user != null && (detail.getUserName().equals(user.getUsername()) || isAdmin)) {
                canRead = true;
                isOwnerOrAdmin = true;
            } else if (inputPassword != null && inputPassword.equals(detail.getSecretPassword())) {
                canRead = true;
            }
        }

        long likeCount = 0;
        boolean isLiked = false;
        if (canRead) {
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
        m.addAttribute("canRead", canRead);
        m.addAttribute("isOwnerOrAdmin", isOwnerOrAdmin);
        m.addAttribute("inputPassword", inputPassword);

        return "board/detail";
    }

    /** 수정 폼 */
    @GetMapping("/update")
    public String updateForm(
            @RequestParam("boardNum") Long boardNum,
            @AuthenticationPrincipal UserVO user,
            Model m) throws Exception {
        BoardVO vo = boardService.getDetail(new BoardVO(boardNum));
        if (vo == null) throw new RuntimeException("게시글을 찾을 수 없습니다.");
        boolean isAdmin = user != null && user.getRoleList() != null && user.getRoleList().contains("ADMIN");
        if (user == null || (!vo.getUserName().equals(user.getUsername()) && !isAdmin)) {
            throw new RuntimeException("수정 권한이 없습니다.");
        }
        m.addAttribute("board", vo);
        return "board/update";
    }

    /** 수정 처리 */
    @PostMapping("/update")
    public String update(
            @ModelAttribute BoardVO boardVO,
            @RequestParam(value = "files", required = false) MultipartFile[] files,
            @RequestParam(value = "isSecret", required = false) Boolean isSecret,
            @RequestParam(value = "secretPassword", required = false) String secretPassword,
            @AuthenticationPrincipal UserVO user,
            RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        BoardVO original = boardService.getDetail(new BoardVO(boardVO.getBoardNum()));
        boolean isAdmin = user.getRoleList() != null && user.getRoleList().contains("ADMIN");
        if (!original.getUserName().equals(user.getUsername()) && !isAdmin) {
            throw new RuntimeException("수정 권한이 없습니다.");
        }
        boardVO.setUserName(original.getUserName());
        boardVO.setIsSecret(isSecret != null && isSecret);
        boardVO.setSecretPassword(boardVO.getIsSecret() != null && boardVO.getIsSecret() ? secretPassword : null);
        int result = boardService.update(boardVO, files);
        if (result > 0) {
            rttr.addAttribute("boardNum", boardVO.getBoardNum());
            return "redirect:/board/detail";
        } else {
            throw new RuntimeException("게시글 수정에 실패했습니다.");
        }
    }

    /** 삭제 처리 */
    @PostMapping("/delete")
    public String delete(
            @RequestParam("boardNum") Long boardNum,
            @AuthenticationPrincipal UserVO user,
            RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        BoardVO vo = boardService.getDetail(new BoardVO(boardNum));
        boolean isAdmin = user.getRoleList() != null && user.getRoleList().contains("ADMIN");
        if (!vo.getUserName().equals(user.getUsername()) && !isAdmin) {
            throw new RuntimeException("삭제 권한이 없습니다.");
        }
        boardService.delete(vo);
        return "redirect:/board/list";
    }

    // ====== 이하 기존 좋아요/댓글/파일 다운로드 등 부가기능은 그대로 ======
    @GetMapping("/checkSecret")
    @ResponseBody
    public boolean checkSecret(@RequestParam("boardNum") Long boardNum) throws Exception {
        BoardVO vo = new BoardVO();
        vo.setBoardNum(boardNum);
        return boardService.checkSecret(vo);
    }

    @PostMapping("/hitUpdateAsync")
    @ResponseBody
    public ResponseEntity<Long> hitUpdateAsync(@RequestParam("boardNum") Long boardNum) {
        log.info("hitUpdateAsync POST called, boardNum={}", boardNum);
        if (boardNum == null || boardNum <= 0) return ResponseEntity.badRequest().build();
        try {
            boardService.hitUpdate(new BoardVO(boardNum));
            long updated = boardService.getDetail(new BoardVO(boardNum)).getBoardHits();
            return ResponseEntity.ok(updated);
        } catch (Exception e) {
            log.error("Error updating hits", e);
            return ResponseEntity.status(500).build();
        }
    }

    @GetMapping("/getViewCount")
    @ResponseBody
    public ResponseEntity<Long> getViewCount(@RequestParam("boardNum") Long boardNum) {
        log.info("getViewCount GET called, boardNum={}", boardNum);
        if (boardNum == null || boardNum <= 0) return ResponseEntity.badRequest().build();
        try {
            long count = boardService.getDetail(new BoardVO(boardNum)).getBoardHits();
            return ResponseEntity.ok(count);
        } catch (Exception e) {
            log.error("Error fetching view count", e);
            return ResponseEntity.status(500).build();
        }
    }

    /** 좋아요 추가 */
    @PostMapping("/addInteraction")
    public String addInteraction(
            HttpServletRequest request,
            @AuthenticationPrincipal UserVO user,
            RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        Long boardNum = Long.valueOf(request.getParameter("boardNum"));
        InteractionVO vo = new InteractionVO();
        vo.setBoardNum(boardNum);
        vo.setUserName(user.getUsername());
        vo.setType("LIKE");
        boardService.addInteraction(vo);
        rttr.addAttribute("boardNum", boardNum);
        return "redirect:/board/detail";
    }

    /** 좋아요 취소 */
    @PostMapping("/removeInteraction")
    public String removeInteraction(
            HttpServletRequest request,
            @AuthenticationPrincipal UserVO user,
            RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        Long boardNum = Long.valueOf(request.getParameter("boardNum"));
        InteractionVO vo = new InteractionVO();
        vo.setBoardNum(boardNum);
        vo.setUserName(user.getUsername());
        vo.setType("LIKE");
        boardService.removeInteraction(vo);
        rttr.addAttribute("boardNum", boardNum);
        return "redirect:/board/detail";
    }

    /** 댓글 등록 */
    @PostMapping("/addComment")
    public String addComment(
            @RequestParam("boardNum") Long boardNum,
            @RequestParam("commentContents") String commentContents,
            @AuthenticationPrincipal UserVO user,
            RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");
        CommentVO vo = new CommentVO();
        vo.setBoardNum(boardNum);
        vo.setCommentContents(commentContents);
        vo.setUserName(user.getUsername());
        boardService.addComment(vo);
        rttr.addAttribute("boardNum", boardNum);
        return "redirect:/board/detail";
    }

    /** 댓글 삭제 */
    @PostMapping("/deletecomment")
    @ResponseBody
    public List<CommentVO> deleteComment(
            @RequestParam("commentNum") Long commentNum,
            @RequestParam("boardNum") Long boardNum) throws Exception {
        CommentVO vo = new CommentVO();
        vo.setCommentNum(commentNum);
        vo.setBoardNum(boardNum);
        boardService.deleteComment(vo);
        return boardService.getCommentList(new BoardVO(boardNum));
    }

    /** 파일 다운로드 */
    @GetMapping("/fileDown")
    public void fileDown(
            @RequestParam("fileNum") Long fileNum,
            HttpServletResponse response) throws Exception {
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
        response.setContentType("application/octet-stream");
        String encoded = java.net.URLEncoder.encode(file.getOldName(), "UTF-8").replaceAll("\\+", "%20");
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);
        response.setContentLengthLong(diskFile.length());
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
