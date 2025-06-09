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
    /** 답글 깊이 (0=원글, 1=첫번째 답글, ...) */
    private Long boardDepth;
    /** 참조 글번호 (원글의 boardNum) */
    private Long boardRef;
    /** 같은 ref 그룹 내 순서 */
    private Long boardStep;
    /** 비밀글 여부 (0=공개, 1=비밀) */
    private Integer isSecret;
}
