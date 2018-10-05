package com.team.project.entities;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class User {
	private String id;
	private String password;
	private String name;
	private String phone1;
	private String phone2;
	private String phone3;
	private int grade;
	private int point;
	private String jointime;
	private String connecttime;
	private String returnfinance;
	private String returnbank;
	private String nickname;
	private float averagescore;
	private int buycount;
	private int sellcount;
	
	/* 회원정보 총결제액 및 3개월 결제액 출력 */
	private int totalsum;
	private int threemonthsum;
}
