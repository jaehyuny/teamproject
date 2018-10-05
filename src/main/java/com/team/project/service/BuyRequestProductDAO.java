/**
 * 
 */
package com.team.project.service;

import java.util.ArrayList;

import com.team.project.entities.BuyRequestProduct;

/**
 * 
 * @author : 김영호
 * @date : 2018. 8. 29. 오전 11:18:53
*/
public interface BuyRequestProductDAO {
	int insertBuyrequestProduct(BuyRequestProduct buyProduct);
	ArrayList<BuyRequestProduct> selectBuyRequestProduct(String code);
	ArrayList<BuyRequestProduct> selectRecentBuyProduct(int code);
}
