/**
 * 
 */
package com.team.project;

import java.util.ArrayList;
import java.util.HashMap;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team.project.entities.Address;
import com.team.project.entities.Basket;
import com.team.project.entities.Board;
import com.team.project.entities.BoardLike;
import com.team.project.entities.Book;
import com.team.project.entities.BookEvaluate;
import com.team.project.entities.EvaluateLike;
import com.team.project.entities.UsedBasket;
import com.team.project.entities.UsedSell;
import com.team.project.entities.UsedTrade;
import com.team.project.entities.UsedTradeProduct;
import com.team.project.entities.User;
import com.team.project.service.AddressDAO;
import com.team.project.service.BasketDAO;
import com.team.project.service.BoardDAO;
import com.team.project.service.BoardLikeDAO;
import com.team.project.service.BookDAO;
import com.team.project.service.BookEvaluateDAO;
import com.team.project.service.CategoryDAO;
import com.team.project.service.EvaluateLikeDAO;
import com.team.project.service.UsedDAO;
import com.team.project.service.UserDAO;
import com.team.project.submodule.BeanProcessor;
import com.team.project.submodule.BusinessCalculator;


/**
 *  BookController는 책 목록 페이지, 책 상세정보 페이지를 관리합니다.
 * @author 김영호
 */
@Controller
public class BookController {
	@Inject
	SqlSession session;

	@Inject
	BeanProcessor beanProcessor;
	@Inject
	BusinessCalculator businessCaclulator;

	@Inject
	Basket basket;
	@Inject
	BookEvaluate bookevaluate;
	@Inject
	Board board;
	@Inject
	EvaluateLike evaluatelike;


