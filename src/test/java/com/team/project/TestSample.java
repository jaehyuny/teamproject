package com.team.project;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.team.project.entities.Book;
import com.team.project.service.BookDAO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
	    locations = "file:src/main/webapp/WEB-INF/spring/**/*.xml" )
public class TestSample {
	
	@Autowired
	private SqlSession session;

	@Test
	public void test() {
		BookDAO dao = session.getMapper(BookDAO.class);
		ArrayList<Book> books = dao.selectAll();
		System.out.println("books : " + books);
	}
	
}
