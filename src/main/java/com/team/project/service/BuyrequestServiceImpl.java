package com.team.project.service;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.team.project.entities.Book;
import com.team.project.entities.BuyRequestProduct;
import com.team.project.entities.Buyrequest;
import com.team.project.entities.User;

@Service
public class BuyrequestServiceImpl implements BuyrequestService{
	@Inject
	SqlSession sqlSession;
	
	@Transactional
	@Override
	public void addBuyrequest(Buyrequest buyrequest, User user, int couponcode) {
		UserDAO userDAO = sqlSession.getMapper(UserDAO.class);
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		if(couponcode != 0) {
			couponDAO.updateUsedGetCoupon(couponcode);	//쿼리실행 : 사용한 쿠폰(배송) 처리
		}
		buyrequestDAO.insertBuyRequest(buyrequest);	//쿼리실행 : 주문 입력
		userDAO.addUserPoint(user);	//쿼리실행 : 유저 포인트 추가
	}

	@Transactional
	@Override
	public void addBuyproduct(BuyRequestProduct buyProduct, Book book, int couponcode2) {
		BookDAO bookDAO = sqlSession.getMapper(BookDAO.class);
		BuyRequestProductDAO buyproductDAO = sqlSession.getMapper(BuyRequestProductDAO.class);
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		
		if(couponcode2 != 0) {
			couponDAO.updateUsedGetCoupon(couponcode2);	//쿼리실행 : 사용한 쿠폰 처리
		}
		
		buyproductDAO.insertBuyrequestProduct(buyProduct);	//쿼리실행 : 주문 상품 입력
		bookDAO.updateSubstractStock(book);	//쿼리 실행 : 주문한 책 수량만큼 재고 감소
	}

}
