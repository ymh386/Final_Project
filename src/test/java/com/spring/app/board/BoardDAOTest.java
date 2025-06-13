package com.spring.app.board;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.stream.IntStream;

@SpringBootTest
public class BoardDAOTest {

    @Autowired
    private BoardDAO boardDAO;

    @Test
    void insertDummyData() {
        IntStream.rangeClosed(1, 100).forEach(i -> {
            BoardVO vo = new BoardVO();
            
            // 실제 존재하는 유저명으로 설정
            vo.setUserName("test"); 
            
            vo.setBoardTitle("테스트 제목 " + i);
            vo.setBoardContents("테스트 내용입니다. 더미 데이터 번호: " + i);
            vo.setCategory(1L);  // 카테고리도 반드시 설정해 주세요.

            boardDAO.insertBoard(vo);
        });
    }

   
}   