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
    public int update(BoardVO boardVO, MultipartFile[] files) throws Exception {
        // 파일 처리 로직 필요시 구현
        return boardDAO.update(boardVO);
    }

    @Override
    public int delete(BoardVO boardVO) throws Exception {
        return boardDAO.delete(boardVO);
    }

    @Override
    public void hitUpdate(BoardVO boardVO) throws Exception {
        System.out.println("조회수 증가 boardNum = " + boardVO.getBoardNum());
        boardDAO.updateBoardHits(boardVO.getBoardNum());
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

    @Override
    public int addInteraction(InteractionVO vo) throws Exception {
        int cnt = boardDAO.addInteraction(vo);
        boardDAO.increaseLikeCount(vo.getBoardNum());
        return cnt;
    }

    @Override
    public int removeInteraction(InteractionVO vo) throws Exception {
        int cnt = boardDAO.removeInteraction(vo);
        boardDAO.decreaseLikeCount(vo.getBoardNum());
        return cnt;
    }

    @Override
    public long getInteractionCount(InteractionVO vo) throws Exception {
        return boardDAO.getInteractionCount(vo);
    }

    @Override
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
    public void addReplyComment(CommentVO commentVO) throws Exception {
        // 대댓글 추가: parentCommentNum, commentDepth는 컨트롤러에서 세팅되었다고 가정
        boardDAO.addComment(commentVO);
        boardDAO.increaseCommentCount(commentVO.getBoardNum());
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
        BoardVO stored = boardDAO.getDetail(boardVO);
        return stored != null
            && stored.getSecretPassword() != null
            && stored.getSecretPassword().equals(boardVO.getSecretPassword());
    }

    @Override
    public CommentVO getCommentById(Long commentNum) throws Exception {
        return boardDAO.getCommentById(commentNum);
    }

    @Override
    public void decreaseCommentCount(Long boardNum) throws Exception {
        boardDAO.decreaseCommentCount(boardNum);
    }
}
