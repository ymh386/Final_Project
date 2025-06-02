package com.spring.app.board.qna;

import java.sql.Date;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class QnaVO {
    /** PK */
    private Long boardNum;
    /** 작성자(회원ID) */
    private String userName;
    /** 글 제목 */
    private String boardTitle;
    /** 작성일 */
    private Date boardDate;
    /** 글 내용 */
    private String boardContents;
    /** 답글 깊이 */
    private Long boardDepth;
    /** 참조 글번호 */
    private Long boardRef;
    /** 순서 */
    private Long boardStep;
    /** 비밀글 여부 (0/1) */
    private Integer isSecret;
}
