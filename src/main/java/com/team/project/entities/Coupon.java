package com.team.project.entities;

import java.sql.Timestamp;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Coupon {
	private int code;
	private String name;
	private int fixedsale;
	private int percentsale;
	private int percentmaxsale;
	private int moneycondition;
	private String catcondition;
	private String imglink;
	private int isfreeshiping;
	private int exfireday;
	private int acceptnum;
	private Timestamp getexfireday;
	private int ownercode;
}
