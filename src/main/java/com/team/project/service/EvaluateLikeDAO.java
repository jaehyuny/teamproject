package com.team.project.service;

import com.team.project.entities.EvaluateLike;

public interface EvaluateLikeDAO {

	/**
	 * 같은 회원이 그 게시글에 이미 평가를 했는지 확인합니다.
	 * @param evaluatelike - code와  userid만을 사용하여 확인합니다.
	 * @return 이미 평가했다면 1이상, 아니라면 0이 반환됩니다.
	 * @author : 김영호
	 * @date : 2018. 8. 24. 오후 2:29:24
	*/
	public EvaluateLike duplicateCheck(EvaluateLike evaluatelike);

	/**
	 * 평가를 추가합니다.
	 * @param evaluatelike 싹다 담으세요
	 * @author : 김영호
	 * @date : 2018. 8. 24. 오후 2:31:05
	*/
	public void insert(EvaluateLike evaluatelike);
	/**
	 * 평가를 취소합니다.
	 * @param code와 userid만 담으세요
	 * @author : 김영호
	 * @date : 2018. 8. 24. 오후 2:31:05
	*/
	public void delete(EvaluateLike evaluatelike);
	/**
	 * 특정 유저가 했던 평가를 다른것으로 바꿉니다. (좋아요->싫어요 또는 싫어요->좋아요) 예를들어
	 * 특정 유저가 한 특정 평가에 대해, 인자로 받은 eval값이 '좋아요'이면
	 *  db에서 좋아요카운트를 1 제거하고 싫어요 카운트를 1 올리며 기존 evaluatelike의 eval을 '싫어요'로 수정합니다.
	 *  인자로 받은 값이 그 반대일경우 반대로 수행합니다.
	 * @param evaluateLike
	 * @author : 김영호
	 * @date : 2018. 8. 27. 오전 9:47:34
	 */
	public void toggleBothLikeAndDislike(EvaluateLike evaluateLike);

}
