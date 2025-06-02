// InteractionDAO.java
package com.spring.app.board.interaction;

import java.util.List;

public interface InteractionDAO {
    /** 좋아요 추가 */
    int addLike(InteractionVO interactionVO) throws Exception;

    /** 좋아요 삭제 */
    int removeLike(InteractionVO interactionVO) throws Exception;

    /** 특정 게시글의 좋아요 개수 조회 */
    Long getLikeCount(Long boardNum) throws Exception;

    /** 특정 사용자가 해당 게시글을 이미 좋아요했는지 확인 (0 = 안 했음, >0 = 했음) */
    int isLiked(InteractionVO interactionVO) throws Exception;
}
