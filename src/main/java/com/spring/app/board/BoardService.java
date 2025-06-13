package com.spring.app.board;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;
import com.spring.app.home.util.Pager;
import com.spring.app.board.comment.CommentVO;
import com.spring.app.board.interaction.InteractionVO;

public interface BoardService {

    /** 1) 전체 게시글 수 조회 */
    long getTotalCount(Pager pager) throws Exception;

    /** 2) 페이징된 게시글 목록 조회 */
    List<BoardVO> getList(Pager pager) throws Exception;

    /** 3) 상세 조회 */
    BoardVO getDetail(BoardVO boardVO) throws Exception;

    /** 4) 글 작성 (첨부파일 포함) */
    int add(BoardVO boardVO, MultipartFile[] files) throws Exception;

    /** 5) 글 수정 */
    int update(BoardVO boardVO) throws Exception;

    /** 6) 글 삭제 */
    int delete(BoardVO boardVO) throws Exception;

    /** 7) 조회수 증가 */
    void hitUpdate(BoardVO boardVO) throws Exception;

    /** 8) 첨부파일 목록 조회 */
    List<BoardFileVO> getFileList(BoardVO boardVO) throws Exception;

    /** 9) 첨부파일 상세 조회 */
    BoardFileVO getFileDetail(BoardFileVO fileVO) throws Exception;

    /** 10) 첨부파일 삭제 */
    int deleteFile(BoardFileVO fileVO) throws Exception;

    /** 11) 좋아요 추가 */
    int addInteraction(InteractionVO vo) throws Exception;

    /** 12) 좋아요 삭제 */
    int removeInteraction(InteractionVO vo) throws Exception;

    /** 13) 좋아요 개수 조회 */
    long getInteractionCount(InteractionVO vo) throws Exception;

    /** 14) 좋아요 여부 확인 */
    boolean isLiked(InteractionVO vo) throws Exception;

    /** 15) 댓글 추가 */
    int addComment(CommentVO vo) throws Exception;

    /** 16) 댓글 목록 조회 */
    List<CommentVO> getCommentList(BoardVO boardVO) throws Exception;

    /** 17) 댓글 삭제 */
    int deleteComment(CommentVO vo) throws Exception;

    /** 18) 비밀글 설정 변경 */
    int updateSecret(BoardVO boardVO) throws Exception;

    /** 19) 비밀글 여부 확인 */
    boolean checkSecret(BoardVO boardVO) throws Exception;

    /** 20) 비밀글 비밀번호 검증 */
    boolean validateSecret(BoardVO boardVO) throws Exception;
}
