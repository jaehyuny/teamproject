package com.team.project;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.team.project.entities.Basket;
import com.team.project.entities.Board;
import com.team.project.entities.BookEvaluate;
import com.team.project.entities.Buyrequest;
import com.team.project.entities.Coupon;
import com.team.project.entities.Grade;
import com.team.project.entities.UsedSell;
import com.team.project.entities.UsedTrade;
import com.team.project.entities.User;
import com.team.project.service.BoardDAO;
import com.team.project.service.BookEvaluateDAO;
import com.team.project.service.BuyrequestDAO;
import com.team.project.service.CouponDAO;
import com.team.project.service.UsedDAO;
import com.team.project.service.UserDAO;

@Controller
public class UserController {

	@Autowired
	private SqlSession sqlSession;
	@Autowired
	private User user;
	@Autowired
	private Grade grade;

	/**
	 * 회원가입 창으로 이동합니다.
	 * @return
	 */
	@RequestMapping(value = "/userInsertForm", method = RequestMethod.GET)
	public String userInsertForm() {
		return "user/user_insert_form.page";
	}

	@ResponseBody
	@RequestMapping(value = "/userConfirm", method = RequestMethod.POST)
	public int userConfirm(@RequestParam String id) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		int data = dao.selectByid(id);
		return data;
	}

	@RequestMapping(value = "/userInsert", method = RequestMethod.GET)
	public String userInsert(@ModelAttribute("user") User user, RedirectAttributes redirectAttributes) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		int defaultGrade = 1;
		int defaultPoint = 0;
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		String date = format.format(new Date());
		user.setGrade(defaultGrade);
		user.setPoint(defaultPoint);
		user.setJointime(date);
		dao.insertRow(user);
		redirectAttributes.addFlashAttribute("user", user);
		return "redirect:login";
	}
	
	/**
	 * 로그인 창으로 이동합니다
	 * @return
	 */
	@RequestMapping(value = "/loginForm", method = RequestMethod.GET)
	public String loginForm() {
		return "user/login_form.page";
	}

	@ResponseBody
	@RequestMapping(value = "/loginCheck", method = RequestMethod.POST)
	public int loginCheck(@RequestParam String id, @RequestParam String password) {
		user.setId(id);
		user.setPassword(password);
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		int data = dao.loginCheck(user);
		return data;
	}

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(@ModelAttribute("user") User user, HttpSession session, Model model) {
		/* id와 name을 세션에 저장 */
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		User users = dao.selectUser(user.getId());
		String name = users.getName();
		String nickname = users.getNickname();
		
		dao.updateConnectTime(user.getId());
		
		session.setAttribute("sessionid", user.getId().toString());
		session.setAttribute("sessionname", name);
		session.setAttribute("sessionnick", nickname);
		/* 장바구니 물품 개수 표시 세션 저장 */
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		ArrayList<Basket> basketList = buyrequestDAO.selectBasket(user.getId());
		int basketListCount = basketList.size();
		session.setAttribute("sessionBasketCount", basketListCount);
        /* 회원등급 세션에 저장 */
        user = dao.selectUser(user.getId());
        int gradeNum = user.getGrade();
        grade = dao.selectUserGrade(gradeNum);
        session.setAttribute("sessionGrade", grade);    //sessionGrade에 userGrade 저장
		
		return "redirect:mainPage";
	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logoutForm(HttpSession session) {
		session.invalidate();
		return "redirect:mainPage";
	}
	
	/**
	 * 회원정보수정 홈으로 이동합니다.
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/userInfo", method = RequestMethod.GET)
	public String userInfo(HttpSession session, Model model) {
		String id = session.getAttribute("sessionid").toString();
		/* point 정보, grade 정보 출력 */
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		User user = dao.selectUser(id);
		model.addAttribute("user", user);
		/* 쿠폰 정보 출력 */
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		model.addAttribute("owncoupon", couponDAO.selectOwnCoupon(id));
		/* 독후감 정보 출력 */
		BoardDAO boardDAO = sqlSession.getMapper(BoardDAO.class);
		model.addAttribute("countreview", boardDAO.countReview(id));
		/* 최근 주문수 및 주문 정보 출력 */
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		int ordercount = buyrequestDAO.selectOrderCount(id);
		model.addAttribute("ordercount", ordercount);
		ArrayList<Buyrequest> buyrequests = buyrequestDAO.selectForUserinfo(id);
		model.addAttribute("buyrequests", buyrequests);
		/* 결제액 총액 및 3개월간 결제액 출력 */
		Buyrequest ordersum = buyrequestDAO.selectForSum(id);
		HashMap hashMap = new HashMap();
		hashMap.put("totalsum", ordersum.getTotalsum());
		hashMap.put("threemonthsum",ordersum.getThreemonthsum());
		model.addAttribute("ordersum",hashMap);
		return "user/userinfo/user_info.userinfo"; 
	}
	
	/**
	 * 회원정보수정 창입니다.
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/userInfoUpForm", method = RequestMethod.GET)
	public String userInfoUpForm(HttpSession session, Model model) {
		String id = session.getAttribute("sessionid").toString();
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		User user = dao.selectUser(id);
		model.addAttribute("user", user);
		return "user/userinfo/user_update_form.userinfo";
	}
	@ResponseBody
	@RequestMapping(value = "/userInfoUpdate", method = RequestMethod.POST)
	public int userInfoUpdate(@ModelAttribute("user") User user) {
		System.out.println("여기까지 옴");
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		int data;
		try {
			dao.updateUserInfo(user);
			data = 1;
		} catch (Exception e) {
			data = 0;
		}
		return data;
	}
	
	/**
	 * 회원 탈퇴 창입니다.
	 * @return
	 */
	@RequestMapping(value = "/userInfoDelForm", method = RequestMethod.GET)
	public String userInfoDelForm() {
		return "user/userinfo/user_delete_form.userinfo";
	}

	@RequestMapping(value = "/userInfoDelete", method = RequestMethod.GET)
	public String userInfoDelete(@ModelAttribute("user") User user, Model model, HttpSession session) {
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		int data;
		if (dao.loginCheck(user) == 1) {
			dao.deleteUserInfo(user);
			session.invalidate();
			data = 1;
		} else {
			data = 0;
		}
		model.addAttribute("flag", data);
		return "user/userinfo/user_delete_result.page";
	}
	
	/**
	 * 비밀번호변경 창입니다.
	 * @return
	 */
	@RequestMapping(value = "/passwordUpForm", method = RequestMethod.GET)
	public String passwordUpForm() {
		return "user/userinfo/user_password_form.userinfo";
	}
	@ResponseBody
	@RequestMapping(value = "/passwordUpdate", method = RequestMethod.POST)
	public int passwordUpdate(@RequestParam String id, @RequestParam String password,
			@RequestParam String newpassword) {
		int data;
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		user.setId(id);
		user.setPassword(password);
		if(dao.loginCheck(user)==1) {
			HashMap hashMap = new HashMap();
			hashMap.put("id", id);
			hashMap.put("password", password);
			hashMap.put("newpassword", newpassword);
			dao.updatePassword(hashMap);
			data = 1;
		} else {			
			data = 0;
		}
		return data;		
	}
	
	/**
	 * 커뮤니티정보 중 평가 창입니다. 
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/myComment", method=RequestMethod.GET)
	public String myComment(HttpSession session, Model model) {
		String id = session.getAttribute("sessionid").toString();
		BookEvaluateDAO bookEvaluateDAO = sqlSession.getMapper(BookEvaluateDAO.class);
		ArrayList<BookEvaluate> evaluates = bookEvaluateDAO.selectByUserid(id);
		/* 최신순으로 정렬 */
		Collections.reverse(evaluates); 
		model.addAttribute("evaluates", evaluates);
		return "user/userinfo/my_comment_form.userinfo";
	}
	/**
	 * 커뮤니티정보 중 독후감 창입니다.
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/myReview", method=RequestMethod.GET)
	public String myReview(HttpSession session, Model model) {
		String id = session.getAttribute("sessionid").toString();
		BoardDAO boardDAO = sqlSession.getMapper(BoardDAO.class);
		ArrayList<Board> reviews = boardDAO.selectByUserid(id);
		/* 최신순으로 정렬 */
		Collections.reverse(reviews); 
		model.addAttribute("reviews", reviews);		
		return "user/userinfo/my_review_form.userinfo";
	}
	
	/**
	 * 포인트 및 쿠폰 중 쿠폰 창입니다.
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/myCoupon", method=RequestMethod.GET)
	public String myCoupon(HttpSession session, Model model) {
		String id = session.getAttribute("sessionid").toString();
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		ArrayList<Coupon> coupons = couponDAO.selectUserCoupon(id);
		ArrayList<Coupon> normal = new ArrayList<Coupon>();
		ArrayList<Coupon> delivery = new ArrayList<Coupon>();		
		for(Coupon coupon : coupons) {			
			if(coupon.getIsfreeshiping()==0) {
				normal.add(coupon);				
			} else if(coupon.getIsfreeshiping()==1) {
				delivery.add(coupon);
			}
		}		
		model.addAttribute("normal", normal);
		model.addAttribute("delivery", delivery);		
		return "user/userinfo/my_coupon_form.userinfo";
	}
	/**
	 * 포인트 및 쿠폰 중 포인트 창입니다.
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/myPoint", method=RequestMethod.GET)
	public String myPoint(HttpSession session, Model model) {
		String id = session.getAttribute("sessionid").toString();
		/* 현재 point 정보 출력 */
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		User user = dao.selectUser(id);
		model.addAttribute("user", user);
		/* point 내역 출력 */
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		ArrayList<Buyrequest> points = buyrequestDAO.selectForPoint(id);
		int fir = user.getPoint(), sec;
		for(Buyrequest point : points) {
			sec = fir - point.getStackpoint();
			point.setStackpoint(fir);
			fir = sec;			
		}
		model.addAttribute("points", points);
		return "user/userinfo/my_point_form.userinfo";
	}
	
	/**
	 * 회원정보 중 중고구입
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="myUsedBuy", method=RequestMethod.GET)
	public String myUsedBuy(HttpSession session, Model model) {
		String id = session.getAttribute("sessionid").toString();
		UsedDAO usedDAO = sqlSession.getMapper(UsedDAO.class);
		ArrayList<UsedTrade> usedtrades = usedDAO.selectUsedTrade(id);		
		model.addAttribute("usedtrades", usedtrades);
		return "user/userinfo/my_used_buy.userinfo";
	}
	@RequestMapping(value="myUsedBuyInput", method=RequestMethod.GET)
	public String myUsedBuyInput(@RequestParam String evaltext, @RequestParam int score,
			HttpSession session) {
		String id = session.getAttribute("sessionid").toString();
		HashMap hashMap = new HashMap();
		hashMap.put("evaltext", evaltext);
		hashMap.put("score", score);
		hashMap.put("buyerid", id);
		UsedDAO usedDAO = sqlSession.getMapper(UsedDAO.class);
		usedDAO.updateScoreEvaltext(hashMap);		
		return "redirect:myUsedBuy";
	}		
	@RequestMapping(value="myUsedComplete", method=RequestMethod.GET)
	public String myUsedComplete(HttpSession session, @RequestParam int code) {		
		UsedDAO usedDAO = sqlSession.getMapper(UsedDAO.class);
		usedDAO.updateStateComplete(code);			
		return "redirect:myUsedBuy";
	}
	
	/**
	 * 회원정보 중 중고거래판매
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="myUsedSell", method=RequestMethod.GET)
	public String myUsedSell(HttpSession session, Model model) {
		String id = session.getAttribute("sessionid").toString();
		UsedDAO usedDAO = sqlSession.getMapper(UsedDAO.class);
		ArrayList<UsedSell> usedsells = usedDAO.selectUsedSellByid(id);
		model.addAttribute("usedsells", usedsells);
		return "user/userinfo/my_used_sell.userinfo"; 
	}
	
	/**
	 * 회원정보 중 일반주문 창입니다.
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="myOrder", method=RequestMethod.GET)
	public String myOrder(HttpSession session, Model model) {
		String id = session.getAttribute("sessionid").toString();
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		ArrayList<Buyrequest> buyrequests = buyrequestDAO.selectForMyOrder(id);
		model.addAttribute("buyrequests", buyrequests);
		return "user/userinfo/my_order_form.userinfo";
	}
	@RequestMapping(value="myOrderDetail", method=RequestMethod.GET)
	public String myOrderDetail(@RequestParam String code, Model model) {
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		Buyrequest order = buyrequestDAO.selectByCode(code);
		model.addAttribute("order", order);
		ArrayList<Buyrequest> booknames = buyrequestDAO.selectBookname(code);
		model.addAttribute("booknames",booknames);		
		return "user/userinfo/my_order_detail.userinfo";
	}
	
	@RequestMapping(value="myQuestion", method=RequestMethod.GET)
	public String myQuestion(HttpSession session, Model model) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		if(session.getAttribute("sessionid") == null) {
			return "user/login_form.page";
		}
		if(!session.getAttribute("sessionid").equals("admin@nullpointers.com")) {
			ArrayList<Board> myqna = dao.myQnaList((String)session.getAttribute("sessionid"));
			model.addAttribute("myqna",myqna);
		}else {
			ArrayList<Board> allqna = dao.allQnaList();
			model.addAttribute("allqna",allqna);
		}
		return "faq/my_question.faqinfo";
	}
	/* 문의하기 */
	@RequestMapping(value="contactUs", method=RequestMethod.GET)
	public String contactUs(HttpSession session) {
		return "faq/contact_us.faqinfo";
	}
	/**
	 * 
	 * @param board 입력될 폼 정보
	 * @param request 파일 저장 경로
	 * @param qnaimage 이미지 파일
	 * @return 내문의 목록으로 리다이렉트
	 * @author 신지호
	 * 2018. 9. 21.
	 */
	@RequestMapping(value="qnaInsert", method=RequestMethod.POST)
	public String qnsInsert(@ModelAttribute Board board,HttpServletRequest request,@RequestParam CommonsMultipartFile qnaimage) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		HttpSession session = request.getSession();
		String uploadPath = session.getServletContext().getRealPath("/");
		String realPath = session.getServletContext().getContextPath()+"/resources/images/";
		String fileName = qnaimage.getOriginalFilename();
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddhhmm");
		String uploadTime = format.format(date);
		String uploadFile = uploadTime+"_"+fileName;
		if(!fileName.equals("")) {
			try {
				byte[] bytes = qnaimage.getBytes();
				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(uploadPath+"resources/images/"+uploadFile));
				output.write(bytes);
				output.flush();
				output.close();
				board.setAttachfile(realPath+uploadFile);
			} catch (Exception e) {
				System.out.println("error : "+e.getMessage());
			}
		}
		board.setIp(request.getRemoteAddr());
		dao.insertQna(board);
		return "redirect:myQuestion";
	}
	
	
	@RequestMapping(value = "myQnaDetail", method = RequestMethod.GET)
	public String myQnaDetail(Model model,@RequestParam int code,@RequestParam String boardname) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		Board board = new Board();
		board.setCode(code);
		board.setBoardname(boardname);
		board = dao.selectByCodeAndBoardName(board);
		if(board.getRef()==1) {
			board.setQnastate("답변완료");
		}else {
			board.setQnastate("답변대기");
		}
		if(board.getAttachfile()!=null) {
			String[] filePath = board.getAttachfile().split("/");
			int size = filePath.length;
			String fileName = filePath[size-1];
			board.setFilename(fileName);
		}
		model.addAttribute("board",board);
		return "faq/my_qna_detail.faqinfo";
		
	}
	
	@RequestMapping(value="answerQna", method=RequestMethod.POST)
	public String answerQna(@RequestParam int code, @RequestParam String boardname, @RequestParam String content) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		Board board = new Board();
		board.setCode(code);
		board.setBoardname(boardname);
		board.setContent(content);
		dao.answerQna(board);
		return "redirect:myQnaDetail?code="+board.getCode()+"&boardname="+board.getBoardname();
	}
	
	@RequestMapping(value = "/boardDownload", method = RequestMethod.GET)
	 public ModelAndView boardDownload(@RequestParam String b_attach, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String uploadPath = session.getServletContext().getRealPath("/");
		File file = new File(uploadPath+"resources/images/"+b_attach); 
		return new ModelAndView("download","downloadFile",file);
	}
}
