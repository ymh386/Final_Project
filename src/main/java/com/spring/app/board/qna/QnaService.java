// QnaService.java
package com.spring.app.board.qna;

import java.util.Map;

public interface QnaService {
    /** 원글 작성 */
    void write(QnaVO vo) throws Exception;

    /** 답글 작성 */
    void reply(QnaVO vo) throws Exception;
    
    /** 답글 작성 전 같은 그룹 내 step 밀어내기 */
    void updateStepForReply(Long boardRef, Long boardStep) throws Exception;

    /** 페이징된 목록 조회 */
    Map<String, Object> getList(int page, int pageSize) throws Exception;

    /** 특정 글 상세 조회 */
    QnaVO getById(Long boardNum) throws Exception;

    /** 글 수정 */
    void modify(QnaVO vo) throws Exception;

    /** 글 삭제 */
    void remove(Long boardNum) throws Exception;
}
