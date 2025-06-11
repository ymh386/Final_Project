// src/main/java/com/spring/app/home/util/Pager.java
package com.spring.app.home.util;

public class Pager {
    // 현재 페이지 번호 (1부터 시작)
    private int curPage = 1;
    // 페이지당 보여줄 게시글 개수
    private int perPage = 10;
    // 블록당 보여줄 페이지 번호 개수
    private int perBlock = 5;

    // 검색 기능용
    private String searchField;
    private String searchWord;

    // DB 쿼리용
    private int startRow;
    private int pageSize;

    // 화면 네비게이션용
    private long totalCount;
    private int totalPage;
    private int startPage;
    private int lastPage;

    // 추가: 이전/다음 블록 존재 여부
    private boolean prev;
    private boolean next;

    public Pager() {}

    /** makeRow: LIMIT 절에 사용할 startRow, pageSize 계산 */
    public void makeRow() {
        this.pageSize = this.perPage;
        this.startRow = (this.curPage - 1) * this.perPage;
    }

    /**
     * makePage: totalCount 기반으로
     * totalPage, startPage, lastPage, prev, next 계산
     */
    public void makePage(long totalCount) {
        this.totalCount = totalCount;
        // 총 페이지 수
        this.totalPage = (int) ((totalCount + perPage - 1) / perPage);

        // 현재 블록의 시작/끝 페이지
        this.startPage = ((curPage - 1) / perBlock) * perBlock + 1;
        this.lastPage  = startPage + perBlock - 1;
        if (lastPage > totalPage) {
            lastPage = totalPage;
        }

        // 이전/다음 블록 플래그
        this.prev = startPage > 1;
        this.next = lastPage  < totalPage;
    }

    // === getters & setters ===

    public int getCurPage() { return curPage; }
    public void setCurPage(int curPage) { this.curPage = curPage; }

    public int getPerPage() { return perPage; }
    public void setPerPage(int perPage) { this.perPage = perPage; }

    public int getPerBlock() { return perBlock; }
    public void setPerBlock(int perBlock) { this.perBlock = perBlock; }

    public int getStartRow() { return startRow; }
    public int getPageSize() { return pageSize; }

    public long getTotalCount() { return totalCount; }
    public int getTotalPage() { return totalPage; }

    public int getStartPage() { return startPage; }
    public int getLastPage()  { return lastPage;  }

    // JSP에서 ${pager.endPage} 로 쓰는 경우를 위한 alias
    public int getEndPage()   { return lastPage;  }

    public boolean isPrev() { return prev; }
    public boolean isNext() { return next; }

    public String getSearchField() { return searchField; }
    public void setSearchField(String searchField) { this.searchField = searchField; }

    public String getSearchWord() { return searchWord; }
    public void setSearchWord(String searchWord) { this.searchWord = searchWord; }
}
