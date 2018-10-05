/**
 * 
 */
package com.team.project.entities;

import lombok.Data;

/**
 * 중고거래에서 각 책 별 가격을 기록하는 테이블입니다. 이를 합쳐서 usedtrade에 기록합니다.
 * @author : 김영호
 * @date : 2018. 8. 30. 오전 10:46:22
*/
@Data
public class UsedTradeProduct {
	int usedtradecode;
	int usedsell;
	int amount;
	int price;
	int finalprice;
}
