package com.team.project.entities;

import java.sql.Timestamp;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Getcoupon {
	private String id;
	private int couponcode;
	private Timestamp exfireday;
	private int code;
	private int isusing;
}
