/**
 * 
 */
package com.team.project.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.team.project.entities.UsedBasket;
import com.team.project.entities.UsedSell;
import com.team.project.entities.UsedTrade;
import com.team.project.entities.UsedTradeProduct;

/**
 * 
 * @author : 김영호
 * @date : 2018. 8. 20. 오후 3:26:14
*/
public interface UsedDAO {
	ArrayList<UsedSell> selectUsedSellByBookcodeLimited(int bookcode);
	int countUsedSellByBookCode(int bookcode);
	int selectLowestPrice(int bookcode);
	/**
	 * 중고거래를 db에 등록합니다.
	 * @param usedsell
	 * @author : 김영호
	 * @date : 2018. 8. 28. 오전 11:23:45
	*/
	void insertUsedSell(UsedSell usedsell);
	ArrayList<UsedSell> selectUsedSellWithBookCode(int bookcode);
	/**
	 * 장바구니에 중고거래를 등록합니다.
	 * @param basket
	 * @author : 김영호
	 * @date : 2018. 8. 29. 오전 9:18:09
	*/
	void insertUsedBasket(UsedBasket basket);
	/**
	 * 장바구니에 등록된 것이 해당 유저에게 중복인지 확인합니다.
	 * @param basket
	 * @return 중복인 장바구니 객체를 리턴합니다. 없으면 size가 0입니다
	 * @author : 김영호
	 * @date : 2018. 8. 29. 오전 9:22:31
	*/
	int usedBasketDuplicationCheck(UsedBasket basket);
	/**
	 * 중고장바구니의 모든 행을 판매정보와 함께 조회합니다.
	 * @param id 조회할 유저id입니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 8. 29. 오후 12:27:21
	*/
	ArrayList<UsedBasket> selectUsedBasket(String id);
	/**
	 * 중고 장바구니 내의 특정 항목을 삭제합니다.
	 * @param basket 삭제할 기준 유저id 및 usedsellcode만 필요합니다.
	 * @author : 김영호
	 * @date : 2018. 8. 29. 오후 1:49:28
	 */
	void removeUsedBasket(UsedBasket basket);
	/**
	 * 중고거래 주문을 삽입합니다.
	 * @return 삽입 후, 해당 중고거래의 code를 반환합니다.
	 * @author : 김영호
	 * @date : 2018. 8. 29. 오후 3:35:52
	 */
	int insertUsedTrade(UsedTrade usedtrade);
	
	/**
	 * 중고거래 주문에 속하는 각 책들을 삽입합니다.
	 * @param usedtradeproduct 알잖아요
	 * @author : 김영호
	 * @date : 2018. 8. 30. 오전 10:49:33
	 */
	void insertUsedTradeProduct(UsedTradeProduct usedtradeproduct);
	/**
	 * 특정 usedsell, 즉 판매 게시글에서 스톡을 지정한 양으로 만듭니다.
	 * @param usedsell - code(지울게시글코드), stock(재고)만 사용합니다. 
	 * @author : 김영호
	 * @date : 2018. 8. 30. 오전 11:09:50
	*/
	void updateStockOnUsedSell(UsedSell usedsell);
	/**
	 * 특정 usedsell을 업데이트합니다.
	 * @param usedsell - code, state만 사용합니다.
	 * @author : 김영호
	 * @date : 2018. 8. 30. 오전 11:21:51
	*/
	void updateStateOnUsedSell(UsedSell usedsell);
	/**
	 * 특정 유저의 모든 장바구니 내용을 지웁니다.
	 * @param id 유저의 id입니다.
	 * @author : 김영호
	 * @date : 2018. 8. 30. 오전 11:58:13
	 */
	void deleteUserBasketAll(String id);
	/**
	 * 중고거래 장바구니의 갯수를 수정합니다. userid와 usedsellcode를 기준으로합니다.
	 * @param basket 
	 * @author : 김영호
	 * @date : 2018. 8. 30. 오후 12:11:28
	*/
	void updateAmountOnUsedBasket(UsedBasket basket);
	/**
	 * 모든 중고거래 리스트를 반환합니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 3. 오전 10:13:33
	*/
	ArrayList<UsedSell> selectUsedSell();
	/**
	 * 받은 객체에서 code로 검색하여 해당 셀의 최종가격을 업데이트합니다.
	 * @author : 김영호
	 * @date : 2018. 9. 3. 오후 1:31:22
	 */
	void updateFinalPriceOnUsedTrade(UsedTrade trade);
	
	/**
	 * 회원정보에 중고거래주문(구입)을 출력	
	 * @param buyerid
	 * @return
	 */
	ArrayList<UsedTrade> selectUsedTrade(String buyerid);
	
	/**
	 * 회원정보 중고주문에서 평점 및 평가 입력
	 * @param hashMap
	 */
	void updateScoreEvaltext(HashMap hashMap);
	
	/**
	 * 회원정보 중고주문에서 거래완료 처리
	 * @param code
	 */
	void updateStateComplete(int code);
	
	/**
	 * 회원정보 중고주문에서 판매상황을 출력
	 * @param sellerid
	 * @return
	 */
	ArrayList<UsedSell> selectUsedSellByid(String sellerid);

	UsedSell selectUsedSellByCode(int code);
	/**
	 * 특정 책 코드에 대한 usedsell 목록 중 구매 가능한것(판매중인것)만 반환합니다.
	 * @param bookcode
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 4. 오후 4:19:23
	*/
	ArrayList<UsedSell> selectUsedSellByBookcodeBuyableOnly(int bookcode);
	/**
	 * 모든 중고거래 판매글 중 구매가능한것만 반환합니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 5. 오전 10:55:30
	*/
	ArrayList<UsedSell> selectUsedSellBuyableOnly();
	/**
	 * 해당 판매자와 관련된 구매가능한 모든 상품을 반환합니다.
	 * @param sellerid
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 5. 오후 12:23:30
	*/
	ArrayList<UsedSell> selectUsedSellBySellerId(String sellerid);
	/**
	 * 특정 판매자의 모든 판매기록을 반환합니다.
	 * @param sellerid
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 5. 오후 2:46:03
	*/
	ArrayList<UsedTrade> selectUsedTradeBySellerId(String sellerid);
}
