// InteractionVO.java
package com.spring.app.board.interaction;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class InteractionVO {
    private String userName;  // 좋아요 누른 사용자
    private Long boardNum;    // 게시글 번호
}
