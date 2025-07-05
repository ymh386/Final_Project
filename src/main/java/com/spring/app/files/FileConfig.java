package com.spring.app.files;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class FileConfig implements WebMvcConfigurer {

    /**  
     * application.properties 에서 지정한 업로드 디렉터리(절대경로)  
     * 예) board.file.path=D:/upload/  
     */
    @Value("${board.file.path}")
    private String filePath;

    /**  
     * 업로드 파일 URL 매핑 접두어  
     * 예) board.file.url=/files/  
     */
    @Value("${board.file.url}")
    private String fileUrl;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
    	
    	//서버거 window환경(개발서버)인지 리눅스환겅(배포서버)인지 구분
    	String os = System.getProperty("os.name").toLowerCase();
    	String resourceLocation;

    	if (os.contains("win")) {
    	    resourceLocation = "file:\\" + filePath;  // 예: C:\\goodee\\upload\\
    	} else {
    	    resourceLocation = "file:" + filePath;    // 예: /home/ubuntu/upload/
    	}
        // /files/** 요청을 D:/upload/ 로 매핑
        registry.addResourceHandler(fileUrl)
                .addResourceLocations(resourceLocation);
    }
}
