package com.spring.app.board.notice;

import java.util.List;
import com.spring.app.home.util.Pager;

public interface NoticeService {
    List<NoticeVO> getList(Pager pager) throws Exception;
    NoticeVO getDetail(NoticeVO noticeVO) throws Exception;
    int add(NoticeVO noticeVO) throws Exception;
    int update(NoticeVO noticeVO) throws Exception;
    int delete(NoticeVO noticeVO) throws Exception;
    void hitUpdate(NoticeVO noticeVO) throws Exception;
}