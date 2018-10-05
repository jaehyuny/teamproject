package com.team.project.entities;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class Address {
	private int code;
	private String userid;
	private String nickname;
	private String postno;
	private String address1;
	private String address2;
	private int isnewaddress;
	private int isdefault;
	private String tel;
	private String phone;
	private String receivername;
}
