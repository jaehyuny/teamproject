package com.team.project.service;

import java.util.ArrayList;

import com.team.project.entities.BoardPaging;
import com.team.project.entities.Coupon;
import com.team.project.entities.Getcoupon;
import com.team.project.entities.User;

public interface CouponDAO {
	ArrayList<Coupon> selectCouponAllPaging(BoardPaging boardpaging);
	ArrayList<Coupon> selectCouponAll();
	ArrayList<Getcoupon> selectGetCouponAll();
	Getcoupon selectGetCouponInfo(int code);
	int insertCoupon(Coupon coupon);
	int insertGetCoupon(Getcoupon getcoupon);
	void deleteCoupon(String code);
	void updateCoupon(Coupon coupon);
	Coupon selectCoupon(int code);
	int selectCouponCode();
	int selectRowCount(String find);
	int selectGetCoupon(Getcoupon getcoupon);
	Coupon selectCouponFromGetcoupon(int code);
	
	ArrayList<Coupon> selectUserCoupon(String id);
		
	/**
	 * 회원정보에 쿠폰 갯수 출력 : 사용가능한 것만 출력
	 * @param id
	 * @return
	 */
	int selectOwnCoupon(String id);
	
	int updateUsedGetCoupon(int code);	//쿠폰 사용 시 isusing을 1로
	int updateExpiredGetCoupon(int code);	//쿠폰 기한 만료 시 isusing을 2로
	
	int insertMonthlyCoupon(ArrayList<User> userList);
}
