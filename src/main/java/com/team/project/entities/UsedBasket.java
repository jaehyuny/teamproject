/**
 * 
 */
package com.team.project.entities;

import java.sql.Date;

import lombok.Data;

/**
 * 중고거래에 관한 사용자의 장바구니 테이블입니다.
 * @author : 김영호
 * @date : 2018. 8. 29. 오전 9:15:59
*/
@Data
public class UsedBasket {
	String userid;
	int amount;
	int usedsellcode;
	
	//기타
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
}
