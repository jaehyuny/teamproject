package com.team.project.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.team.project.entities.Basket;
import com.team.project.entities.BoardPaging;
import com.team.project.entities.Buyrequest;

public interface BuyrequestDAO {
	ArrayList<Basket> selectBasket(String userid);
	ArrayList<Buyrequest> selectBuyRequest();
	ArrayList<Buyrequest> selectBuyRequestPaging(BoardPaging boardpaging);
	ArrayList<Buyrequest> selectBuyRequestSearch(String state);
	void updateState(HashMap rollkey);
	int updateOrderCancel(Buyrequest buyrequest);
	
	int insertBuyRequest(Buyrequest buyrequest);
	int selectRowCount(String state);
	
	/**
	 * 회원정보의 포인트 내역을 위한 데이터 출력
	 * @param buyerid
	 * @return
	 */
	ArrayList<Buyrequest> selectForPoint(String buyerid);
	
	/**
	 * 회원정보의 주문상황을 위한 데이터 출력(3개월)
	 * @param buyerid
	 * @return
	 */
	ArrayList<Buyrequest> selectForUserinfo(String buyerid);
	
	/**
	 * 메인창에 베스트 셀러 출력
	 * @return
	 */
	ArrayList<Buyrequest> selectBestseller();
	
	Buyrequest selectRecentOrder(String userid);	//최근에 주문한 상품
	
	/**
	 * 회원정보의 주문갯수를 위한 데이터 출력
	 * @param userid
	 * @return
	 */
	int selectOrderCount(String userid);
	
	/**
	 * 회원정보 일반주문의 내역 출력(전체)
	 * @param buyerid
	 * @return
	 */
	ArrayList<Buyrequest> selectForMyOrder(String buyerid);
	
	/**
	 * 회원정보상 총결제액 및 3개월 결제액 출력
	 * @param buyerid
	 * @return
	 */
	Buyrequest selectForSum(String buyerid);
	
	/**
	 * 회원정보 일반주문 클릭시 상세내역 출력
	 * @param code
	 * @return
	 */
	Buyrequest selectByCode(String code);
	
	/**
	 * 회원정보 주문상세창에서 책이름 출력
	 * @param code
	 * @return
	 */
	ArrayList<Buyrequest> selectBookname(String code);
	
}
