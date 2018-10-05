/**
 * 
 */
package com.team.project.entities;

import org.springframework.stereotype.Component;

import lombok.Data;

/**
 * 누군가가 책에 한 평가에 대해 좋아요와 싫어요를 표시한 것을 기록하는 테이블입니다.
 * @author : 김영호
 * @date : 2018. 8. 24. 오후 1:47:49
*/
@Component
@Data
public class EvaluateLike {
	private int evaluatecode;
	private String userid;
	private String eval;
}
