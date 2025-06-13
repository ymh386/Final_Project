// src/main/java/com/spring/app/board/BoardServiceImpl.java
package com.spring.app.board;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.spring.app.board.comment.CommentVO;
import com.spring.app.board.interaction.InteractionVO;
import com.spring.app.home.util.Pager;
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
    public long getTotalCount(Pager pager) throws Exception {
        return boardDAO.getTotalCount(pager);
    }

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
            InteractionVO iq = new InteractionVO();
            iq.setBoardNum(boardVO.getBoardNum());
            iq.setType("LIKE");
            vo.setLikeCount(boardDAO.getInteractionCount(iq));
        }
        return vo;
    }

    @Override
    public int add(BoardVO boardVO, MultipartFile[] files) throws Exception {
        int result = boardDAO.add(boardVO);
        if (result > 0 && files != null && fileManager != null) {
            for (MultipartFile f : files) {
                if (f == null || f.isEmpty()) continue;
                String fileName = fileManager.saveFile(filePath, f);
                BoardFileVO fileVO = new BoardFileVO();
                fileVO.setBoardNum(boardVO.getBoardNum());
                fileVO.setFileName(fileName);
                fileVO.setOldName(f.getOriginalFilename());
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

    public void hitUpdate(BoardVO boardVO) throws Exception {
        boardDAO.updateBoardHits(boardVO.getBoardNum());
    }

    public List<BoardFileVO> getFileList(BoardVO boardVO) throws Exception {
        return boardDAO.getFileList(boardVO);
    }

    public BoardFileVO getFileDetail(BoardFileVO fileVO) throws Exception {
        return boardDAO.getFileDetail(fileVO);
    }

    public int deleteFile(BoardFileVO fileVO) throws Exception {
        return boardDAO.deleteFile(fileVO);
    }

    public int addInteraction(InteractionVO vo) throws Exception {
        int cnt = boardDAO.addInteraction(vo);
        boardDAO.increaseLikeCount(vo.getBoardNum());
        return cnt;
    }

    public int removeInteraction(InteractionVO vo) throws Exception {
        int cnt = boardDAO.removeInteraction(vo);
        boardDAO.decreaseLikeCount(vo.getBoardNum());
        return cnt;
    }

    public long getInteractionCount(InteractionVO vo) throws Exception {
        return boardDAO.getInteractionCount(vo);
    }

    public boolean isLiked(InteractionVO vo) throws Exception {
        return boardDAO.isLiked(vo);
    }

    @Override
    public int addComment(CommentVO vo) throws Exception {
        int cnt = boardDAO.addComment(vo);
        boardDAO.increaseCommentCount(vo.getBoardNum());
        return cnt;
    }

    @Override
    public List<CommentVO> getCommentList(BoardVO boardVO) throws Exception {
        return boardDAO.getCommentList(boardVO);
    }

    @Override
    public int deleteComment(CommentVO vo) throws Exception {
        int cnt = boardDAO.deleteComment(vo);
        boardDAO.decreaseCommentCount(vo.getBoardNum());
        return cnt;
    }

    public int updateSecret(BoardVO boardVO) throws Exception {
        return boardDAO.updateSecret(boardVO);
    }

    public boolean checkSecret(BoardVO boardVO) throws Exception {
        return boardDAO.checkSecret(boardVO);
    }

    public boolean validateSecret(BoardVO boardVO) throws Exception {
        BoardVO stored = boardDAO.getDetail(boardVO);
        return stored != null
            && stored.getSecretPassword() != null
            && stored.getSecretPassword().equals(boardVO.getSecretPassword());
    }
}
