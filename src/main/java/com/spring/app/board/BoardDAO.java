// src/main/java/com/spring/app/board/BoardDAO.java
package com.spring.app.board;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.spring.app.board.comment.CommentVO;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.home.util.Pager;

@Mapper
public interface BoardDAO {

    /** 1) 전체 게시글 수 조회 */
    long getTotalCount(Pager pager) throws Exception;

    /** 2) 페이징된 게시글 목록 조회 */
    List<BoardVO> getList(Pager pager) throws Exception;

    /** 3) 게시글 상세 조회 */
    BoardVO getDetail(BoardVO boardVO) throws Exception;

    /** 4) 게시글 등록 */
    int add(BoardVO boardVO) throws Exception;

    /** 5) 게시글 수정 */
    int update(BoardVO boardVO) throws Exception;

    /** 6) 게시글 삭제 */
    int delete(BoardVO boardVO) throws Exception;

    /** 7) 조회수 증가 */
    int hitUpdate(BoardVO boardVO) throws Exception;

    /** 8) 첨부파일 등록 */
    int addFile(BoardFileVO boardFileVO) throws Exception;

    /** 9) 첨부파일 목록 조회 */
    List<BoardFileVO> getFileList(BoardVO boardVO) throws Exception;

    /** 10) 첨부파일 상세 조회 */
    BoardFileVO getFileDetail(BoardFileVO boardFileVO) throws Exception;

    /** 11) 첨부파일 삭제 */
    int deleteFile(BoardFileVO boardFileVO) throws Exception;

    /** 12) 첨부파일 개수 조회 */
    int getFileCount(Long boardNum) throws Exception;

    /** 13) 좋아요 추가 */
    int addInteraction(InteractionVO interactionVO) throws Exception;

    /** 14) 좋아요 삭제 */
    int removeInteraction(InteractionVO interactionVO) throws Exception;

    /** 15) 좋아요 개수 조회 */
    long getInteractionCount(InteractionVO interactionVO) throws Exception;

    /** 16) 좋아요 중복 여부 확인 */
    int isLiked(InteractionVO interactionVO) throws Exception;

    /** 17) 댓글 추가 */
    int addComment(CommentVO commentVO) throws Exception;

    /** 18) 댓글 목록 조회 */
    List<CommentVO> getCommentList(BoardVO boardVO) throws Exception;

    /** 19) 댓글 삭제 */
    int deleteComment(CommentVO commentVO) throws Exception;

    /** 20) 비밀글 설정(업데이트) */
    int updateSecret(BoardVO boardVO) throws Exception;

    /** 21) 비밀글 여부 확인 */
    boolean checkSecret(BoardVO boardVO) throws Exception;
}
