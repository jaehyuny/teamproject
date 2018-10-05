package com.team.project.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.team.project.entities.BoardPaging;
import com.team.project.entities.Grade;
import com.team.project.entities.User;

public interface UserDAO {
	int selectByid(String id);
	void insertRow(User user);
	void updateUser(User user);
	void deleteUser(String id);
	int loginCheck(User user);
	String selectName(String id);
	void updateUserInfo(User user);
	void deleteUserInfo(User user);
	void updatePassword(HashMap hashMap);
	int selectRowCount(String find);

	User selectUser(String id);
	ArrayList<User> selectAllPaging(BoardPaging boardpaging);
	ArrayList<User> selectAll();
	Grade selectUserGrade(int grade);	//User의 grade이며 Grade의 code
	/**
	 * 특정 유저의 포인트를 일정량 차감합니다.
	 * <br> 주의! 포인트 차감량은 양수입니다!
	 * @param user - id(지울유저), point(내릴 양)만을 사용합니다.
	 * @author : 김영호
	 * @date : 2018. 8. 30. 오전 11:12:54
	*/
	void subtractUserPoint(User user);
	void addUserPoint(User user);
	
	void updateConnectTime(String id);
}
