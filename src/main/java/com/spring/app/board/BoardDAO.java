// src/main/java/com/spring/app/board/BoardDAO.java
package com.spring.app.board;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
    int updateBoardHits(@Param("boardNum") Long boardNum); // O

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

    /** 15) 좋아요 개수 조회 */
    long getInteractionCount(InteractionVO interactionVO) throws Exception;

    /** 16) 좋아요 중복 여부 확인 */
   boolean isLiked(InteractionVO interactionVO) throws Exception;
   /** 11) 좋아요 추가 */
   int addInteraction(InteractionVO vo) throws Exception;

   /** 12) 좋아요 삭제 */
   int removeInteraction(InteractionVO vo) throws Exception;

    /** 17) 좋아요 수 증가 */
    int increaseLikeCount(Long boardNum) throws Exception;

    /** 18) 좋아요 수 감소 */
    int decreaseLikeCount(Long boardNum) throws Exception;

    /** 19) 댓글 추가 */
    int addComment(CommentVO commentVO) throws Exception;

    /** 20) 댓글 목록 조회 */
    List<CommentVO> getCommentList(BoardVO boardVO) throws Exception;

    /** 21) 댓글 삭제 */
    int deleteComment(CommentVO commentVO) throws Exception;

    /** 22) 비밀글 설정(업데이트) */
    int updateSecret(BoardVO boardVO) throws Exception;

    /** 23) 비밀글 여부 확인 */
    boolean checkSecret(BoardVO boardVO) throws Exception;

    /** 24) 게시글 등록 직접 호출용 */
    void insertBoard(BoardVO vo);

	void decreaseCommentCount(Long boardNum);

	void increaseCommentCount(Long boardNum);
}
