package com.spring.app.board.comment;

import java.sql.Timestamp;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CommentVO {
    /** PK */
    private Long commentNum;
    /** 작성자(회원ID) */
    private String userName;
    /** 게시글 번호(FK) */
    private Long boardNum;
    /** 댓글 내용 */
    private String commentContents;
    /** 작성일시 */
    private Timestamp commentDate;

    /** 부모 댓글 번호 (null이면 최상위 댓글) */
    private Long parentCommentNum;

    /** 댓글 깊이 (0=최상위, 1=대댓글, ...) */
    private int commentDepth;

    /** 자식 댓글 리스트 (대댓글들) */
    private List<CommentVO> childComments;
    
    private int likeCount;  

    // 대댓글 추가 메서드 (필요시 구현)
    public void addReplyComment(CommentVO commentVO) {
        if (this.childComments != null) {
            this.childComments.add(commentVO);
        }
    }

    private Long parentCommentNum;  // 부모 댓글 번호 (null이면 최상위 댓글)
    
    private int commentDepth;       // 댓글 깊이 (0=최상위, 1=대댓글, ...)

}
