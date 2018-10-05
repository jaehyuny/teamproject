package com.team.project;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.team.project.entities.Board;
import com.team.project.entities.BoardPaging;
import com.team.project.entities.Event;
import com.team.project.service.BoardDAO;
import com.team.project.service.EventDAO;

@Controller
public class EventController {
	
	@Inject
	SqlSession sqlSession;
	@Inject
	Board board;
	@Inject
	Event event;
	@Inject
	BoardPaging boardPaging;
	
	@RequestMapping(value="eventAdmin", method=RequestMethod.GET)
	public String eventAdmin(@RequestParam(defaultValue="1") int pageNum,
			Model model, HttpSession session) {
		
		if(!session.getAttribute("sessionid").toString().equals("admin@nullpointers.com")) {
			return "redirect:/";
		}

		EventDAO eventDAO = sqlSession.getMapper(EventDAO.class);
		
		int pageSize = 4;
		int a = 0;
		int startRow = (pageNum - 1) * pageSize;
		model.addAttribute("pageNum", pageNum);
		
		int rowCount = eventDAO.selectEventCount();
		int absPage = 1;
		if(rowCount % pageSize == 0) {
			absPage = 0;
		}
		int pageCount = rowCount / pageSize + absPage;
		model.addAttribute("pageCount", pageCount);
		
		boardPaging.setStartrow(startRow);
		boardPaging.setEndrow(pageSize);

		ArrayList<Event> eventlist = eventDAO.selectEventList(boardPaging);
		model.addAttribute("eventlist", eventlist);
		
		return "admin/event_admin.admininfo";
	}
	
	@RequestMapping(value="eventList", method=RequestMethod.GET)
	public String eventList(@RequestParam(defaultValue="1") int pageNum,
			Model model) {

		EventDAO eventDAO = sqlSession.getMapper(EventDAO.class);
		
		int pageSize = 5;
		int a = 0;
		int startRow = (pageNum - 1) * pageSize;
		model.addAttribute("pageNum", pageNum);
		
		int rowCount = eventDAO.selectEventCount();
		int absPage = 1;
		if(rowCount % pageSize == 0) {
			absPage = 0;
		}
		int pageCount = rowCount / pageSize + absPage;
		model.addAttribute("pageCount", pageCount);
		
		boardPaging.setStartrow(startRow);
		boardPaging.setEndrow(pageSize);

		ArrayList<Event> eventlist = eventDAO.selectEventList(boardPaging);
		model.addAttribute("eventlist", eventlist);
		
		return "event/event_list.page";
	}
	
	@RequestMapping(value="eventWritePage", method=RequestMethod.GET)
	public String eventWritePage(HttpSession session) {
		if(!session.getAttribute("sessionid").toString().equals("admin@nullpointers.com")) {
			return "redirect:/";
		}
		return "admin/event_write.admininfo";
	}
	
	@Transactional
	@RequestMapping(value ="eventWrite", method = RequestMethod.POST)
	public String eventWrite(@ModelAttribute Board board,
			@RequestParam MultipartFile picturelink,
			@RequestParam MultipartFile eventimage,
			@RequestParam String startday,
			@RequestParam String endday,
			HttpSession session) {
		
		if(!session.getAttribute("sessionid").toString().equals("admin@nullpointers.com")) {
			return "redirect:/";
		}
		
		BoardDAO boardDAO = sqlSession.getMapper(BoardDAO.class);
		EventDAO eventDAO = sqlSession.getMapper(EventDAO.class);
		
		board.setBoardname("event");
		board.setIp("");
		
//		String path = "D:/teamproject/src/main/webapp/resources/images/event/";
		String uploadPath = session.getServletContext().getRealPath("/resources/images/event/");
		String savepath = "resources/images/event/";
		//메인이미지 저장
		if(!picturelink.isEmpty()) {
			try {
				String originalFileName = picturelink.getOriginalFilename();
				String extension = originalFileName.substring(originalFileName.indexOf(".")).toLowerCase();
				String saveName = "main_" + System.currentTimeMillis() + extension;

				event.setPicturelink(savepath + saveName);
				
				byte[] bytes = picturelink.getBytes();
				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(uploadPath+saveName));
				output.write(bytes);
				output.flush();
				output.close();
	
			} catch (IOException e) {
				
				e.printStackTrace();
			}
		}
		//본문이미지 저장
		if(!eventimage.isEmpty()) {
			try {
				String originalFileName = eventimage.getOriginalFilename();
				String extension = originalFileName.substring(originalFileName.indexOf(".")).toLowerCase();
				String saveName = "content_" + System.currentTimeMillis() + extension;

				String contentImage = savepath + saveName;
				board.setContent("<img src=" + contentImage + "><br>" + board.getContent());
				
				byte[] bytes = eventimage.getBytes();
				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(uploadPath+saveName));
				output.write(bytes);
				output.flush();
				output.close();
				
			} catch (IOException e) {
				
				e.printStackTrace();
			}
		}
		boardDAO.insertEvent(board);
		
		int recentCode = board.getCode();
		String boardPath = "eventContent?code=" + recentCode + "&boardname=event";
		
		//문자열로 받은 날짜를 타임스탬프로 변환
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			Date date = formatter.parse(startday);
			Timestamp timestamp = new Timestamp(date.getTime());
			event.setStartday(timestamp);
			
			date = formatter.parse(endday);
			timestamp = new Timestamp(date.getTime());
			event.setEndday(timestamp);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		event.setPagelink(boardPath);
		eventDAO.insertEvent(event);
		
		return "redirect:eventAdmin";
	}
	
	@RequestMapping(value="eventBoard", method = RequestMethod.GET)
	public String eventBoard(@RequestParam(defaultValue="0") int num) {
		
		return "";
	}
	
	@RequestMapping(value="eventContent", method = RequestMethod.GET)
	public String eventContent(@RequestParam int code, Model model) {
		EventDAO eventDAO = sqlSession.getMapper(EventDAO.class);
		
		event = eventDAO.selectEvent(code);
		
		model.addAttribute("event", event);
		return "event/event_content.page";
	}
	
	
}
