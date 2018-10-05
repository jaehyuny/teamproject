package com.team.project.entities;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Grade {
	private int code;
	private String name;
	private int monthcoupon;
	private int monthcouponamount;
	private String discription;
	private int amount;
	private int paycondition;
	private int levelupcoupon;
	private int levelupcouponcount;
}
