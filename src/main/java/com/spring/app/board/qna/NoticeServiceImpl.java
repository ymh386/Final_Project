package com.spring.app.board.qna;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.home.util.Pager;

@Service
@Transactional(rollbackFor = Exception.class)
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private NoticeDAO noticeDAO;

    @Override
    public List<NoticeVO> getList(Pager pager) throws Exception {
        pager.makeRow();
        pager.makePage(noticeDAO.getTotalCount(pager));
        return noticeDAO.getList(pager);
    }

    @Override
    public NoticeVO getDetail(NoticeVO noticeVO) throws Exception {
        return noticeDAO.getDetail(noticeVO);
    }

    @Override
    public int add(NoticeVO noticeVO) throws Exception {
        return noticeDAO.add(noticeVO);
    }

    @Override
    public int update(NoticeVO noticeVO) throws Exception {
        return noticeDAO.update(noticeVO);
    }

    @Override
    public int delete(NoticeVO noticeVO) throws Exception {
        return noticeDAO.delete(noticeVO);
    }

    // ← Missing override added here
    @Override
    public void hitUpdate(NoticeVO noticeVO) throws Exception {
        noticeDAO.hitUpdate(noticeVO);
    }
}
