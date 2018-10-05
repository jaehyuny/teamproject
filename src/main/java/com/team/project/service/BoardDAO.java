/**
 * 
 */
package com.team.project.service;

import java.util.ArrayList;

import com.team.project.entities.Board;
import com.team.project.entities.BoardPaging;

/**
 * 
 * @author : 김영호
 * @date : 2018. 8. 20. 오후 12:45:08
*/
public interface BoardDAO {
	public ArrayList<Board> selectByBookcodeLimited(int bookcode);
	public int countByBookcode(int bookcode);
	/* 게시판 글작성 */
	public void insertBoard(Board board);
	public void updateBoard(Board board);
	public void insertFaq(Board board);
	public void updateFaq(Board board);
	public void deleteFaq(int code);
	public void deleteByCode(Board board);
	public Board selectFaq(int code);
	public ArrayList<Board> reviewBoardList();
	public ArrayList<Board> faqList();
	public ArrayList<Board> mostFaqList();
	public ArrayList<Board> selectByBookcode(int bookcodeint);
	public ArrayList<Board> selectByBookcodeLikeTop20(int bookcodeint);
	/* 1:1문의 */
	public void insertQna(Board board);
	public ArrayList<Board> myQnaList(String userid);
	public ArrayList<Board> allQnaList();
	public void answerQna(Board board);
	/* 자유게시판 페이징&검색 */
	public ArrayList<Board> boardList(BoardPaging boardpaging);
	public int boardCount(String find);
	/* 독후감게시판 페이징&검색 */
	public ArrayList<Board> reviewList(BoardPaging boardpaging);
	public int reviewCount(String find);
	
	/**
	 * 회원정보에서 자신이 작성한 독후감 리스트 출력
	 */
	public ArrayList<Board> selectByUserid(String userid);

	/**
	 * 특정 id가 작성한 독후감의 갯수를 얻습니다.
	 * @param id 찾고자 하는 id입니다.
	 * @return  갯수를 반환합니다.
	 * @author : 불명
	 * @date : 2018. 8. 24. 오전 9:33:58
	 */
	public int countReview(String id);
	/* 게시판 글 내용 보기 */
	public Board boardDetail(Board board);
	public Board reviewDetail(Board board);
	/* 게시판 조회수 증가 */
	public void updateHit(Board board);
	/**
	 * 특정 유저가 특정 책에 대한 독후감을 중복해서 등록하는지 확인합니다.
	 * @param board 작성되지 않음
	 * @return 작성되지 않음
	 * @author : 김영호
	 * @date : 2018. 8. 23. 오후 1:41:22
	*/
	public int reviewDuplicationCheck(Board board);
	
	/**
	 * 찾고자 하는 code와 boardname이 동시에 일치하는 행을 찾습니다.
	 * @param board board 객체이지만 code, boardname에만 값을 넣어주면 됩니다.
	 * @return 일치하는 행의 모든 데이터를 담은 board를 반환합니다.
	 * @author : 김영호
	 * @date : 2018. 8. 24. 오전 9:28:24
	 */
	public Board selectByCodeAndBoardName(Board board);
	/**
	 * @param board
	 * @author : 김영호
	 * @date : 2018. 8. 24. 오후 12:26:46
	*/
	public void deleteByCodeAndBoardName(Board board);
	
	public void insertEvent(Board board);
	
	public ArrayList<Board> selectHotReview();

}
