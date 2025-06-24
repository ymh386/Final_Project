package com.spring.app.board.comment;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommentDAO {

    // 댓글 추가
    int addComment(CommentVO commentVO) throws Exception;

    // 특정 게시글의 댓글 목록 조회
    List<CommentVO> getCommentList(CommentVO commentVO) throws Exception;

    // 댓글 삭제 (작성자 혹은 관리자)
    int deleteComment(CommentVO commentVO) throws Exception;
    
    void addReplyComment(CommentVO commentVO) throws Exception;
}
