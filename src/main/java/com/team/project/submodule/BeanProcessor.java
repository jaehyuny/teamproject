/**
 * 
 */
package com.team.project.submodule;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.team.project.entities.Board;
import com.team.project.entities.BoardLike;
import com.team.project.entities.BookEvaluate;
import com.team.project.entities.EvaluateLike;
import com.team.project.service.BoardLikeDAO;
import com.team.project.service.EvaluateLikeDAO;

/**
 * 특정한 자바 빈에 대해 어떠한 가공 처리를 해야 할때 자주 사용되는 메서드를 모아놓은 클래스입니다.
 * @author : 김영호
 * @date : 2018. 8. 27. 오전 11:03:10
*/
@Component
public class BeanProcessor {
	@Autowired
	SqlSession session;
	/**
	 * 특정한 BookEvaluate 빈의 userlike 필드에 특정 유저의 좋아요/싫어요 정보를 삽입합니다.
	 * @param bookEvaluate 삽입할 bookevaluate 빈입니다.
	 * @param userid 확인할 유저입니다. 이 유저가 해당 평가에 좋아요를 했는지, 싫어요를 했는지 알아내어 저장합니다. 평가정보가 없다면 아무것도 저장하지 않습니다.
	 * @author : 김영호
	 * @date : 2018. 8. 27. 오전 11:07:14
	 */
	public void addUserLikeDataToBookEvaluate(BookEvaluate bookEvaluate,String userid){
		EvaluateLikeDAO evaluateLikeDAO = session.getMapper(EvaluateLikeDAO.class);
		EvaluateLike evaluatelike = new EvaluateLike();
		evaluatelike.setUserid(userid);
		evaluatelike.setEvaluatecode(bookEvaluate.getCode());
		evaluatelike = evaluateLikeDAO.duplicateCheck(evaluatelike);
		if(evaluatelike != null) {
			bookEvaluate.setUserlike(evaluatelike.getEval());
		}
	}
	
	/**
	 * 특정한 Board 빈의 userlike 필드에 특정 유저의 좋아요/싫어요 정보를 삽입합니다.
	 * @param board 삽입할 board 빈입니다.
	 * @param userid 확인할 유저입니다. 이 유저가 해당 평가에 좋아요를 했는지, 싫어요를 했는지 알아내어 저장합니다. 평가정보가 없다면 아무것도 저장하지 않습니다.
	 * @author : 김영호
	 * @date : 2018. 8. 27. 오전 11:07:14
	 */
	public void addUserLikeDataToBoard(Board board,String userid){
		BoardLikeDAO boardLikeDAO = session.getMapper(BoardLikeDAO.class);
		BoardLike boardlike = new BoardLike();
		boardlike.setUserid(userid);
		boardlike.setBoardcode(board.getCode());
		boardlike.setBoardname(board.getBoardname());
		boardlike = boardLikeDAO.duplicateCheck(boardlike);
		if(boardlike != null) {
			board.setUserlike(boardlike.getEval());
		}
	}

}
