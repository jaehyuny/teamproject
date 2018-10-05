package com.team.project.entities;

import java.sql.Date;
import java.sql.Timestamp;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Buyrequest {
	private int code;
	private String buyerid;
	private String state;
	private Timestamp completeday;
	private int usedpoint;
	private int couponcode;
	private int finalprice;
	private String returnfinance;
	private String returnbank;
	private String receiverphone;
	private String receivertell;
	private String postno;
	private String address1;
	private String address2;
	private String receivername;
	private String bookname;
	private int getpoint;
	private int shippingprice;
	private Date time;
	
	/* 잔여 포인트 계산을 위한 변수 */
	private int stackpoint;
	/* 결제금액을 위한 변수 */
	private int pay;
	/* 작가 이름, 출판사 정보, 책 가격 */
	private String authorname;
	private String publisher;
	private int realprice;
	/* 총 주문결제액 및 3개월 주문결제액*/
	private int totalsum;
	private int threemonthsum;
	/* 책 수량 정보 표시*/
	private int amount;
	
	
}
