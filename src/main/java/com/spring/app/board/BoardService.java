// src/main/java/com/spring/app/board/BoardService.java
package com.spring.app.board;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.app.board.comment.CommentVO;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.home.util.Pager;

public interface BoardService {

    // 게시글 목록
    List<BoardVO> getList(Pager pager) throws Exception;

    // 게시글 상세
    BoardVO getDetail(BoardVO boardVO) throws Exception;

    // 게시글 등록 (첨부파일 최대 5개)
    int add(BoardVO boardVO, MultipartFile[] files) throws Exception;

    // 게시글 수정
    int update(BoardVO boardVO) throws Exception;

    // 게시글 삭제
    int delete(BoardVO boardVO) throws Exception;

    // 조회수 증가
    void hitUpdate(BoardVO boardVO) throws Exception;

    // 첨부파일 조회/다운로드
    List<BoardFileVO> getFileList(BoardVO boardVO) throws Exception;
    BoardFileVO      getFileDetail(BoardFileVO fileVO) throws Exception;
    int              deleteFile(BoardFileVO fileVO) throws Exception;

    // 좋아요
    int   addInteraction(InteractionVO interactionVO) throws Exception;
    int   removeInteraction(InteractionVO interactionVO) throws Exception;
    Long  getInteractionCount(BoardVO boardVO) throws Exception;
    boolean isLiked(Long boardNum, String userName) throws Exception;

    // 댓글
    int             addComment(CommentVO commentVO) throws Exception;
    List<CommentVO> getCommentList(BoardVO boardVO) throws Exception;
    int             deleteComment(CommentVO commentVO) throws Exception;


    // 비밀글
    int     updateSecret(BoardVO boardVO) throws Exception;
    boolean checkSecret(BoardVO boardVO)   throws Exception;
   
    //비밀글 검증
    boolean validateSecret(BoardVO boardVO) throws Exception;
}
