package com.team.project;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.Optional;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.team.project.entities.Board;
import com.team.project.entities.Book;
import com.team.project.entities.Buyrequest;
import com.team.project.service.BoardDAO;
import com.team.project.service.BookDAO;
import com.team.project.service.BuyrequestDAO;
import com.team.project.submodule.ChatNicknames;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Autowired
	private SqlSession sqlSession;
	@Inject
	private ChatNicknames chatNicknames;

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, @ModelAttribute("notLogin") String notLogin) {
		logger.info("Welcome home! The client locale is {}.", locale);

		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);

		String formattedDate = dateFormat.format(date);

		model.addAttribute("serverTime", formattedDate);
		model.addAttribute("notLogin", notLogin);

		/* 베스트셀러 출력 */
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		ArrayList<Buyrequest> bestsellers = buyrequestDAO.selectBestseller();		
		model.addAttribute("bestsellers", bestsellers);

		/* 신간 출력 */
		BookDAO bookDAO = sqlSession.getMapper(BookDAO.class);
		ArrayList<Book> books = bookDAO.selectAll();		
		ArrayList<Book> newbooks = new ArrayList<Book>();
		books.stream().limit(5).forEach(e -> newbooks.add(e));
		model.addAttribute("newbooks", newbooks);
		
		/* 독후감 정보 출력 */
		BoardDAO boardDAO = sqlSession.getMapper(BoardDAO.class);
		ArrayList<Board> boards = boardDAO.selectHotReview();
		model.addAttribute("boards",boards);		
		return "main.page";
	}

	@RequestMapping(value = "mainPage", method = RequestMethod.GET)
	public String mainPage() {
		return "redirect:/";
	}

	@RequestMapping(value = "veryOverPage", method = RequestMethod.GET)
	public String veryoverPage() {
		return "veryover";

	}

	@RequestMapping(value = "eventPage", method = RequestMethod.GET)
	public String eventPage() {
		return "event/event_main.page";

	}
	@RequestMapping(value = "faqPage", method = RequestMethod.GET)
	public String faqPage(Model model) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		ArrayList<Board> faq = dao.mostFaqList();
		ArrayList<Board> newfaq = new ArrayList<Board>();
		faq.stream().limit(5).forEach(e -> newfaq.add(e));
		model.addAttribute("faqs", newfaq);
		return "faq/faq_main.faqinfo";
		
	}
	@RequestMapping(value = "faqAll", method = RequestMethod.GET)
	public String faqAll(Model model) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		ArrayList<Board> faq = dao.faqList();
		model.addAttribute("faqs", faq);
		return "faq/faq_list.faqinfo";
		
	}
	
	@RequestMapping(value = "chat", method = RequestMethod.GET)
	public String chat(HttpSession session, Model model) {
		String userid = (String) Optional.ofNullable(session.getAttribute("sessionid")).orElse("익명");
		
		model.addAttribute("userid", userid);
//		SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		
		return "chat/chat.page";
	}


}
