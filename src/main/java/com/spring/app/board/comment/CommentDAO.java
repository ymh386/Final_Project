package com.spring.app.board.comment;

import java.util.*;
import org.springframework.stereotype.Repository;

@Repository
public class CommentDAO {

    // DB에서 단순 리스트 가져오는 쿼리 - 실제 DB 쿼리 매퍼에서 구현
    public List<CommentVO> selectByBoardNum(Long boardNum) {
        // 예시 - MyBatis 매퍼에서 SELECT * FROM COMMENTS WHERE BOARD_NUM = #{boardNum} ORDER BY COMMENT_DATE ASC
        return new ArrayList<>(); // 실제 쿼리 결과 반환
    }

    // 댓글 리스트 계층구조로 만드는 메서드 (컨트롤러 또는 서비스에서 호출)
    public List<CommentVO> getCommentsTree(Long boardNum) {
        List<CommentVO> allComments = selectByBoardNum(boardNum);

        Map<Long, CommentVO> commentMap = new HashMap<>();
        List<CommentVO> rootComments = new ArrayList<>();

        for (CommentVO c : allComments) {
            commentMap.put(c.getCommentNum(), c);
        }

        for (CommentVO c : allComments) {
            if (c.getParentCommentNum() == null) {
                rootComments.add(c);
            } else {
                CommentVO parent = commentMap.get(c.getParentCommentNum());
                if (parent != null) {
                    if (parent.getChildComments() == null) {
                        parent.setChildComments(new ArrayList<>());
                    }
                    parent.getChildComments().add(c);
                } else {
                    // 부모가 없으면 루트로 처리 (안정성용)
                    rootComments.add(c);
                }
            }
        }
        return rootComments;
    }


    // 댓글 삭제 (작성자 혹은 관리자)
    int deleteComment(CommentVO commentVO) throws Exception {
    	int result = deleteComment(commentVO);
    	
    	return result;
    };
    
    void addReplyComment(CommentVO commentVO) throws Exception{
    }

}