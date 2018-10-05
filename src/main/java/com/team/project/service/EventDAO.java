package com.team.project.service;

import java.util.ArrayList;

import com.team.project.entities.BoardPaging;
import com.team.project.entities.Event;

public interface EventDAO {

	ArrayList<Event> selectEventList(BoardPaging boardPaging);
	Event selectEvent(int code);
	int insertEvent(Event event);
	public int selectEventCount();
}
