/**
 * 
 */
package com.team.project.service;

import java.util.ArrayList;

import com.team.project.entities.BookEvaluate;

/**
 * 책 평가 테이블에 관련된 DAO입니다.
 * @author : 김영호
 * @date : 2018. 8. 16. 오전 9:43:43
*/
public interface BookEvaluateDAO {
	public ArrayList<BookEvaluate> selectByBookcode(int bookcode);
	public ArrayList<BookEvaluate> selectByBookcodeLimited(int bookcode);
	public ArrayList<BookEvaluate> selectByBookcodeLimitedTop8(int bookcode);
	public int countByBookcode(int bookcode);

	/**
	 * 특정 유저가 특정 책에 대해 이미 평가했는지 검사합니다.
	 * @param bookevaluate bookcode에는 검사할 책을, userid에는 검사할 유저의 id를 입력하면 되고 그외는 사용되지 않습니다.
	 * @return 이미 평가한 기록의 갯수를 반환합니다. 0개인지 아닌지를 검사하면 됩니다.
	 * @author : 김영호
	 * @date : 2018. 8. 23. 오전 10:32:45
	 */
	public int duplicationCheck(BookEvaluate bookevaluate);

	/**
	 * DB에 새로운 평가를 추가합니다. 
	 * @param bookevaluate
	 * @author : 김영호
	 * @date : 2018. 8. 23. 오전 10:34:07
	 */
	public void insert(BookEvaluate bookevaluate);
	
	/**
	 * 회원 정보의 커뮤니티 정보를 위한 데이터 출력
	 * @param userid
	 * @return
	 */
	public ArrayList<BookEvaluate> selectByUserid(String userid);

	/**
	 * 평가코드로 평가를 찾습니다. 평가코드는 pk이므로 결과값은 반드시 1개입니다.
	 * @param code
	 * @return
	 * @author : 김영호
	 * @date : 2018. 8. 24. 오전 9:18:50
	 */
	public BookEvaluate selectByCode(int code);
	/**
	 * 평가코드에 해당하는 평가 하나를 지웁니다.
	 * @param code 삭제할 코드입니다.
	 * @author : 김영호
	 * @date : 2018. 8. 24. 오전 11:59:05
	*/
	public void deleteByCode(int code);
}
