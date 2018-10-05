package com.team.project.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.team.project.entities.BoardPaging;
import com.team.project.entities.Book;

public interface BookDAO {
	Book selectBook(int code);
	ArrayList<Book> selectAllPaging(BoardPaging boardpaging);
	ArrayList<Book> selectAll();
	void insertBook(Book book);
	void deleteBook(int code);
	void updateBook(Book book);
	int selectBookCode();
	int selectRowCount(String find);
	void updateScore(int bookcode);
	int updateSubstractStock(Book book);
	/**
	 * 책 이름으로 해당되는 모든 책을 검색합니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 3. 오전 10:33:01
	*/
	ArrayList<Book> selectBookSearchByName(String name);
	/**
	 * 특정 카테고리에 해당되는 모든 책을 가져옵니다.
	 * @param category
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 3. 오후 3:54:36
	*/
	ArrayList<Book> selectByCategory(String category);
	/**
	 * 상세한 쿼리를 통해 책을 검색해냅니다.
	 * @param parameter
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 3. 오후 4:09:27
	*/
	ArrayList<Book> selectAdvanced(HashMap<String, Object> parameter);
}
