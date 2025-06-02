package com.spring.app.board;

import java.util.List;

import com.spring.app.board.comment.CommentVO;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.home.util.Pager;

public interface BoardDAO {

    // 게시글 전체 개수 조회
    public Long getTotalCount(Pager pager) throws Exception;

    // 게시글 목록 조회 (페이징 처리)
    public List<BoardVO> getList(Pager pager) throws Exception;

    // 게시글 상세 조회
    public BoardVO getDetail(BoardVO boardVO) throws Exception;

    // 게시글 등록
    public int add(BoardVO boardVO) throws Exception;

    // 게시글 수정
    public int update(BoardVO boardVO) throws Exception;

    // 게시글 삭제(작성자 혹은 관리자가 Service에서 검증 후 호출)
    public int delete(BoardVO boardVO) throws Exception;

    // 조회수 증가
    public int hitUpdate(BoardVO boardVO) throws Exception;

    // 첨부파일 등록
    public int addFile(BoardFileVO boardFileVO) throws Exception;

    // 게시글 첨부파일 목록 조회
    public List<BoardFileVO> getFileList(BoardVO boardVO) throws Exception;

    // 첨부파일 상세 조회
    public BoardFileVO getFileDetail(BoardFileVO boardFileVO) throws Exception;

    // 첨부파일 삭제
    public int deleteFile(BoardFileVO boardFileVO) throws Exception;

    // 좋아요 추가
    public int addInteraction(InteractionVO interactionVO) throws Exception;

    // 좋아요 삭제
    public int removeInteraction(InteractionVO interactionVO) throws Exception;

    // 좋아요 개수 조회
    public Long getInteractionCount(BoardVO boardVO) throws Exception;
    
    // ⭐️ 좋아요 중복 여부 확인 (추가!)
    int isLiked(InteractionVO interactionVO) throws Exception;
    
    // 댓글 추가
    public int addComment(CommentVO commentVO) throws Exception;

    // 댓글 목록 조회
    public List<CommentVO> getCommentList(BoardVO boardVO) throws Exception;

    // 댓글 삭제
    public int deleteComment(CommentVO commentVO) throws Exception;


    // 🔒 비밀글 여부 설정
    int updateSecret(BoardVO boardVO) throws Exception;

    // 🔒 비밀글 여부 확인 (상세 조회시 활용)
    boolean checkSecret(BoardVO boardVO) throws Exception;
}
