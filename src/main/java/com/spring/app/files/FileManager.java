package com.spring.app.files;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.UUID;

@Component
public class FileManager {

    // 파일 저장
    public String saveFile(String path, MultipartFile mf) throws Exception {
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String oriName = mf.getOriginalFilename();
        String ext = "";
        if (oriName != null && oriName.lastIndexOf(".") > -1) {
            ext = oriName.substring(oriName.lastIndexOf("."));
        }
        String uuid = UUID.randomUUID().toString();
        String newName = uuid + ext;

        File f = new File(dir, newName);
        mf.transferTo(f);

        return newName;
    }

    // 파일 삭제
    public boolean deleteFile(String path, String fileName) throws Exception {
        File f = new File(path, fileName);
        if (f.exists()) {
            return f.delete();
        }
        return false;
    }
}
