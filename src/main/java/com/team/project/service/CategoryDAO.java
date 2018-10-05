/**
 * 
 */
package com.team.project.service;

import java.util.ArrayList;

import com.team.project.entities.Category;

/**
 * 카테고리 테이블에 관련된 명령이 모여있습니다.
 * @author : 김영호
 * @date : 2018. 8. 10. 오전 10:22:23
*/
public interface CategoryDAO {
	public ArrayList<Category> selectAll();
}
