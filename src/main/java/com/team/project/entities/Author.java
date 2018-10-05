package com.team.project.entities;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Author {
	private int code;
	private String name;
	private String discription;
	private int birthyear;
}
