package com.team.project.entities;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Category {
	private String name;
	private String discription;
	private String upname;
	private int depth;
}
