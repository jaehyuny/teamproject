/**
 * 
 */
package com.team.project.entities;

import java.sql.Timestamp;

import org.springframework.stereotype.Component;

import lombok.Data;

/**
 * 
 * @author : 김영호
 * @date : 2018. 8. 16. 오전 9:44:58
*/
@Data
@Component
public class BookEvaluate {
	private int code;
	private int bookcode;
	private String userid;
	private String content;
	private int score;
	private Timestamp time;
	private int likecount;
	private int dislikecount;
	
	/*BookEvaluate에는 없지만 필요한 Component*/
	private String bookname;
	private String userlike;
}
