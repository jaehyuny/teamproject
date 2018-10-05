package com.team.project.entities;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Basket {
	String userid;
	int bookcode;
	String bookname;
	int amount;
	int bookprice;
	int checkedNum;
	String bookcategory;
}
