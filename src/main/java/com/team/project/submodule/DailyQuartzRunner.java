package com.team.project.submodule;

import java.sql.Timestamp;
import java.util.ArrayList;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;

import com.team.project.entities.Getcoupon;
import com.team.project.service.CouponDAO;
import com.team.project.service.DailyQuartz;

@Service("dailyCheck")
public class DailyQuartzRunner implements DailyQuartz {

	@Inject
	SqlSession sqlSession;
	
	
	@Override
	public void getCouponCheckDeadline() {
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		ArrayList<Getcoupon> getcouponList = couponDAO.selectGetCouponAll();
		Timestamp currentTime = new Timestamp(System.currentTimeMillis());
		Timestamp exfireday = new Timestamp(0);
		System.out.println("쿠폰 기한 체크...");
		for(Getcoupon item:getcouponList) {
			exfireday = item.getExfireday();
			if(currentTime.getTime() > exfireday.getTime()) {
				couponDAO.updateExpiredGetCoupon(item.getCode());
			}
		}
		
	}

}
