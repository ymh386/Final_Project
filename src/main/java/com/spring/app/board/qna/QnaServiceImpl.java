// QnaServiceImpl.java
package com.spring.app.board.qna;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class QnaServiceImpl implements QnaService {

    @Autowired
    private QnaDAO qnaDAO;

    /** 원글 작성 */
    @Override
    public void write(QnaVO vo) throws Exception {
        vo.setBoardDepth(0L);
        vo.setBoardStep(0L);
        vo.setBoardRef(0L);
        qnaDAO.insertQna(vo);
        // MyBatis useGeneratedKeys로 boardNum이 채워진 후:
        vo.setBoardRef(vo.getBoardNum());
    }

    /** 답글 작성 */
    @Override
    @Transactional
    public void reply(QnaVO vo) throws Exception {
        Long parentRef   = vo.getBoardRef();
        Long parentStep  = vo.getBoardStep();
        Long parentDepth = vo.getBoardDepth();

        vo.setBoardRef(parentRef);
        vo.setBoardStep(parentStep);
        vo.setBoardDepth(parentDepth);
        qnaDAO.updateStepForReply(vo);

        vo.setBoardStep(parentStep + 1);
        vo.setBoardDepth(parentDepth + 1);
        qnaDAO.insertQna(vo);
    }

    /** 페이징된 목록 조회 */
    @Override
    public Map<String, Object> getList(int page, int pageSize) throws Exception {
        int total = qnaDAO.selectQnaCount();
        int offset = (page - 1) * pageSize;
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("limit", pageSize);
        List<QnaVO> list = qnaDAO.selectQnaList(params);
        Map<String, Object> result = new HashMap<>();
        result.put("total", total);
        result.put("list", list);
        return result;
    }

    /** 특정 글 상세 조회 */
    @Override
    public QnaVO getById(Long boardNum) throws Exception {
        return qnaDAO.selectQnaById(boardNum);
    }

    /** 글 수정 */
    @Override
    public void modify(QnaVO vo) throws Exception {
        qnaDAO.updateQna(vo);
    }

    /** 글 삭제 */
    @Override
    public void remove(Long boardNum) throws Exception {
        qnaDAO.deleteQna(boardNum);
    }
}
