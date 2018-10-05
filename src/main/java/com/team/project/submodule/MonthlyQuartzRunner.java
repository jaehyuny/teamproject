package com.team.project.submodule;

import java.util.ArrayList;
import java.util.Optional;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;

import com.team.project.entities.Grade;
import com.team.project.entities.User;
import com.team.project.service.CouponDAO;
import com.team.project.service.GradeDAO;
import com.team.project.service.MonthlyQuartz;
import com.team.project.service.UserDAO;

@Service("monthlyCheck")
public class MonthlyQuartzRunner implements MonthlyQuartz{

	@Inject
	SqlSession session;
	@Inject
	User user;
	@Inject
	Grade grade;
	
	/**
	 * 매월 정기쿠폰을 지급하는 메소드
	 */
	@Override
	public void giveMonthlyCoupon() {
		CouponDAO couponDAO = session.getMapper(CouponDAO.class);
		UserDAO userDAO = session.getMapper(UserDAO.class);
		GradeDAO gradeDAO = session.getMapper(GradeDAO.class);
		
		ArrayList<Grade> gradeList = gradeDAO.selectGrade();
		ArrayList<User> userList = userDAO.selectAll();
		
		for(Grade item:gradeList) {
			/* monthcoupon은 null인데 monthcouponamount가 1 이상일 경우를 대비
			 * monthcoupon이 null이면 coupon에 0을 저장하고, 0이 아닐 경우에만 실행한다. */
			int coupon = Optional.ofNullable(item).map(Grade::getMonthcoupon).orElse(0);
			if(coupon != 0) {
				int monthamount = item.getMonthcouponamount();
				ArrayList<User> gradeUsers = new ArrayList<User>();
				for(User user:userList) {
					if(user.getGrade() == item.getCode()) {
						gradeUsers.add(user);
					}
				}
				for(int i = 0; i < monthamount; i++) {
					couponDAO.insertMonthlyCoupon(gradeUsers);
				}
			}
		}
		
		System.out.println("월별 정기쿠폰 지급...");
		
	}

}
