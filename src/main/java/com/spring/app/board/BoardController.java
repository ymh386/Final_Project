package com.spring.app.board;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.*;

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

    @Value("${board.file.path}")
    private String uploadDir;

    @GetMapping({"/", "/list"})
    public String list(@ModelAttribute Pager pager,
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

    @GetMapping("/add")
    public String addForm(@RequestParam(value = "category", required = false) String category, Model m) {
        m.addAttribute("category", category);
        return "board/add";
    }

    @PostMapping("/add")
    public String add(@ModelAttribute BoardVO boardVO,
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

    @GetMapping("/detail")
    public String detail(@RequestParam("boardNum") Long boardNum,
                         @RequestParam(value = "inputPassword", required = false) String inputPassword,
                         @AuthenticationPrincipal UserVO user,
                         Model m) throws Exception {

        BoardVO detail = boardService.getDetail(new BoardVO(boardNum));
        boolean canRead = false;
        boolean isOwnerOrAdmin = false;

        boolean isAdmin = false;
        String currentUserName = null;
        if (user != null && user.getRoleList() != null) {
            isAdmin = user.getRoleList().stream()
                    .anyMatch(role -> "ROLE_ADMIN".equals(role.getRoleName()));
            currentUserName = user.getUsername();
        }

        if (detail != null) {
            if (detail.getIsSecret() == null || !detail.getIsSecret()) {
                canRead = true;
            } else if (isAdmin) {
                canRead = true;
                isOwnerOrAdmin = true;
            } else if (currentUserName != null && detail.getUserName().equals(currentUserName)) {
                canRead = true;
                isOwnerOrAdmin = true;
            } else if (inputPassword != null && inputPassword.equals(detail.getSecretPassword())) {
                canRead = true;
            }

            // 조회수 증가 (본인 글이 아닌 경우에만)
            if (canRead && (currentUserName == null || !currentUserName.equals(detail.getUserName()))) {
                boardService.hitUpdate(detail);
                // 조회수가 증가된 상태로 다시 조회
                detail = boardService.getDetail(new BoardVO(boardNum));
            }
        }

        if (user != null && detail != null) {
            isOwnerOrAdmin = isAdmin || (currentUserName != null && currentUserName.equals(detail.getUserName()));
        }

        long likeCount = 0;
        boolean isLiked = false;
        if (canRead) {
            InteractionVO iq = new InteractionVO();
            iq.setBoardNum(boardNum);
            iq.setType("LIKE");
            likeCount = boardService.getInteractionCount(iq);
            if (user != null) {
                iq.setUserName(currentUserName);
                isLiked = boardService.isLiked(iq);
            }
        }

        // 댓글 리스트 조회 및 트리 구조 변환
        List<CommentVO> comments = new ArrayList<>();
        if (canRead) {
            List<CommentVO> flatComments = boardService.getCommentList(new BoardVO(boardNum));
            comments = buildCommentTree(flatComments);
        }

        m.addAttribute("userName", currentUserName);
        m.addAttribute("roleList", user != null ? user.getRoleList() : null);
        m.addAttribute("detail", detail);
        m.addAttribute("files", canRead ? boardService.getFileList(new BoardVO(boardNum)) : new ArrayList<>());
        m.addAttribute("comments", comments);
        m.addAttribute("likeCount", likeCount);
        m.addAttribute("isLiked", isLiked);
        m.addAttribute("canRead", canRead);
        m.addAttribute("isOwnerOrAdmin", isOwnerOrAdmin);
        m.addAttribute("inputPassword", inputPassword);
        m.addAttribute("isAdmin", isAdmin);

        return "board/detail";
    }

    /**
     * 평면 댓글 리스트를 트리 구조로 변환
     */
    private List<CommentVO> buildCommentTree(List<CommentVO> flatComments) {
        if (flatComments == null || flatComments.isEmpty()) {
            return new ArrayList<>();
        }

        Map<Long, CommentVO> commentMap = new HashMap<>();
        List<CommentVO> roots = new ArrayList<>();

        // 모든 댓글을 맵에 저장하고 childComments 리스트 초기화
        for (CommentVO comment : flatComments) {
            if (comment.getChildComments() == null) {
                comment.setChildComments(new ArrayList<>());
            }
            commentMap.put(comment.getCommentNum(), comment);
        }

        // 부모-자식 관계 설정
        for (CommentVO comment : flatComments) {
            Long parentCommentNum = comment.getParentCommentNum();
            
            if (parentCommentNum == null || parentCommentNum == 0) {
                // 최상위 댓글 (부모가 없는 댓글)
                roots.add(comment);
            } else {
                // 대댓글 (부모가 있는 댓글)
                CommentVO parent = commentMap.get(parentCommentNum);
                if (parent != null) {
                    parent.getChildComments().add(comment);
                } else {
                    // 부모를 찾을 수 없는 경우 최상위로 처리 (데이터 무결성 문제 방지)
                    log.warn("부모 댓글을 찾을 수 없습니다. commentNum: {}, parentCommentNum: {}", 
                            comment.getCommentNum(), parentCommentNum);
                    comment.setParentCommentNum(null);
                    comment.setCommentDepth(0);
                    roots.add(comment);
                }
            }
        }

        // 각 레벨에서 날짜순 정렬
        sortCommentsRecursively(roots);
        
        return roots;
    }

    /**
     * 댓글을 재귀적으로 날짜순 정렬
     */
    private void sortCommentsRecursively(List<CommentVO> comments) {
        if (comments == null || comments.isEmpty()) {
            return;
        }

        // 현재 레벨 댓글들을 날짜순으로 정렬 (오래된 것부터)
        comments.sort((c1, c2) -> {
            if (c1.getCommentDate() == null && c2.getCommentDate() == null) return 0;
            if (c1.getCommentDate() == null) return 1;
            if (c2.getCommentDate() == null) return -1;
            return c1.getCommentDate().compareTo(c2.getCommentDate());
        });
        
        // 각 댓글의 자식들도 재귀적으로 정렬
        for (CommentVO comment : comments) {
            if (comment.getChildComments() != null && !comment.getChildComments().isEmpty()) {
                sortCommentsRecursively(comment.getChildComments());
            }
        }
    }

    @PostMapping("/detail")
    public String detailPost(@RequestParam("boardNum") Long boardNum,
                             @RequestParam("inputPassword") String inputPassword,
                             RedirectAttributes rttr) {
        rttr.addAttribute("boardNum", boardNum);
        rttr.addAttribute("inputPassword", inputPassword);
        return "redirect:/board/detail";
    }

    @GetMapping("/update")
    public String updateForm(@RequestParam("boardNum") Long boardNum,
                             @AuthenticationPrincipal UserVO user,
                             Model m) throws Exception {
        BoardVO vo = boardService.getDetail(new BoardVO(boardNum));
        if (vo == null) throw new RuntimeException("게시글을 찾을 수 없습니다.");

        boolean isAdmin = false;
        if (user != null && user.getRoleList() != null) {
            isAdmin = user.getRoleList().stream()
                    .anyMatch(role -> "ROLE_ADMIN".equals(role.getRoleName()));
        }

        if (user == null || (!vo.getUserName().equals(user.getUsername()) && !isAdmin)) {
            throw new RuntimeException("수정 권한이 없습니다.");
        }

        m.addAttribute("board", vo);
        return "board/update";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute BoardVO boardVO,
                         @RequestParam(value = "files", required = false) MultipartFile[] files,
                         @RequestParam(value = "isSecret", required = false) Boolean isSecret,
                         @RequestParam(value = "secretPassword", required = false) String secretPassword,
                         @RequestParam(value = "category", required = true) Long category,
                         @AuthenticationPrincipal UserVO user,
                         RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");

        BoardVO original = boardService.getDetail(new BoardVO(boardVO.getBoardNum()));

        boolean isAdmin = false;
        if (user.getRoleList() != null) {
            isAdmin = user.getRoleList().stream()
                    .anyMatch(role -> "ROLE_ADMIN".equals(role.getRoleName()));
        }

        if (!original.getUserName().equals(user.getUsername()) && !isAdmin) {
            throw new RuntimeException("수정 권한이 없습니다.");
        }

        boardVO.setUserName(original.getUserName());
        boardVO.setIsSecret(isSecret != null && isSecret);
        boardVO.setSecretPassword(isSecret != null && isSecret ? secretPassword : null);
        boardVO.setCategory(category);

        int result = boardService.update(boardVO, files);
        if (result > 0) {
            rttr.addAttribute("boardNum", boardVO.getBoardNum());
            return "redirect:/board/detail";
        } else {
            throw new RuntimeException("게시글 수정에 실패했습니다.");
        }
    }

    @PostMapping("/delete")
    public String delete(@RequestParam("boardNum") Long boardNum,
                         @AuthenticationPrincipal UserVO user,
                         RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");

        BoardVO vo = boardService.getDetail(new BoardVO(boardNum));

        boolean isAdmin = false;
        if (user.getRoleList() != null) {
            isAdmin = user.getRoleList().stream()
                    .anyMatch(role -> "ROLE_ADMIN".equals(role.getRoleName()));
        }
        boolean isOwner = vo != null && user.getUsername().equals(vo.getUserName());

        if (!isOwner && !isAdmin) {
            throw new RuntimeException("삭제 권한이 없습니다.");
        }

        boardService.delete(vo);

        return "redirect:/board/list";
    }

    @PostMapping("/addInteraction")
    public String addInteraction(HttpServletRequest request,
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

    @PostMapping("/removeInteraction")
    public String removeInteraction(HttpServletRequest request,
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

    @PostMapping("/addComment")
    public String addComment(@RequestParam("boardNum") Long boardNum,
                             @RequestParam("commentContents") String commentContents,
                             @AuthenticationPrincipal UserVO user,
                             RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");

        if (commentContents == null || commentContents.trim().isEmpty()) {
            throw new RuntimeException("댓글 내용을 입력해주세요.");
        }

        CommentVO vo = new CommentVO();
        vo.setBoardNum(boardNum);
        vo.setCommentContents(commentContents.trim());
        vo.setUserName(user.getUsername());
        vo.setParentCommentNum(null);  // 최상위 댓글이므로 부모 없음
        vo.setCommentDepth(0);         // 최상위 댓글이므로 깊이 0

        boardService.addComment(vo);

        rttr.addAttribute("boardNum", boardNum);
        return "redirect:/board/detail";
    }

    @PostMapping("/addReplyComment")
    public String addReplyComment(@RequestParam("boardNum") Long boardNum,
                                  @RequestParam("parentCommentNum") Long parentCommentNum,
                                  @RequestParam("commentContents") String commentContents,
                                  @AuthenticationPrincipal UserVO user,
                                  RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");

        if (commentContents == null || commentContents.trim().isEmpty()) {
            throw new RuntimeException("댓글 내용을 입력해주세요.");
        }

        if (parentCommentNum == null || parentCommentNum <= 0) {
            throw new RuntimeException("부모 댓글이 올바르지 않습니다.");
        }

        // 부모 댓글 조회
        CommentVO parent = boardService.getCommentById(parentCommentNum);
        if (parent == null) {
            throw new RuntimeException("부모 댓글을 찾을 수 없습니다.");
        }

        // 댓글 깊이 제한 (예: 5단계까지만 허용)
        if (parent.getCommentDepth() >= 4) {
            throw new RuntimeException("댓글 깊이가 너무 깊습니다. 더 이상 대댓글을 작성할 수 없습니다.");
        }

        CommentVO commentVO = new CommentVO();
        commentVO.setBoardNum(boardNum);
        commentVO.setParentCommentNum(parentCommentNum);
        commentVO.setCommentContents(commentContents.trim());
        commentVO.setUserName(user.getUsername());
        commentVO.setCommentDepth(parent.getCommentDepth() + 1);  // 부모 댓글 깊이 + 1

        boardService.addReplyComment(commentVO);

        rttr.addAttribute("boardNum", boardNum);
        return "redirect:/board/detail";
    }
    @PostMapping("/deletecomment")
    public String deleteComment(@RequestParam("commentNum") Long commentNum,
                                @RequestParam("boardNum") Long boardNum,
                                @AuthenticationPrincipal UserVO user,
                                RedirectAttributes rttr) throws Exception {
        if (user == null) throw new RuntimeException("로그인이 필요합니다.");

        CommentVO comment = boardService.getCommentById(commentNum);
        if (comment == null) {
            throw new RuntimeException("댓글을 찾을 수 없습니다.");
        }

        boolean isAdmin = false;
        if (user.getRoleList() != null) {
            isAdmin = user.getRoleList().stream()
                    .anyMatch(role -> "ROLE_ADMIN".equals(role.getRoleName()));
        }

        boolean isOwner = comment.getUserName().equals(user.getUsername());

        if (!isOwner && !isAdmin) {
            throw new RuntimeException("댓글 삭제 권한이 없습니다.");
        }

        // 그냥 삭제 (원래 코드와 동일)
        boardService.deleteComment(comment);

        rttr.addAttribute("boardNum", boardNum);
        return "redirect:/board/detail";
    }

    @GetMapping("/fileDown")
    public void fileDown(@RequestParam("fileNum") Long fileNum,
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