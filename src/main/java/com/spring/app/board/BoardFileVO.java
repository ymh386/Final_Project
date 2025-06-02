package com.spring.app.board;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardFileVO {
    /** PK */
    private Long fileNum;
    /** 게시글 번호(FK) */
    private Long boardNum;
    /** 원본 파일명 */
    private String oriName;
    /** 저장된 파일명 */
    private String newName;
    /** 파일 경로 */
    private String filePath;
    /** 파일 크기(byte) */
    private Long fileSize;
}
