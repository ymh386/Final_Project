package com.spring.app.home.util;

public class Pager {
    // 현재 페이지 번호 (1부터 시작)
    private int curPage = 1;
    // 페이지당 보여줄 게시글 개수
    private int perPage = 10;
    // 블록당 보여줄 페이지 번호 개수 (예: [1][2][3][4][5] 다음...)
    private int perBlock = 5;

    // DB 쿼리용
    private int startRow;   // LIMIT #{startRow}, #{perPage} 에서 startRow
    private int pageSize;   // LIMIT #{startRow}, #{pageSize} 에서 pageSize (= perPage)

    // 화면 네비게이션용
    private long totalCount; // 총 게시글 수
    private int totalPage;   // 총 페이지 수
    private int startPage;   // 시작 페이지 번호
    private int lastPage;    // 끝 페이지 번호

    // 기본 생성자, getter / setter 생략…

    /** makeRow: DB 쿼리에 사용할 startRow, pageSize 계산 */
    public void makeRow() {
        this.pageSize = this.perPage;
        this.startRow = (this.curPage - 1) * this.perPage;
    }

    /**
     * makePage: totalCount를 기반으로
     * totalPage, startPage, lastPage 계산
     */
    public void makePage(long totalCount) {
        this.totalCount = totalCount;
        // 총 페이지 수
        this.totalPage = (int) ((totalCount + perPage - 1) / perPage);

        // 현재 블록의 시작 페이지 번호
        this.startPage = ((curPage - 1) / perBlock) * perBlock + 1;
        // 블록의 마지막 페이지 번호
        this.lastPage = startPage + perBlock - 1;
        if (lastPage > totalPage) {
            lastPage = totalPage;
        }
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
    public int getLastPage() { return lastPage; }
}
