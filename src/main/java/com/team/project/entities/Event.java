package com.team.project.entities;

import java.sql.Timestamp;

import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
public class Event {
	int code;
	String picturelink;
	String pagelink;
	Timestamp startday;
	Timestamp endday;
	String title;
	String content;
}
