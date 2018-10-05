/**
 * 
 */
package com.team.project.submodule;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.stereotype.Component;

import com.team.project.entities.UsedBasket;

/**
 * 비즈니스 로직의 계산에 관련된 메서드를 모아놓은 클래스입니다.
 * @author : 김영호
 * @date : 2018. 9. 3. 오후 1:59:50
*/
@Component
public class BusinessCalculator {

	/**
	 * 사용자 중고장바구니의 합산가격과 배송비를 계산합니다.
	 * @return 배열의 0번째에는 책합산가격, 1번째에는 배송비가 들어있습니다. 2번째는 0~1번째를 합친값이 포함되있습니다.
	 * @author : 김영호
	 * @date : 2018. 9. 3. 오후 2:01:00
	 */
	public int[] CalculateFinalPriceFromUsedBasket(ArrayList<UsedBasket> usedBasketList) {
		//바스켓리스트 불러오고, 가격총량 계산 및 판매자수 측정
		int[] price = new int[3];
		HashMap<String,Integer> sellerList = new HashMap<>();
		for(UsedBasket i : usedBasketList) {
			price[0] += i.getAmount()*i.getPrice();
			if(!sellerList.containsKey(i.getSellerid())) {
				sellerList.put(i.getSellerid(), i.getAmount());
			}else {
				int beforeAmount = sellerList.get(i.getSellerid());
				sellerList.remove(i.getSellerid());
				sellerList.put(i.getSellerid(),beforeAmount+i.getAmount());
			}
		}

		//서로다른 판매자 1명당 배송비 2500원씩 추가
		price[1] = sellerList.size()*2500;
		price[2] = price[0]+price[1];
		return price;
	}
}
