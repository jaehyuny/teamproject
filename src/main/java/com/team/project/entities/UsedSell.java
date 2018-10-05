/**
 * 
 */
package com.team.project.entities;

import java.sql.Date;

import lombok.Data;

/**
 * 중고거래 게시글입니다.
 * @author : 김영호
 * @date : 2018. 8. 20. 오후 3:25:12
*/
@Data
public class UsedSell {
	int code;
	String sellerid;
	int bookcode;
	String bookname;
	int price;
	int stock;
	Date time;
	String discription;
	int deleted;
	String state;

	//원래없는것
	int averagescore;
	int buycount;
	int sellcount;
	
	/*usedtrade 조인시 필요한 변수*/
	Date tradetime;
	int score;
	String evaltext;
	
}
