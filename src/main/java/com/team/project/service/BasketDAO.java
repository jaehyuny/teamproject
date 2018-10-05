/**
 * 
 */
package com.team.project.service;

import com.team.project.entities.Basket;

/**
 * 
 * @author : 김영호
 * @date : 2018. 8. 20. 오후 2:37:01
*/
public interface BasketDAO {
	public void insert(Basket basket);
	public int duplicateCheck(Basket basket);
	
	public int deleteBasket(Basket basket);
	
}
