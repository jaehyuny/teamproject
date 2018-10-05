package com.team.project.entities;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Book {
	private String name;
	private int code;
	private int authorcode;
	private int price;
	private int realprice;
	private int stock;
	private String discription;
	private String publisher;
	private String contentlist;
	private String sellerdiscription;
	private String cat1;
	private String cat2;
	private int publishyear;
	private int publishmonth;
	private int publishday;
	private String splashtext;
	private String booktype;
	private int pagenumber;
	private String scale;
	private String isbn;
	private String trailer;
	private double averagescore;
	private int evaluaternum;
	
	//Book 테이블에는 없지만 join용 컬럼
	private String authorname;
	private String authorpicture;
	private String authoryear;
	private String authordiscription;
}
