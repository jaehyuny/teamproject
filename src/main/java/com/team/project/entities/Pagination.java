package com.team.project.entities;


import lombok.Data;

@Data
public class Pagination {
	
	private int pageSize = 10;
	private int rangeSize = 10;
	private int curPage = 1;
	private int curRange = 1;
	private int listCount;
	private int pageCount;
	private int rangeCount;
	private int startPage = 1;
	private int endPage = 1;
	private int startIndex = 0;
	private int prevPage;
	private int nextPage;
	
	public Pagination(int listCount, int curPage) {
		/*현재 페이지*/
		setCurPage(curPage);
		/*총 게시물 수*/
		setListCount(listCount);
		/*총 페이지 수*/
		setPageCount(listCount);
		/*총 블럭 수*/
		setRangeCount(pageCount);
		/*블럭 세팅*/
		rangeSetting(curPage);
		setStartIndex(curPage);
	}
	public void setPageCount(int listCount) {
		this.pageCount = (int) Math.ceil(listCount*1.0/pageSize);
	}
	public void setRangeCount(int pageCount) {
		this.rangeCount = (int) Math.ceil(pageCount*1.0/rangeSize);	
	}
	public void rangeSetting(int curPage) {
		setCurPage(curPage);
		this.startPage = (curRange - 1) * rangeSize + 1;
		this.endPage = startPage + rangeSize - 1;
		if(endPage > pageCount) {
			this.endPage = pageCount;
		}
		this.prevPage = curPage - 1;
		this.nextPage = curPage + 1;
	}
	public void setCurRange(int curPage) {
		this.curRange = (int)((curPage-1)/rangeSize) + 1;
	}
	public void setStartIndex(int curPage) {
		this.startIndex = (curPage-1) * pageSize;
	}
}


