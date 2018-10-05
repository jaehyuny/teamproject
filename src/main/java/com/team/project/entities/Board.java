package com.team.project.entities;

import java.sql.Timestamp;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class Board {
	private int code;
	private String boardname;
	private String userid;
	private String content;
	private String title;
	private int hit;
	private String attachfile;
	private Timestamp time;
	private String ip;
	private int ref;
	private int bookcode;
	private int isreview;
	private int ismanageronly;
	private String nickname;
	private int score;
	private int likecount;
	private int dislikecount;
	
	/*Board에는 없지만 필요한 Component*/
	private String bookname;
	private String userlike;
	private String authorname;
	private int price;
	private int realprice;
	private String publisher;
	private int publishyear;
	private int publishmonth;
	private int publishday;
	private String username;
	private float discount;
	private double averagescore;
	private String cat1;
	private String cat2;
	private String harfid;
	private String harfip;
	private String qnastate;
	private String filename;
}
