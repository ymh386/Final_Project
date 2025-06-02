package com.spring.app.board.qna;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.spring.app.home.util.Pager;

@Mapper
public interface NoticeDAO {
    /**
     * 전체 공지글 개수 조회 (페이징 및 검색조건 포함)
     */
    Long getTotalCount(Pager pager) throws Exception;

    /**
     * 공지글 목록 조회 (페이징 처리, 검색조건 포함)
     */
    List<NoticeVO> getList(Pager pager) throws Exception;

    /**
     * 공지글 상세 조회
     */
    NoticeVO getDetail(NoticeVO noticeVO) throws Exception;

    /**
     * 공지글 등록
     */
    int add(NoticeVO noticeVO) throws Exception;

    /**
     * 공지글 수정
     */
    int update(NoticeVO noticeVO) throws Exception;

    /**
     * 공지글 삭제 (관리자만 가능)
     *
     * <p>삭제를 호출하기 전에 반드시 noticeVO.setUserName("admin") 으로 설정해야 실제 삭제가 실행됩니다.
     * SQL 매퍼에서는 userName이 "admin"인지 검증한 뒤, 맞을 경우에만 삭제합니다.</p>
     */
    int delete(NoticeVO noticeVO) throws Exception;

    /**
     * 조회수 증가
     */
    int hitUpdate(NoticeVO noticeVO) throws Exception;
}
