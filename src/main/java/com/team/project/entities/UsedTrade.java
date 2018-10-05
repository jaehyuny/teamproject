/**
 * 
 */
package com.team.project.entities;

import java.sql.Date;

import lombok.Data;

/**
 * 중고거래의 주문에 관한 테이블입니다.
 * @author : 김영호
 * @date : 2018. 8. 29. 오후 3:24:52
*/
@Data
public class UsedTrade {
	int code;
	int sellerboardcode;
	String buyerid;
	String sellerid;
	int shippingprice;
	int score;
	String evaltext;
	Date evaldate;
	String state;
	String receivertell;
	String receiverphone;
	String receivername;
	String postno;
	String address1;
	String address2;
	String returnfinance;
	String returnbank;
	Date time;
	int finalprice;
	
	/* 회원정보 출력시 필요한 책이름*/
	String bookname;
}
