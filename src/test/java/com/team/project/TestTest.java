package com.team.project;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.PrimitiveIterator.OfInt;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.fasterxml.jackson.databind.ser.std.NumberSerializer;
import com.team.project.entities.Book;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
	    locations = "file:src/main/webapp/WEB-INF/spring/**/*.xml" )
@WebAppConfiguration
public class TestTest {
	
	@Autowired
	private SqlSession session;

	@Test
	public void test() {
	
		ArrayList<Book> list = new ArrayList<Book>();
		list.add(new Book());
		list.add(new Book());
		list.add(new Book());
		list.add(new Book());
		list.get(0).setName("홍길동");
		list.get(1).setName("김삿갓");
		list.get(2).setName("인절미");
		list.get(3).setName("호랑이");
		
		
		
		
		
	}
}
