package com.team.project;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.team.project.entities.Board;
import com.team.project.entities.BoardLike;
import com.team.project.entities.BoardPaging;
import com.team.project.entities.Book;
import com.team.project.entities.Pagination;
import com.team.project.service.BoardDAO;
import com.team.project.service.BoardLikeDAO;
import com.team.project.service.BookDAO;
import com.team.project.submodule.BeanProcessor;

@Controller
public class BoardController {
	
	@Inject
	SqlSession sqlSession;
	@Inject
	Board board;
	@Inject
	Book book;
	@Inject
	BoardPaging boardpaging;
	@Inject
	BeanProcessor beanProcessor;
	/* 독후감용 도서 선택 */
	@ResponseBody
	@RequestMapping(value = "boardBookSelected", method = RequestMethod.POST)
	public Book boardBookSelected(@RequestParam int code) {
		BookDAO bookdao = sqlSession.getMapper(BookDAO.class);
		return bookdao.selectBook(code);
	}
	@ResponseBody
	@RequestMapping(value = "boardBookSearch", method = RequestMethod.POST)
	public ArrayList<Book> boardBookSearch(@RequestParam String name) {
		BookDAO bookdao = sqlSession.getMapper(BookDAO.class);
		return bookdao.selectBookSearchByName(name);
	}
	/* 게시판 글쓰기 페이지 */
	@RequestMapping(value = "boardInsertForm", method = RequestMethod.GET)
	public String boardInsertForm(Model model) {
		return "board/board_insert_form.page";
	}
	/* 게시글 쓰기 */
	@RequestMapping(value = "boardInsert", method = RequestMethod.POST)
	public String boardInsert(@ModelAttribute Board board, HttpServletRequest request) throws Exception {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		board.setIp(request.getRemoteAddr());
		dao.insertBoard(board);
		String redirectpage = null;
		if(board.getBoardname().equals("freeboard")) {
			redirectpage =  "redirect:boardList";
		}else if(board.getBoardname().equals("reviewboard")) {
			redirectpage = "redirect:reviewList";
		}
		return redirectpage;
	}
	/**
	 * ckeditor 이미지 업로드용
	 * @param upload ckeditor에서 이미지버튼 클릭시 업로드되는 파일
	 * @author 신지호
	 * 2018. 9. 11.
	 */
	@RequestMapping(value = "imageUpload", method = RequestMethod.POST)
	public void imageUpload(@RequestParam MultipartFile upload,	HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");
		OutputStream output = null;
		PrintWriter printWriter = null;
		try {
			Date date = new Date();
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd_hhmm");
			String uploadTime = format.format(date);
			String fileName = upload.getOriginalFilename();
			String uploadName = uploadTime+"_"+fileName;
			String uploadPath = session.getServletContext().getRealPath("/");
			String realPath = session.getServletContext().getContextPath()+"/resources/images/";
			String uploadFile = uploadPath+"resources/images/"+uploadName;
			byte[] bytes = upload.getBytes();
			output = new FileOutputStream(uploadFile);
			output.write(bytes);
			printWriter = response.getWriter();
			String fileUrl = realPath+uploadName;
			Gson gson = new Gson();
			JsonObject object = new JsonObject();
			object.addProperty("uploaded", 1);
			object.addProperty("filename", uploadName);
			object.addProperty("url", fileUrl);
			String json = gson.toJson(object);
			printWriter.println(json);
			printWriter.flush();
		} catch (Exception e) {
		} finally {
			try {
				if(output != null) {
					output.close();
				}
				if(printWriter != null) {
					printWriter.close();
				}
			} catch (Exception e2) {
			}
		}
		return;
	}
	/* 자유게시판 글 목록 */
	@RequestMapping(value = "/boardList", method = RequestMethod.GET)
	public String boardList(Model model, @RequestParam(defaultValue="") String find, @RequestParam(defaultValue="1") int curPage) throws Exception {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		int listCount = dao.boardCount(find);
		Pagination pagination = new Pagination(listCount,curPage);
		boardpaging.setFind(find);
		boardpaging.setStartrow(pagination.getStartIndex());
		boardpaging.setEndrow(pagination.getPageSize());
		ArrayList<Board> boards = dao.boardList(boardpaging);
		model.addAttribute("boards",boards);
		model.addAttribute("pagination",pagination);
		return "board/board_list.page";
	}
	/* 자유게시판 상세보기 */
	@RequestMapping(value = "boardDetailForm", method = RequestMethod.GET)
	public String boardDetailForm(Model model,HttpSession session,@RequestParam int code,@RequestParam String boardname) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		BoardLikeDAO likedao = sqlSession.getMapper(BoardLikeDAO.class);
		String sessionid = (String) session.getAttribute("sessionid");
		Board board = new Board();
		board.setBoardname(boardname);
		board.setCode(code);
		board = dao.boardDetail(board);
		if(!board.getUserid().equals(sessionid)) {
			dao.updateHit(board);
			board.setHit(board.getHit()+1);
		}
		/* 좋아요,싫어요 입력여부 체크 */
		BoardLike boardlike = new BoardLike();
		boardlike.setBoardcode(code);
		boardlike.setBoardname(boardname);
		boardlike.setUserid(sessionid);
		boardlike = likedao.duplicateCheck(boardlike);
		model.addAttribute("board",board);
		model.addAttribute("boardlike",boardlike);
		return "board/board_detail_free.page";
	}
	/* 독후감 게시판 글 목록 */
	@RequestMapping(value = "/reviewList", method = RequestMethod.GET)
	public String reviewList(Model model, @RequestParam(defaultValue="") String find, @RequestParam(defaultValue="1") int curPage) throws Exception {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		int listCount = dao.reviewCount(find);
		Pagination pagination = new Pagination(listCount,curPage);
		boardpaging.setFind(find);
		boardpaging.setStartrow(pagination.getStartIndex());
		boardpaging.setEndrow(pagination.getPageSize());
		ArrayList<Board> boards = dao.reviewList(boardpaging);
		model.addAttribute("boards",boards);
		model.addAttribute("pagination",pagination);
		return "board/board_review.page";
	}
	/* 독후감 게시판 글 상세 */
	@RequestMapping(value = "/reviewDetailForm", method = RequestMethod.GET)
	public String reviewDetailForm(Model model,@RequestParam int code,@RequestParam String boardname,HttpSession session) {		
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		BoardLikeDAO likedao = sqlSession.getMapper(BoardLikeDAO.class);
		String sessionid = (String) session.getAttribute("sessionid");
		Board board = new Board();
		board.setCode(code);
		board.setBoardname(boardname);
		board = dao.reviewDetail(board);
		if(!board.getUserid().equals(sessionid)) {
			dao.updateHit(board);
		}
		/* 할인율 */
		float disprice = board.getPrice()-board.getRealprice();
		float discount = (disprice/board.getPrice())*100;
		board.setDiscount(discount);
		/* 좋아요,싫어요 입력여부 체크 */
		BoardLike boardlike = new BoardLike();
		boardlike.setBoardcode(code);
		boardlike.setBoardname(boardname);
		boardlike.setUserid(sessionid);
		boardlike = likedao.duplicateCheck(boardlike);
		model.addAttribute("board",board);
		model.addAttribute("boardlike",boardlike);
		return "board/board_detail_review.page";
	}
	
	@RequestMapping(value = "boardUpdateForm", method = RequestMethod.GET)
	public String boardUpdateForm(Model model,@RequestParam int code,@RequestParam String boardname) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		Board board = new Board();
		board.setCode(code);
		board.setBoardname(boardname);
		if(boardname.equals("freeboard")) {
			board = dao.boardDetail(board);
		}else if(boardname.equals("reviewboard")){
			board = dao.reviewDetail(board);
		}
		model.addAttribute("board",board);
		return "board/board_update_form.page";
	}
	@RequestMapping(value = "boardUpdate", method = RequestMethod.POST)
	public String boardUpdate(@ModelAttribute Board board,HttpServletRequest request) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		board.setIp(request.getRemoteAddr());
		dao.updateBoard(board);
		String redirectpage = null;
		if(board.getBoardname().equals("freeboard")) {
			redirectpage = "redirect:boardDetailForm?code="+board.getCode()+"&boardname="+board.getBoardname();
		}else if(board.getBoardname().equals("reviewboard")) {
			redirectpage = "redirect:reviewDetailForm?code="+board.getCode()+"&boardname="+board.getBoardname();
		}
		return redirectpage;
	}
	@RequestMapping(value = "boardDelete", method = RequestMethod.GET)
	public String boardDelete(@RequestParam int code, @RequestParam String boardname) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		Board board = new Board();
		board.setCode(code);
		board.setBoardname(boardname);
		dao.deleteByCode(board);
		String redirectpage = null;
		if(boardname.equals("freeboard")) {
			redirectpage = "redirect:boardList";
		}else if(boardname.equals("reviewboard")) {
			redirectpage = "redirect:reviewList";
		}
		return redirectpage;
	}
}
