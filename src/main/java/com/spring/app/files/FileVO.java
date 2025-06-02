package com.spring.app.files;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class FileVO {
    private Long fileNum;         // PK (파일 번호, 필요시)
    private Long boardNum;        // FK (게시글 번호)
    private String oriName;       // 원본 파일명
    private String newName;       // 실제 저장 파일명(UUID 등)
    private String filePath;      // 저장 경로
    private Long fileSize;        // 파일 크기
}
