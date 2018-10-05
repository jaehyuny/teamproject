package com.team.project.service;

import java.util.ArrayList;

import com.team.project.entities.Grade;

public interface GradeDAO {
	ArrayList<Grade> selectGrade();
	int selectGradeCount();
	Grade selectGradeFromCode(int code);
}
