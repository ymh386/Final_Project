// src/main/java/com/spring/app/board/interaction/InteractionController.java
package com.spring.app.board.interaction;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.spring.app.board.BoardService;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.user.UserVO;
import com.spring.app.websocket.NotificationManager;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/interaction")
public class InteractionController {

    private final BoardService boardService;

    @Autowired
    public InteractionController(BoardService boardService) {
        this.boardService = boardService;
    }
    
    

    /**
     * 좋아요 추가
     */
    @PostMapping("/like")
    @ResponseBody
    public long addLike(
        @RequestBody InteractionVO vo,
        @AuthenticationPrincipal UserVO user
    ) throws Exception {
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        vo.setUserName(user.getUsername());
        vo.setType("LIKE");
        boardService.addInteraction(vo);
        
        
        
        return boardService.getInteractionCount(vo);
    }

    /**
     * 좋아요 취소
     */
    @PostMapping("/unlike")
    @ResponseBody
    public long removeLike(
        @RequestBody InteractionVO vo,
        @AuthenticationPrincipal UserVO user
    ) throws Exception {
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        vo.setUserName(user.getUsername());
        vo.setType("LIKE");
        boardService.removeInteraction(vo);
        return boardService.getInteractionCount(vo);
    }
}
