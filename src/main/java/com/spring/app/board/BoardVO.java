package com.spring.app.board;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

import com.spring.app.board.comment.CommentVO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardVO {
    /** PK */
    private Long boardNum;
    /** 작성자(회원ID) */
    private String userName;
    /** 글 제목 */
    private String boardTitle;
    /** 글 내용 */
    private String boardContents;
    /** 작성일 */
    private Timestamp boardDate;
    /** 수정일 */
    private Timestamp updateAt;
    /** 카테고리(FK) */
    private Long category;
    /** 비밀글 여부 */
    private Boolean isSecret;
    /** 비밀글 비밀번호 */
    private String secretPassword;    
    /** 좋아요 수 */
    private Long likeCount;
    /** 댓글 수 */
    private Long commentCount;
    /** 조회수 */
    private Long boardHits;
    /** 첨부파일 리스트 */
    private List<BoardFileVO> boardFileVOs;
    /** 댓글 리스트 */
    private List<CommentVO> commentVOs;
    // 기본 생성자
    public BoardVO() {}

    // boardNum만 받는 생성자 (필요 시)
    public BoardVO(Long boardNum) {
        this.boardNum = boardNum;
    }
    private List<BoardFileVO> fileList;
}
