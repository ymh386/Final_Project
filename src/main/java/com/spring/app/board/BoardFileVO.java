package com.spring.app.board;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardFileVO {
    /** 파일 번호 (PK) */
    private Long fileNum;

    /** 게시글 번호 (FK) */
    private Long boardNum;

    /** 저장된 파일명 */
    private String fileName;

    /** 원본 파일명 */
    private String oldName;
}
