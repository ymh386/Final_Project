package com.spring.app.files;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

import com.spring.app.board.BoardFileVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component("fileDownView")
public class FileDownView extends AbstractView {

    /** application.properties 에 설정된 업로드 기본 경로 */
    @Value("${board.file.path}")
    private String filePath;  // 예: D:/upload/

    public FileDownView() {
        // 다운로드용 바이너리 스트림으로 설정
        setContentType("application/octet-stream");
    }

    @Override
    protected void renderMergedOutputModel(
            Map<String, Object> model,
            HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        // Controller 에서 model.addAttribute("fileVO", fileVO) 로 넘겨준 객체
        BoardFileVO fileVO = (BoardFileVO) model.get("fileVO");

        // 실제 저장된 파일 위치 (filePath + newName)
        File file = new File(filePath, fileVO.getNewName());

        // 1) 응답 헤더: 컨텐츠 타입 & 길이
        response.setContentType(getContentType());
        response.setContentLengthLong(file.length());

        // 2) 원본 파일명 인코딩
        String oriName = fileVO.getOriName();
        String encodedName = URLEncoder.encode(oriName, "UTF-8").replaceAll("\\+", "%20");

        // 3) 다운로드 헤더 설정
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedName + "\";");
        response.setHeader("Content-Transfer-Encoding", "binary");

        // 4) 파일 읽어서 스트림으로 복사
        try ( FileInputStream fis = new FileInputStream(file);
              OutputStream os   = response.getOutputStream() ) {
            FileCopyUtils.copy(fis, os);
        }
    }
}