	/**
	 * 사용자에게 검색결과에 맞는 booklist페이지를 띄워줍니다.
	 * @author : 김영호
	 * @date : 2018. 8. 9. 오후 4:09:04
	 */
	@RequestMapping( value="bookListPage", method=RequestMethod.GET)
	public String bookListPage(Model model, String category) {
		Logger logger = org.slf4j.LoggerFactory.getLogger(this.getClass());
		CategoryDAO catdao = session.getMapper(CategoryDAO.class);
		BookDAO bookdao = session.getMapper(BookDAO.class);

		model.addAttribute("selectedcategoryname",category);
		model.addAttribute("category", catdao.selectAll());
		model.addAttribute("books",bookdao.selectByCategory(category));

		return "book/booklist.page";
	}
	/**
	 * 조건이 추가된 강화판입니다.
	 * @param category 검색할 카테고리명입니다.
	 * @param order 정렬 기준입니다. 평점,신상품,가격,평가수
	 * @param desc 1일경우 내림차순, 0일경우 오름차순입니다.
	 * @param bookname
	 * @param author
	 * @param publisher
	 * @param lowestprice
	 * @param highestprice
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 4. 오전 9:24:30
	 */
	@RequestMapping(value="bookListPageAdvanced", method=RequestMethod.GET)
	public String  bookListPageAdvanced(Model model, String category, String order, int desc, String bookname, String author, String publisher, int lowestprice, int highestprice) {
		//TODO 작성중 9월3일
		CategoryDAO catdao = session.getMapper(CategoryDAO.class);
		BookDAO bookdao = session.getMapper(BookDAO.class);
		HashMap<String,Object> parameter = new HashMap<>();
		parameter.put("category",category);
		parameter.put("order",order);
		parameter.put("desc",desc);
		//TODO ORDER에 따라 맞춰 정렬기준 분류해야함 물론 desc도
		parameter.put("bookname",bookname);
		parameter.put("author",author);
		parameter.put("publisher",publisher);
		parameter.put("lowestprice",lowestprice);
		parameter.put("highestprice",highestprice);

		model.addAttribute("order",order);
		model.addAttribute("selectedcategoryname",category);
		model.addAttribute("category", catdao.selectAll());
		model.addAttribute("books",bookdao.selectAdvanced(parameter));
		return "book/booklist.page";
	}
	/**
	 * 사용자에게 특정한 책의 상세정보 페이지를 띄워줍니다.
	 * @param bookcode 상세정보를 확인할 책의 코드입니다.
	 * @author : 김영호
	 * @date : 2018. 8. 17. 오후 2:09:44
	 */
	@RequestMapping(value="bookDetailPage",method=RequestMethod.GET)
	public String bookDetailPage(Model model, @RequestParam String bookcode) {
		BookDAO bookdao = session.getMapper(BookDAO.class);
		BookEvaluateDAO bookevaluatedao = session.getMapper(BookEvaluateDAO.class);
		BoardDAO boarddao = session.getMapper(BoardDAO.class);
		UsedDAO useddao = session.getMapper(UsedDAO.class);
		int bookcodeint = Integer.parseInt(bookcode);

		model.addAttribute("book",bookdao.selectBook(bookcodeint));
		model.addAttribute("bookevaluate",bookevaluatedao.selectByBookcodeLimited(bookcodeint));
		model.addAttribute("bookreport",boarddao.selectByBookcodeLimited(bookcodeint));
		model.addAttribute("evaluatenum",bookevaluatedao.countByBookcode(bookcodeint));
		model.addAttribute("reportnum",boarddao.countByBookcode(bookcodeint));
		model.addAttribute("usedsellnum",useddao.countUsedSellByBookCode(bookcodeint));
		model.addAttribute("usedselllowest",useddao.selectLowestPrice(bookcodeint));
		return "book/bookdetail.page";
	}
	/**
	 * 사용자에게 특정한 책의 리뷰페이지를 띄워줍니다.
	 * @param bookcode 책의 코드입니다.
	 * @author : 김영호
	 * @date : 2018. 8. 21. 오후 12:36:08
	 */
	@RequestMapping(value="bookReviewPage",method=RequestMethod.GET)
	public String bookReviewPage(Model model, @RequestParam String bookcode) {
		BookDAO bookdao = session.getMapper(BookDAO.class);
		BookEvaluateDAO bookevaluatedao = session.getMapper(BookEvaluateDAO.class);
		BoardDAO boarddao = session.getMapper(BoardDAO.class);
		int bookcodeint = Integer.parseInt(bookcode);
		ArrayList<Board> top20 = boarddao.selectByBookcodeLikeTop20(bookcodeint);
		if(top20.size()<20) {
			for(int i=top20.size(); i<20; i++) {
				Board board = new Board();
				board.setTitle("nodata");
				top20.add(board);
			}
		}
		ArrayList<BookEvaluate> top8 = bookevaluatedao.selectByBookcodeLimitedTop8(bookcodeint);
		model.addAttribute("reporttop20",top20);
		model.addAttribute("evaluatetop8",top8);
		
		model.addAttribute("book",bookdao.selectBook(bookcodeint));
		model.addAttribute("bookevaluate",bookevaluatedao.selectByBookcode(bookcodeint));
		model.addAttribute("bookreport",boarddao.selectByBookcode(bookcodeint));
		model.addAttribute("evaluatenum",bookevaluatedao.countByBookcode(bookcodeint));
		model.addAttribute("reportnum",boarddao.countByBookcode(bookcodeint));
		
		return "book/bookreview.page";
	}
	/**
	 * (REST) 장바구니에 책을 추가합니다.
	 * @param bookcode 추가할 책의 코드입니다.
	 * @param amount 추가할 책의 갯수입니다.
	 * @author : 김영호
	 * @date : 2018. 8. 20. 오후 2:53:13
	 */
	@ResponseBody
	@RequestMapping(value="addBasket",method=RequestMethod.POST)
	public String addBasket(@RequestParam int bookcode, @RequestParam int amount, HttpSession httpsession) {
		BasketDAO dao = session.getMapper(BasketDAO.class);
		basket.setBookcode(bookcode);
		basket.setUserid((String) httpsession.getAttribute("sessionid"));
		basket.setAmount(amount);
		if(dao.duplicateCheck(basket)==0) {
			dao.insert(basket);
			httpsession.setAttribute("sessionBasketCount",(int)httpsession.getAttribute("sessionBasketCount")+1);
		}else {
			return "duplicate";
		}
		return "success";
	}
	/**
	 * (REST) 특정한 책에 대하여 사용자의 평가를 DB에 입력합니다.
	 * @param bookcode 대상이 되는 책입니다.
	 * @param content 평가에 입력될 내용입니다.
	 * @param score 평가에 입력될 책에 대한 점수입니다.
	 * @param httpsession
	 * @return 성공시 success, 중복시 duplicate를 반환합니다.
	 * @author : 김영호
	 * @date : 2018. 8. 27. 오전 11:33:09
	 */
	@ResponseBody
	@RequestMapping(value="insertEvaluate",method=RequestMethod.POST)
	public String insertEvaluate(@RequestParam int bookcode, @RequestParam String content, @RequestParam int score, HttpSession httpsession) {
		BookEvaluateDAO dao = session.getMapper(BookEvaluateDAO.class);
		//TODO 사용자가 로그인했는지 검증하는 AOP코드 추가할것

		//이 사용자가 이미 이 책에 대한 리뷰를 했는지 확인 
		bookevaluate.setUserid((String) httpsession.getAttribute("sessionid"));
		bookevaluate.setBookcode(bookcode);
		if(dao.duplicationCheck(bookevaluate)!=0) {
			return "duplicate";
		}
		//리뷰를 하지 않았었다면, 나머지 값을 추가하여 내용을 추가
		bookevaluate.setContent(content);
		bookevaluate.setScore(score);
		bookevaluate.setLikecount(0);
		bookevaluate.setDislikecount(0);
		dao.insert(bookevaluate);
		//점수업데이트
		((BookDAO) session.getMapper(BookDAO.class)).updateScore(bookcode);;
		return "success";
	}
	/**
	 * (REST) 특정한 책에 대하여 사용자의 독후감을 DB에 입력합니다.
	 * @param bookcode 책의 코드입니다.
	 * @param content 입력할 내용입니다.
	 * @param score 매긴 점수입니다.
	 * @param title 제목입니다.
	 * @param httpsession
	 * @param request
	 * @return 성공시 success, 중복시 duplicate를 반환합니다.
	 * @author : 김영호
	 * @date : 2018. 8. 27. 오전 11:34:20
	 */
	@ResponseBody
	@RequestMapping(value="insertReview",method=RequestMethod.POST)
	public String insertReview(@RequestParam int bookcode, @RequestParam String content, @RequestParam int score, @RequestParam String title, HttpSession httpsession, HttpServletRequest request) {
		BoardDAO dao = session.getMapper(BoardDAO.class);
		//TODO 사용자가 로그인했는지 검증하는 AOP코드 추가할것

		//이 사용자가 이미 이 책에 대한 리뷰를 했는지 확인 
		board.setUserid((String) httpsession.getAttribute("sessionid"));
		board.setBookcode(bookcode);
		if(dao.reviewDuplicationCheck(board)!=0) {
			return "duplicate";
		}
		//리뷰를 하지 않았었다면, 나머지 값을 추가하여 내용을 추가
		board.setContent(content);
		board.setBoardname("ReviewBoard");
		board.setIp(request.getRemoteAddr());
		board.setTitle(title);
		board.setScore(score);
		board.setLikecount(0);
		board.setDislikecount(0);
		board.setIsreview(1);
		dao.insertBoard(board);
		//점수업데이트
		((BookDAO) session.getMapper(BookDAO.class)).updateScore(bookcode);
		return "success";
	}
	/**
	 *(REST) 입력받은 평가 코드에 해당하는 해당 행의 모든 데이터를 반환합니다.
	 * @param 데이터를 찾을 평가테이블의 코드입니다.
	 * @return BookEvalaute 객체를 반환합니다. 코드에 해당하는 모든 정보가 들어있습니다.
	 * @author : 김영호
	 * @date : 2018. 8. 24. 오전 8:56:25
	 */
	@ResponseBody
	@RequestMapping(value="getEvaluateByCode", method=RequestMethod.POST)
	public BookEvaluate getEvaluateByCode(@RequestParam int code,HttpSession httpsession) {
		BookEvaluateDAO bookEvaluateDAO = session.getMapper(BookEvaluateDAO.class);
		EvaluateLikeDAO evaluateLikeDAO =session.getMapper(EvaluateLikeDAO.class);

		BookEvaluate result = bookEvaluateDAO.selectByCode(code);
	
		//평가코드와 유저id를 통해 해당 유저가 이미 좋아요나 싫어요에 평가를 했는지에 대해 userlike에 저장합니다. 없으면 null
		String sessionid = (String)httpsession.getAttribute("sessionid");
		beanProcessor.addUserLikeDataToBookEvaluate(result, sessionid);
		
	return result;
	}
	/**
	 * (REST) 입력받은 독후감의 게시판 코드에 해당하는 모든 데이터를 반환합니다.
	 * @param code 찾을 게시판 테이블의 게시글코드입니다.
	 * @param boardname 게시판의 이름입니다.
	 * @return Board객체에 찾은 게시글의 데이터를 담아서 반환합니다.
	 * @author : 김영호
	 * @date : 2018. 8. 27. 오전 11:36:02
	 */
	@ResponseBody
	@RequestMapping(value="getReviewByCode", method=RequestMethod.POST)
	public Board getReviewByCode(@RequestParam int code, @RequestParam String boardname, HttpSession httpsession) {
		BoardDAO dao = session.getMapper(BoardDAO.class);
		Board board = new Board();
		board.setBoardname(boardname);
		board.setCode(code);
		String sessionid = (String) httpsession.getAttribute("sessionid");
		board = dao.selectByCodeAndBoardName(board);
		beanProcessor.addUserLikeDataToBoard(board, sessionid);
		return board;
	}
	/**
	 * 특정 평가코드에 해당하는 평가를 삭제하고, 원래 리뷰페이지로 새로 고칩니다. 
	 * @param code 삭제할 평가의 평가코드입니다.
	 * @param bookcode 되돌릴 리뷰페이지의 책코드입니다. 이 책코드로 새로 고쳐집니다.
	 * @return bookreviewpage로 리다이렉트됩니다.
	 * @author : 김영호
	 * @date : 2018. 8. 24. 오후 12:01:42
	 */
	@RequestMapping(value="deleteEvaluate",method=RequestMethod.GET)
	public String deleteEvaluate(@RequestParam int code, @RequestParam int bookcode, Model model) {
		//TODO 반드시 세션에서 동일 유저가 맞는지 검증이 필요!! 하지 않으면 해킹 위험이 있습니다.
		BookEvaluateDAO dao = session.getMapper(BookEvaluateDAO.class);
		dao.deleteByCode(code);
		model.addAttribute("bookcode",bookcode);

		//점수업데이트
		((BookDAO) session.getMapper(BookDAO.class)).updateScore(bookcode);
		return "redirect:bookReviewPage";

	}
	/**
	 * 특정 독후감의 게시글코드에 해당하는 독후감 게시글을 삭제하고, 원래 리뷰페이지로 새로 고칩니다. 
	 * @param code 독후감의 게시글코드입니다.
	 * @param bookcode 되돌릴 리뷰페이지의 책코드입니다. 이 책코드로 새로 고쳐집니다.
	 * @return bookreviewpage로 리다이렉트됩니다.
	 * @author : 김영호
	 * @date : 2018. 8. 24. 오후 12:01:42
	 */
	@RequestMapping(value="deleteReview",method=RequestMethod.GET)
	public String deleteReview(@RequestParam int code, @RequestParam String boardname,@RequestParam int bookcode, Model model) {
		//TODO 반드시 세션에서 동일 유저가 맞는지 검증이 필요!! 하지 않으면 해킹 위험이 있습니다.
		BoardDAO dao = session.getMapper(BoardDAO.class);
		board.setBoardname(boardname);
		board.setCode(code);
		dao.deleteByCodeAndBoardName(board);
		model.addAttribute("bookcode",bookcode);

		//점수업데이트
		((BookDAO) session.getMapper(BookDAO.class)).updateScore(bookcode);
		return "redirect:bookReviewPage";
	}
	/**
	 * 특정 평가에 대하여 좋아요/싫어요를 눌렀을 때, 좋아요/싫어요를 증가시키거나 취소, 변경시킵니다.
	 * @param evaluatecode 좋아요/싫어요를 증가시킬 평가의 코드입니다.
	 * @param eval '좋아요' 혹은 '싫어요'입니다.
	 * @param model
	 * @param httpsession
	 * @return
	 * @author : 김영호
	 * @date : 2018. 8. 27. 오전 11:37:12
	 */
	@ResponseBody
	@RequestMapping(value="toggleEvaluateLike",method=RequestMethod.POST)
	public BookEvaluate toggleEvaluateLike(@RequestParam int evaluatecode, @RequestParam String eval, Model model,HttpSession httpsession) {
		//TODO 반드시 세션에서 동일 유저가 맞는지 검증이 필요!! 하지 않으면 해킹 위험이 있습니다.
		EvaluateLikeDAO dao = session.getMapper(EvaluateLikeDAO.class);
		BookEvaluateDAO evaldao = session.getMapper(BookEvaluateDAO.class);
		String sessionid=(String) httpsession.getAttribute("sessionid");

		evaluatelike.setEvaluatecode(evaluatecode);
		evaluatelike.setUserid(sessionid);
		evaluatelike.setEval(eval);
		EvaluateLike beforeEval = dao.duplicateCheck(evaluatelike);

		//이미 좋아요나 싫어요를 해당 평가에 표시했는지 검사
		if(beforeEval != null) {
			if(beforeEval.getEval().equals(eval)) {
				//같은경우 해당 평가를 지우기만 한다.
				dao.delete(evaluatelike);
			}else {
				//다른 경우에는 평가를 업데이트한다.
				dao.toggleBothLikeAndDislike(evaluatelike);
			}
		}else {
		//한번도 안눌렀었던 경우 좋아요/싫어요에 1 추가하고 해당 열을 삽입.
		dao.insert(evaluatelike);
		}
		BookEvaluate bookEvaluate = evaldao.selectByCode(evaluatecode);
		beanProcessor.addUserLikeDataToBookEvaluate(bookEvaluate, sessionid);
		return bookEvaluate;
	}
	/**
	 * 특정 독후감에 대하여 좋아요/싫어요를 눌렀을 때, 좋아요/싫어요를 증가시키거나 취소, 변경시킵니다.
	 * @param boardcode 좋아요/싫어요를 증가시킬 게시글의 코드입니다.
	 * @param boardname 좋아요/싫어요를 증가시킬 게시글의 게시판명입니다.
	 * @param eval '좋아요' 혹은 '싫어요'입니다.
	 * @param model
	 * @param httpsession
	 * @return
	 * @author : 김영호
	 * @date : 2018. 8. 27. 오전 11:37:12
	 */
	@ResponseBody
	@RequestMapping(value="toggleBoardLike",method=RequestMethod.POST)
	public Board toggleBoardLike(@RequestParam int boardcode,@RequestParam String boardname, @RequestParam String eval, Model model,HttpSession httpsession) {
		//TODO 반드시 세션에서 동일 유저가 맞는지 검증이 필요!! 하지 않으면 해킹 위험이 있습니다.
		BoardLikeDAO dao = session.getMapper(BoardLikeDAO.class);
		BoardDAO boarddao = session.getMapper(BoardDAO.class);
		String sessionid=(String) httpsession.getAttribute("sessionid");
		BoardLike boardlike = new BoardLike();
		boardlike.setBoardcode(boardcode);
		boardlike.setBoardname(boardname);
		boardlike.setUserid(sessionid);
		boardlike.setEval(eval);
		BoardLike beforeEval = dao.duplicateCheck(boardlike);

		//이미 좋아요나 싫어요를 해당 평가에 표시했는지 검사
		if(beforeEval != null) {
			if(beforeEval.getEval().equals(eval)) {
				//같은경우 해당 평가를 지우기만 한다.
				dao.delete(boardlike);
			}else {
				//다른 경우에는 평가를 업데이트한다.
				dao.toggleBothLikeAndDislike(boardlike);
			}
		}else {
		//한번도 안눌렀었던 경우 좋아요/싫어요에 1 추가하고 해당 열을 삽입.
		dao.insert(boardlike);
		}
		Board board = new Board();
		board.setBoardname(boardname);
		board.setCode(boardcode);
		board = boarddao.selectByCodeAndBoardName(board);
		beanProcessor.addUserLikeDataToBoard(board, sessionid);
		return board;
	}
	/**
	 * 특정 책에 대한 중고거래 페이지를 띄워줍니다.
	 * @param bookcode 띄울 책 코드입니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 8. 27. 오후 2:24:47
	 */
	@RequestMapping(value="usedBookListPage",method=RequestMethod.GET)
	public String usedBookListPage(Model model, @RequestParam int bookcode, @RequestParam(defaultValue="구매가능") String mode) {
		BookDAO dao = session.getMapper(BookDAO.class);
		UsedDAO usedDAO =session.getMapper(UsedDAO.class);
		model.addAttribute("book", dao.selectBook(bookcode));
		if(mode.equals("구매가능")) {
			ArrayList<UsedSell> usedsells = usedDAO.selectUsedSellByBookcodeBuyableOnly(bookcode);
			model.addAttribute("usedsellnum",usedsells.size());
			model.addAttribute("usedsell",usedsells);
			model.addAttribute("mode",0);
		}else {
			model.addAttribute("usedsellnum",usedDAO.countUsedSellByBookCode(bookcode));
			model.addAttribute("usedsell",usedDAO.selectUsedSellWithBookCode(bookcode));
			model.addAttribute("mode",1);
		}
		return "used/usedbooklist.page";
	}
	/**
	 * 특정 책에 대한 중고 거래 판매글을 등록합니다.
	 * @param bookcode 등록후 리다이렉트할 중고거래 코드입니다. 없을 경우 중고거래 메인페이지로 되돌아갑니다.
	 * @param usedsell 
	 * @return 중고거래 리스트로 리다이렉트됩니다.
	 * @author : 김영호
	 * @date : 2018. 8. 28. 오전 11:17:46
	 */
	@RequestMapping(value="addUsedBookSell", method=RequestMethod.POST)
	public String addUsedBookSell(Model model, @RequestParam int bookcode, @ModelAttribute UsedSell usedsell, HttpSession httpsession) {
		//TODO 로그인 검증 필요
		UsedDAO dao = session.getMapper(UsedDAO.class);
		model.addAttribute("bookcode",bookcode);
		usedsell.setSellerid((String)httpsession.getAttribute("sessionid"));
		dao.insertUsedSell(usedsell);
		return "redirect:usedBookListPage";
	}
	/**
	 * (REST) 중고 장바구니에 항목을 추가합니다.
	 * @param usedsellcode - 장바구니 코드입니다.
	 * @param amount -추가할 갯수입니다.
	 * @return 성공시 success, 중복시 duplicate를 리턴합니다.
	 * @author : 김영호
	 * @date : 2018. 8. 29. 오전 9:05:24
	 */
	@ResponseBody
	@RequestMapping(value="addUsedBasket", method=RequestMethod.POST)
	public String addUsedBasket(@RequestParam int usedsellcode, @RequestParam int amount,HttpSession httpsession) {
		UsedDAO dao = session.getMapper(UsedDAO.class);
		UsedBasket basket = new UsedBasket();
		String userid=(String)httpsession.getAttribute("sessionid");
		basket.setUsedsellcode(usedsellcode);
		basket.setAmount(amount);
		basket.setUserid(userid);
		if(dao.usedBasketDuplicationCheck(basket)>0) {
			return "duplicate";
		}else if(dao.selectUsedSellByCode(usedsellcode).getSellerid().equals(userid)) {
			return "selfbuy";
		}
		dao.insertUsedBasket(basket);
		return "success";
	}
	/**
	 * 중고 장바구니 주문페이지를 띄워줍니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 8. 29. 오전 10:40:54
	 */
	@RequestMapping(value="usedBasketPage",method=RequestMethod.GET)
	public String usedBasketPage(Model model,HttpSession httpsession) {
		UsedDAO usedDAO = session.getMapper(UsedDAO.class);
		UserDAO userDAO = session.getMapper(UserDAO.class);
		AddressDAO addressDAO = session.getMapper(AddressDAO.class);
		String sessionid = (String)httpsession.getAttribute("sessionid");

		//@author 이태민
		/* 배송지 등에 나타낼 유저 정보를 넣는다.*/
		User user = userDAO.selectUser(sessionid);
		model.addAttribute("user", user);
		/* 배송지 주소록을 불러온다. */
		ArrayList<Address> addressList = addressDAO.selectUserAddress(sessionid);
		model.addAttribute("addressList", addressList);
		
		//바스켓리스트 불러오고, 가격총량 계산 및 판매자수 측정
		ArrayList<UsedBasket> usedBasketList = usedDAO.selectUsedBasket(sessionid);
		int[] price = businessCaclulator.CalculateFinalPriceFromUsedBasket(usedBasketList);

		//최종가격 합산
		model.addAttribute("usedbasket",usedBasketList);
		model.addAttribute("booktotalprice",price[0]);
		model.addAttribute("shippingprice",price[1]);
		model.addAttribute("finalprice",price[2]);
		return "used/used_order.page";
	}
	/**
	 * 중고장바구니에서특정 유저의 특정 항목을 삭제합니다. 유저는 세션을 기준으로 삭제합니다.
	 * @param usedSellCode usedbasket 내의 usedSellCode입니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 8. 29. 오후 1:46:19
	 */
	@RequestMapping(value="removeUsedBasket", method=RequestMethod.GET)
	public String removeUsedBasket(@RequestParam int usedSellCode, HttpSession httpsession) {
		//TODO 아 로그인검증..해야..되는데..
		UsedDAO usedDAO = session.getMapper(UsedDAO.class);
		UsedBasket basket = new UsedBasket();
		basket.setUsedsellcode(usedSellCode);
		basket.setUserid((String)httpsession.getAttribute("sessionid"));
		usedDAO.removeUsedBasket(basket);
		return "redirect:usedBasketPage";
	}
	/**
	 * 특정 유저가 중고거래에서 구매하기 버튼을 눌렀을 경우 해당 아이템을 장바구니에 넣고 바로 이동시킵니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 8. 30. 오후 12:04:45
	 */
	@RequestMapping(value="buyUsedBookImmediate")
	public String buyUsedBookImmediate(@RequestParam int usedsellcode, @RequestParam int amount, HttpSession httpsession) {
		UsedDAO dao = session.getMapper(UsedDAO.class);
		UsedBasket basket = new UsedBasket();
		String userid = (String)httpsession.getAttribute("sessionid");
		basket.setUsedsellcode(usedsellcode);
		basket.setAmount(amount);
		basket.setUserid(userid);
		if(dao.selectUsedSellByCode(usedsellcode).getSellerid().equals(userid)) {
			return "redirect:usedBasketPage";
		}
		if(dao.usedBasketDuplicationCheck(basket)==0) {
			dao.insertUsedBasket(basket);
		}else {
			dao.updateAmountOnUsedBasket(basket);
		}
		return "redirect:usedBasketPage";
	}
	/**
	 * 중고거래 결제 후 중고거래 완료 페이지를 띄워줍니다. 오류가 발생하면 모델에 해당 내용을 저장합니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 8. 29. 오후 3:19:46
	 */
	@RequestMapping(value="buyUsedBook",method=RequestMethod.POST)
	public String buyUsedBook(Model model, @ModelAttribute UsedTrade usedtrade,HttpSession httpsession) {

		UsedDAO usedDAO = session.getMapper(UsedDAO.class);
		UserDAO userDAO = session.getMapper(UserDAO.class);
		String sessionid = (String)httpsession.getAttribute("sessionid");
		int beforePoint = userDAO.selectUser(sessionid).getPoint();
		int afterPoint = 0;
		
		int totalUsedPoint = 0;
		ArrayList<UsedBasket> usedbasket = usedDAO.selectUsedBasket(sessionid);
		HashMap<String, ArrayList<UsedBasket>> usedbasketOrderedBySeller = new HashMap<>();
		boolean flag_duplication = false;
		
		//판매자의 재고가 이미 부족하지는않은지 검증
		ArrayList<String> 빡구리스트 = new ArrayList<>();
		for(UsedBasket one : usedbasket){
			if(one.getAmount()>one.getStock()) {
				빡구리스트.add(one.getBookname());
			}
		}
		if(빡구리스트.size()>0) {
			model.addAttribute("fail", "해당 책의 재고가 부족하여 구매에 실패했습니다.");
			model.addAttribute("faillist",빡구리스트);
			return "used/used_order_fail.page";
		}

		//포인트 부족하면 바로빡구
		int[] price = businessCaclulator.CalculateFinalPriceFromUsedBasket(usedbasket);
		if(beforePoint-price[2]<0) {
			model.addAttribute("fail","포인트가 부족하여 거래에 실패했습니다.");
			return "used/used_order_fail.page";
		}
		
		//해시맵을 이용하여 판매자별로 usedbasket을 모은다.
		for(UsedBasket one : usedbasket) {
			flag_duplication=false;
			for(String seller : usedbasketOrderedBySeller.keySet()) {
				if(seller.equals(one.getSellerid())) {
					//판매자 이미 있으므로 해당 판매자의 arraylist를 받아와서 추가
					usedbasketOrderedBySeller.get(one.getSellerid()).add(one);
					flag_duplication=true;
					break;
				}
			}
			if(flag_duplication==false) {
				ArrayList<UsedBasket> usedBasketList = new ArrayList<UsedBasket>();
				usedbasketOrderedBySeller.put(one.getSellerid(),usedBasketList);
				usedbasketOrderedBySeller.get(one.getSellerid()).add(one);
			}
		}

		//hashmap에 모아진 usedbasket을 사용하여 하나씩 인서트
		UsedTrade eachtrade = new UsedTrade();
		UsedTradeProduct usedTradeProduct = new UsedTradeProduct();
		UsedSell usedsell = new UsedSell();
		for(String one : usedbasketOrderedBySeller.keySet()) {
			//추가
			int eachfinalprice = 0;
			eachtrade.setBuyerid(sessionid);
			eachtrade.setSellerid(one);
			eachtrade.setShippingprice(2500);
			eachtrade.setScore(0);
			eachtrade.setState("입금대기중");
			eachtrade.setReceivertell(usedtrade.getReceivertell());
			eachtrade.setReceiverphone(usedtrade.getReceiverphone());
			eachtrade.setReceivername(usedtrade.getReceivername());
			eachtrade.setPostno(usedtrade.getPostno());
			eachtrade.setAddress1(usedtrade.getAddress1());
			eachtrade.setAddress2(usedtrade.getAddress2());
			eachtrade.setReturnfinance("난계좌없다");
			eachtrade.setReturnbank("은행도없다고 계좌가없는데 있겠냐");
			usedDAO.insertUsedTrade(eachtrade);
			int usedTradeKey = eachtrade.getCode();
			System.out.println(usedTradeKey);
			for(UsedBasket two : usedbasketOrderedBySeller.get(one)) {
				usedTradeProduct.setUsedsell(two.getCode());
				usedTradeProduct.setUsedtradecode(usedTradeKey);
				usedTradeProduct.setPrice(two.getPrice());
				usedTradeProduct.setAmount(two.getAmount());
				usedDAO.insertUsedTradeProduct(usedTradeProduct);

				//usedsell의 재고 차감 , 0일경우 거래중으로 변경, -1이하면??나도모름
				int nowstock = two.getStock()-two.getAmount();
				usedsell.setStock(nowstock);
				usedsell.setCode(two.getCode());

				if(nowstock > 0) {
					usedDAO.updateStockOnUsedSell(usedsell);
				}else if(nowstock == 0) {
					usedsell.setState("거래중");
					usedDAO.updateStockOnUsedSell(usedsell);
					usedDAO.updateStateOnUsedSell(usedsell);
				}else{
					//아 망한건데.. 어카지?
				}
				eachfinalprice += two.getPrice()*two.getAmount();
				totalUsedPoint+=two.getPrice()*two.getAmount();
			}
			totalUsedPoint+=2500;
			eachtrade.setFinalprice(eachfinalprice);
			usedDAO.updateFinalPriceOnUsedTrade(eachtrade);
		}
		//사용자 포인트 거래량만큼 차감
		User user = new User();
		user.setId(sessionid);
		user.setPoint(totalUsedPoint);
		userDAO.subtractUserPoint(user);
		afterPoint= beforePoint-totalUsedPoint;
		usedDAO.deleteUserBasketAll(sessionid);
		
		model.addAttribute("beforepoint", beforePoint);
		model.addAttribute("totalusedpoint", totalUsedPoint);
		model.addAttribute("afterpoint", afterPoint);
		return "used/used_order_result.page";
	}
	/**
	 * 중고장터페이지를 띄워줍니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 8. 30. 오후 3:38:27
	 */
	@RequestMapping(value="usedMainPage", method=RequestMethod.GET)
	public String usedMainPage(Model model, @RequestParam(defaultValue="구매가능")String mode) {
		UsedDAO usedDAO = session.getMapper(UsedDAO.class);
		if(mode.equals("구매가능")) {
			model.addAttribute("usedsell",usedDAO.selectUsedSellBuyableOnly());
			model.addAttribute("mode",0);

		}else {
			model.addAttribute("usedsell", usedDAO.selectUsedSell());
			model.addAttribute("mode",1);
		}
		return "used/used_main.page";
	}
	/**
	 * (REST) 책 이름으로 해당 책을 모두 검색하여 json으로 반환합니다.
	 */
	@ResponseBody
	@RequestMapping(value="searchByBookName",method=RequestMethod.POST)
	public ArrayList<Book> searchByBookName(String name) {
		BookDAO bookDAO = session.getMapper(BookDAO.class);
		return bookDAO.selectBookSearchByName(name);
	}
	/**
	 * 해당 판매자와 연관된 상품을 모두 json으로 반환합니다.
	 * @param sellerid 판매자 id입니다.
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 5. 오후 12:16:42
	 */
	@ResponseBody
	@RequestMapping(value="usedSellRelatedSeller",method=RequestMethod.POST)
	public ArrayList<UsedSell> usedSellRelatedSeller(@RequestParam String sellerid){
		UsedDAO dao = session.getMapper(UsedDAO.class);
		return dao.selectUsedSellBySellerId(sellerid);
	}
	/**
	 * (REST) 특정 판매자의 정보를 리턴합니다.
	 * @param sellerid
	 * @return
	 * @author : 김영호
	 * @date : 2018. 9. 5. 오후 2:27:56
	 */
	@ResponseBody
	@RequestMapping(value="getSellerData",method=RequestMethod.POST)
	public User getSellerData(@RequestParam String sellerid){
		UserDAO dao = session.getMapper(UserDAO.class);
		return dao.selectUser(sellerid);
	}

	@ResponseBody
	@RequestMapping(value="sellerEvaluateList",method=RequestMethod.POST)
	public ArrayList<UsedTrade> sellerEvaluateList(@RequestParam String sellerid){
		UsedDAO dao = session.getMapper(UsedDAO.class);
		return dao.selectUsedTradeBySellerId(sellerid);
	}

}

