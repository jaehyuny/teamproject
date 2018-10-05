/**
 * 
 */
package com.team.project.entities;

import org.springframework.stereotype.Component;

import lombok.Data;

/**
 * 누군가의 독후감에 대해 좋아요와 싫어요를 표시한 것을 기록하는 테이블입니다.
 * @author : 김영호
 * @date : 2018. 8. 27. 오후 12:00:35
*/
@Component
@Data
public class BoardLike {
	public int boardcode;
	public String boardname;
	public String userid;
	public String eval;
}
