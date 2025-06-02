// src/main/java/com/spring/app/board/BoardServiceImpl.java
package com.spring.app.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.spring.app.home.util.Pager;
import com.spring.app.board.comment.CommentVO;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.files.FileManager;

@Service
@Transactional(rollbackFor = Exception.class)
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardDAO boardDAO;

    @Autowired(required = false)
    private FileManager fileManager;

    @Value("${board.file.path:/upload}")
    private String filePath;

    @Override
    public List<BoardVO> getList(Pager pager) throws Exception {
        return boardDAO.getList(pager);
    }

    @Override
    public BoardVO getDetail(BoardVO boardVO) throws Exception {
        BoardVO vo = boardDAO.getDetail(boardVO);
        if (vo != null) {
            vo.setBoardFileVOs(boardDAO.getFileList(boardVO));
            vo.setCommentVOs(boardDAO.getCommentList(boardVO));
            vo.setLikeCount(boardDAO.getInteractionCount(boardVO));
            
        }
        return vo;
    }

    @Override
    public int add(BoardVO boardVO, MultipartFile[] files) throws Exception {
        int result = boardDAO.add(boardVO);
        if (result > 0 && files != null && fileManager != null) {
            for (int i = 0; i < files.length && i < 5; i++) {
                MultipartFile f = files[i];
                if (f == null || f.isEmpty()) continue;
                String newName = fileManager.saveFile(filePath, f);
                BoardFileVO fileVO = new BoardFileVO();
                fileVO.setBoardNum(boardVO.getBoardNum());
                fileVO.setOriName(f.getOriginalFilename());
                fileVO.setNewName(newName);
                fileVO.setFilePath(filePath);
                fileVO.setFileSize(f.getSize());
                boardDAO.addFile(fileVO);
            }
        }
        return result;
    }

    @Override
    public int update(BoardVO boardVO) throws Exception {
        return boardDAO.update(boardVO);
    }

    @Override
    public int delete(BoardVO boardVO) throws Exception {
        return boardDAO.delete(boardVO);
    }

    @Override
    public void hitUpdate(BoardVO boardVO) throws Exception {
        boardDAO.hitUpdate(boardVO);
    }

    @Override
    public List<BoardFileVO> getFileList(BoardVO boardVO) throws Exception {
        return boardDAO.getFileList(boardVO);
    }

    @Override
    public BoardFileVO getFileDetail(BoardFileVO fileVO) throws Exception {
        return boardDAO.getFileDetail(fileVO);
    }

    @Override
    public int deleteFile(BoardFileVO fileVO) throws Exception {
        return boardDAO.deleteFile(fileVO);
    }

    // 좋아요 기능
    @Override
    public int addInteraction(InteractionVO vo) throws Exception {
        if (boardDAO.isLiked(vo) > 0) return 0;
        return boardDAO.addInteraction(vo);
    }

    @Override
    public int removeInteraction(InteractionVO vo) throws Exception {
        return boardDAO.removeInteraction(vo);
    }

    @Override
    public Long getInteractionCount(BoardVO boardVO) throws Exception {
        return boardDAO.getInteractionCount(boardVO);
    }

    @Override
    public boolean isLiked(Long boardNum, String userName) throws Exception {
        InteractionVO vo = new InteractionVO();
        vo.setBoardNum(boardNum);
        vo.setUserName(userName);
        return boardDAO.isLiked(vo) > 0;
    }

    // 댓글 기능
    @Override
    public int addComment(CommentVO vo) throws Exception {
        return boardDAO.addComment(vo);
    }

    @Override
    public List<CommentVO> getCommentList(BoardVO boardVO) throws Exception {
        return boardDAO.getCommentList(boardVO);
    }

    @Override
    public int deleteComment(CommentVO vo) throws Exception {
        return boardDAO.deleteComment(vo);
    }



    // 비밀글 기능
    @Override
    public int updateSecret(BoardVO boardVO) throws Exception {
        return boardDAO.updateSecret(boardVO);
    }

    @Override
    public boolean checkSecret(BoardVO boardVO) throws Exception {
        return boardDAO.checkSecret(boardVO);
    }
    @Override
    public boolean validateSecret(BoardVO boardVO) throws Exception {
        // DB에서 원본 비밀번호 가져오기
        BoardVO stored = boardDAO.getDetail(boardVO);
        if (stored == null || stored.getSecretPassword() == null) return false;
        // VO에 담긴 secretPassword 필드와 비교
        return stored.getSecretPassword().equals(boardVO.getSecretPassword());
    }
}
