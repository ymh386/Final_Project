package com.spring.app.board.notice;

import java.sql.Date;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class NoticeVO {
    /** PK */
    private Long boardNum;
    /** 작성자(회원ID) */
    private String userName;
    /** 글 제목 */
    private String boardTitle;
    /** 작성일 */
    private Date boardDate;
    /** 글 내용 */
    private String boardContents;
    /** 수정일 */
    private Date updateAt;
    /** 조회수 */
    private Long boardHits;

    /**
     * 관리자 여부 확인용 메서드
     * 실제 삭제 시에는 NoticeDAO.delete(...)를 호출하기 전에
     * 반드시 noticeVO.setUserName("admin") 으로 설정해야 합니다.
     */
    public boolean isAdmin() {
        return "admin".equals(this.userName);
  
    }
    
}
