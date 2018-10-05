/**
 * 
 */
package com.team.project.entities;

import org.springframework.stereotype.Component;

import lombok.Data;

/**
 * 특정 주문에 관한 책들을 모아놓는 테이블입니다.
 * @author : 김영호
 * @date : 2018. 8. 29. 오전 11:17:43
*/
@Component
@Data
public class BuyRequestProduct {
	int ordercode;
	int coupon;
	int bookcode;
	int usedpoint;
	int amount;
	int price;
	int finalprice;
	String bookname;
}
