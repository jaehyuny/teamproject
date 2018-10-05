package com.team.project;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

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

import com.team.project.entities.Author;
import com.team.project.entities.Board;
import com.team.project.entities.Book;
import com.team.project.entities.BuyRequestProduct;
import com.team.project.entities.Buyrequest;
import com.team.project.entities.Category;
import com.team.project.entities.Coupon;
import com.team.project.entities.Grade;
import com.team.project.entities.User;
import com.team.project.service.AuthorDAO;
import com.team.project.service.BoardDAO;
import com.team.project.service.BookDAO;
import com.team.project.service.BuyRequestProductDAO;
import com.team.project.service.BuyrequestDAO;
import com.team.project.service.CategoryDAO;
import com.team.project.service.CouponDAO;
import com.team.project.service.GradeDAO;
import com.team.project.service.UserDAO;
import com.team.project.submodule.Serial;


@Controller
public class AdminController {
	
	@Autowired
	private SqlSession sqlSession;
	@Autowired
	private com.team.project.entities.BoardPaging boardpaging;
	static String find;
	@Autowired
	private Serial serial;	
	
	@RequestMapping(value="/adminpage", method=RequestMethod.GET)
	public String adminPage(Model model) {	
		return "admin/adminpage.admininfo";
	}
	@RequestMapping(value="/usersearch", method=RequestMethod.GET)
	public String userSearch(Model model, String find) {
		if(find == null) {
			find = "";
		}
		this.find = find;
		int pagesize = 10;
		int startrow = 0;
		int endrow = startrow + pagesize;
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ArrayList<User> users = dao.selectAllPaging(boardpaging);
		int rowcount = dao.selectRowCount(find);
		int abspage = 1;
		if(rowcount % pagesize == 0) {
			abspage = 0;
		}
		int pagecount = rowcount / pagesize + abspage;
		if(pagecount > 10) {
			pagecount = 10;
		}
		int[] pages = new int[pagecount];
		for(int i = 0; i < pagecount; i++) {
			pages[i] = i+1;
		}
		model.addAttribute("users", users);
		model.addAttribute("pages",pages);
		model.addAttribute("pagenum",1);
		model.addAttribute("pagemax",pagecount);
		return "admin/user_search.admininfo";
	}
	@RequestMapping(value = "/userpageselected", method = RequestMethod.GET)
	public String userPageSelected(Model model, int page) {
		int pagesize = 10;
		int startrow = (page - 1) * (pagesize);
		int endrow = pagesize;
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ArrayList<User> users = dao.selectAllPaging(boardpaging);
		int rowcount = dao.selectRowCount(find);
		int abspage = 1;
		if(rowcount % pagesize == 0) {
			abspage = 0;
		}
		int pagecount = rowcount / pagesize + abspage;
		int firstpage = 1;
		int lastpage = 10;
		if(page % 10 == 1) {
			firstpage = page;
		}else if(page % 10 != 0 && page > 10){
			firstpage = page / 10 * 10 + 1;
		}else if(page % 10 == 0 && page > 10) {
			firstpage = (page / 10 - 1) * 10 + 1;
		}
		if(page % 10 != 0 && page/10 == pagecount/10) {
			lastpage = pagecount % 10;
		}
		int[] pages = new int[lastpage];
		for(int i = 0; i < lastpage; i++) {
			pages[i] = firstpage++;
		}
		model.addAttribute("users", users);
		model.addAttribute("pages",pages);
		model.addAttribute("pagenum",page);
		model.addAttribute("pagemax",pagecount);
		return "admin/user_search.admininfo";
	}
	@RequestMapping(value="/userupdateform", method=RequestMethod.GET)
	public String userUpdateForm(Model model, @RequestParam String id) {		
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		User user = dao.selectUser(id);
		GradeDAO gdao = sqlSession.getMapper(GradeDAO.class);
		ArrayList<Grade> grade = gdao.selectGrade();
		model.addAttribute("user", user);
		model.addAttribute("grade", grade);
		return "admin/user_update_form.admininfo";
	}
	@RequestMapping(value="/userupdate", method=RequestMethod.POST)
	public String userUpdate(@ModelAttribute User user) {		
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		dao.updateUser(user);
		return "redirect:usersearch";
	}
	@RequestMapping(value="/userdelete", method=RequestMethod.POST)
	public String userDelete(Model model, @RequestParam String id) {		
		UserDAO dao = sqlSession.getMapper(UserDAO.class);
		dao.deleteUser(id);
		return "redirect:usersearch";
	}
	@RequestMapping(value="/couponinsertform", method=RequestMethod.GET)
	public String couponInsertForm(Model model) {		
		CategoryDAO dao = sqlSession.getMapper(CategoryDAO.class);
		ArrayList<Category> categorys = dao.selectAll();
		model.addAttribute("categorys", categorys);
		return "admin/coupon_insert_form.admininfo";
	}
	@RequestMapping(value="/couponinsert", method=RequestMethod.POST)
	public String couponInsert(@ModelAttribute Coupon coupon, @RequestParam CommonsMultipartFile img, HttpSession session) {		
		if(coupon.getCatcondition().equals("")) {
			coupon.setCatcondition(null);
		}
		coupon.setImglink("");
		CouponDAO dao = sqlSession.getMapper(CouponDAO.class);
		dao.insertCoupon(coupon);
		int code = dao.selectCouponCode();
		String originalname = img.getOriginalFilename();
		String imgname = "";
		if(originalname.equals("")) {
		}else {
			imgname = code + ".png";
			try {
				String path = session.getServletContext().getRealPath("/resources/images/coupon/");
				byte bytes[] = img.getBytes();
				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(path+imgname));
				output.write(bytes);
				output.flush();
				output.close();
			}catch (Exception e) {
				
			}
		}
		return "redirect:couponsearch";
	}
	@RequestMapping(value="/couponsearch", method=RequestMethod.GET)
	public String couponSearch(Model model, String find) {		
		if(find == null) {
			find = "";
		}
		this.find = find;
		int pagesize = 20;
		int startrow = 0;
		int endrow = startrow + pagesize;
		CouponDAO dao = sqlSession.getMapper(CouponDAO.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ArrayList<Coupon> coupons = dao.selectCouponAllPaging(boardpaging);
		int rowcount = dao.selectRowCount(find);
		int abspage = 1;
		if(rowcount % pagesize == 0) {
			abspage = 0;
		}
		int pagecount = rowcount / pagesize + abspage;
		if(pagecount > 10) {
			pagecount = 10;
		}
		int[] pages = new int[pagecount];
		for(int i = 0; i < pagecount; i++) {
			pages[i] = i+1;
		}
		model.addAttribute("coupons", coupons);
		model.addAttribute("pages",pages);
		model.addAttribute("pagenum",1);
		model.addAttribute("pagemax",pagecount);
		return "admin/coupon_search.admininfo";
	}
	@RequestMapping(value = "/couponpageselected", method = RequestMethod.GET)
	public String couponPageSelected(Model model, int page) {
		int pagesize = 20;
		int startrow = (page - 1) * (pagesize);
		int endrow = pagesize;
		CouponDAO dao = sqlSession.getMapper(CouponDAO.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ArrayList<Coupon> coupons = dao.selectCouponAllPaging(boardpaging);
		int rowcount = dao.selectRowCount(find);
		int abspage = 1;
		if(rowcount % pagesize == 0) {
			abspage = 0;
		}
		int pagecount = rowcount / pagesize + abspage;
		int firstpage = 1;
		int lastpage = 10;
		if(page % 10 == 1) {
			firstpage = page;
		}else if(page % 10 != 0 && page > 10){
			firstpage = page / 10 * 10 + 1;
		}else if(page % 10 == 0 && page > 10) {
			firstpage = (page / 10 - 1) * 10 + 1;
		}
		if(page % 10 != 0 && page/10 == pagecount/10) {
			lastpage = pagecount % 10;
		}
		int[] pages = new int[lastpage];
		for(int i = 0; i < lastpage; i++) {
			pages[i] = firstpage++;
		}
		model.addAttribute("coupons", coupons);
		model.addAttribute("pages",pages);
		model.addAttribute("pagenum",page);
		model.addAttribute("pagemax",pagecount);
		return "admin/coupon_search.admininfo";
	}
	@RequestMapping(value="/coupondelete", method=RequestMethod.GET)
	public String couponDelete(@RequestParam String code) {
		CouponDAO dao = sqlSession.getMapper(CouponDAO.class);
		dao.deleteCoupon(code);
		return "redirect:couponsearch";
	}
	@RequestMapping(value="/couponupdateform", method=RequestMethod.GET)
	public String couponUpdateForm(Model model, @RequestParam int code) {		
		CouponDAO dao = sqlSession.getMapper(CouponDAO.class);
		Coupon coupons = dao.selectCoupon(code);
		CategoryDAO cdao = sqlSession.getMapper(CategoryDAO.class);
		ArrayList<Category> categorys = cdao.selectAll();
		model.addAttribute("coupons", coupons);
		model.addAttribute("categorys", categorys);
		return "admin/coupon_update_form.admininfo";
	}
	@RequestMapping(value="/couponupdate", method=RequestMethod.POST)
	public String couponUpdate(@ModelAttribute Coupon coupon, @RequestParam CommonsMultipartFile img, HttpSession session) {		
		if(coupon.getCatcondition().equals("")) {
			coupon.setCatcondition(null);
		}
		CouponDAO dao = sqlSession.getMapper(CouponDAO.class);
		dao.updateCoupon(coupon);
		int code = coupon.getCode();
		String originalname = img.getOriginalFilename();
		String imgname = "";
		if(originalname.equals("")) {
		}else {
			imgname = code + ".png";
			try {
				String path = session.getServletContext().getRealPath("/resources/images/coupon/");
				byte bytes[] = img.getBytes();
				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(path+imgname));
				output.write(bytes);
				output.flush();
				output.close();
			}catch (Exception e) {
				
			}
		}
		return "redirect:couponsearch";
	}
	@RequestMapping(value="/bookinsertform", method=RequestMethod.GET)
	public String bookInsertForm(Model model) {		
		AuthorDAO adao = sqlSession.getMapper(AuthorDAO.class);
		ArrayList<Author> authors = adao.selectAll();
		CategoryDAO dao = sqlSession.getMapper(CategoryDAO.class);
		ArrayList<Category> categorys = dao.selectAll();
		model.addAttribute("categorys", categorys);
		model.addAttribute("authors", authors);
		return "admin/book_insert_form.admininfo";
	}
	@RequestMapping(value="/bookinsert", method=RequestMethod.POST)
	public String bookInsert(@ModelAttribute Book book, @RequestParam CommonsMultipartFile img, HttpSession session) {		
		if(book.getCat1().equals("")) {
			book.setCat1(null);
		}
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		dao.insertBook(book);
		int code = dao.selectBookCode();
		String originalname = img.getOriginalFilename();
		String imgname = "";
		if(originalname.equals("")) {
		}else {
			imgname = code + ".jpg";
			try {
				String path = session.getServletContext().getRealPath("/resources/images/books/");
				byte bytes[] = img.getBytes();
				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(path+imgname));
				output.write(bytes);
				output.flush();
				output.close();
			}catch (Exception e) {
				
			}
		}
		return "redirect:booksearch";
	}
	@RequestMapping(value="/booksearch", method=RequestMethod.GET)
	public String bookSearch(Model model, String find) {		
		if(find == null) {
			find = "";
		}
		this.find = find;
		int pagesize = 12;
		int startrow = 0;
		int endrow = startrow + pagesize;
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ArrayList<Book> books = dao.selectAllPaging(boardpaging);
		int rowcount = dao.selectRowCount(find);
		int abspage = 1;
		if(rowcount % pagesize == 0) {
			abspage = 0;
		}
		int pagecount = rowcount / pagesize + abspage;
		if(pagecount > 10) {
			pagecount = 10;
		}
		int[] pages = new int[pagecount];
		for(int i = 0; i < pagecount; i++) {
			pages[i] = i+1;
		}
		model.addAttribute("books", books);
		model.addAttribute("pages",pages);
		model.addAttribute("pagenum",1);
		model.addAttribute("pagemax",pagecount);
		return "admin/book_search.admininfo";
	}
	@RequestMapping(value = "/bookpageselected", method = RequestMethod.GET)
	public String bookPageSelected(Model model, int page) {
		int pagesize = 12;
		int startrow = (page - 1) * (pagesize);
		int endrow = pagesize;
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ArrayList<Book> books = dao.selectAllPaging(boardpaging);
		int rowcount = dao.selectRowCount(find);
		int abspage = 1;
		if(rowcount % pagesize == 0) {
			abspage = 0;
		}
		int pagecount = rowcount / pagesize + abspage;
		int firstpage = 1;
		int lastpage = 10;
		if(page % 10 == 1) {
			firstpage = page;
		}else if(page % 10 != 0 && page > 10){
			firstpage = page / 10 * 10 + 1;
		}else if(page % 10 == 0 && page > 10) {
			firstpage = (page / 10 - 1) * 10 + 1;
		}
		if(page % 10 != 0 && page/10 == pagecount/10) {
			lastpage = pagecount % 10;
		}
		int[] pages = new int[lastpage];
		for(int i = 0; i < lastpage; i++) {
			pages[i] = firstpage++;
		}
		model.addAttribute("books", books);
		model.addAttribute("pages",pages);
		model.addAttribute("pagenum",page);
		model.addAttribute("pagemax",pagecount);
		return "admin/book_search.admininfo";
	}
	@RequestMapping(value="/bookdelete", method=RequestMethod.GET)
	public String bookDelete(@RequestParam int code) {
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		dao.deleteBook(code);
		return "redirect:booksearch";
	}
	@RequestMapping(value="/bookupdateform", method=RequestMethod.GET)
	public String bookUpdateForm(Model model, @RequestParam int code) {		
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		Book books = dao.selectBook(code);
		AuthorDAO adao = sqlSession.getMapper(AuthorDAO.class);
		ArrayList<Author> authors = adao.selectAll();
		CategoryDAO cdao = sqlSession.getMapper(CategoryDAO.class);
		ArrayList<Category> categorys = cdao.selectAll();
		model.addAttribute("books", books);
		model.addAttribute("categorys", categorys);
		model.addAttribute("authors", authors);
		return "admin/book_update_form.admininfo";
	}
	@RequestMapping(value="/bookupdate", method=RequestMethod.POST)
	public String bookUpdate(@ModelAttribute Book book, @RequestParam CommonsMultipartFile img, HttpSession session) {		
		if(book.getCat1().equals("")) {
			book.setCat1(null);
		}
		BookDAO dao = sqlSession.getMapper(BookDAO.class);
		dao.updateBook(book);
		int code = book.getCode();
		String originalname = img.getOriginalFilename();
		String imgname = "";
		if(originalname.equals("")) {
		}else {
			imgname = code + ".jpg";
			try {
				String path = session.getServletContext().getRealPath("/resources/images/books/");
				byte bytes[] = img.getBytes();
				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(path+imgname));
				output.write(bytes);
				output.flush();
				output.close();
			}catch (Exception e) {
				
			}
		}
		return "redirect:booksearch";
	}
	@RequestMapping(value="/authorsearch", method=RequestMethod.GET)
	public String authorSearch(Model model, String find) {	
		if(find == null) {
			find = "";
		}
		this.find = find;
		int pagesize = 20;
		int startrow = 0;
		int endrow = startrow + pagesize;
		AuthorDAO adao = sqlSession.getMapper(AuthorDAO.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ArrayList<Author> authors = adao.selectAllPaging(boardpaging);
		int rowcount = adao.selectRowCount(find);
		int abspage = 1;
		if(rowcount % pagesize == 0) {
			abspage = 0;
		}
		int pagecount = rowcount / pagesize + abspage;
		if(pagecount > 10) {
			pagecount = 10;
		}
		int[] pages = new int[pagecount];
		for(int i = 0; i < pagecount; i++) {
			pages[i] = i+1;
		}
		model.addAttribute("authors", authors);
		model.addAttribute("pages",pages);
		model.addAttribute("pagenum",1);
		model.addAttribute("pagemax",pagecount);
		return "admin/author_search.admininfo";
	}
	@RequestMapping(value = "/authorpageselected", method = RequestMethod.GET)
	public String authorPageSelected(Model model, int page) {
		int pagesize = 20;
		int startrow = (page - 1) * (pagesize);
		int endrow = pagesize;
		AuthorDAO adao = sqlSession.getMapper(AuthorDAO.class);
		boardpaging.setFind(find);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ArrayList<Author> authors = adao.selectAllPaging(boardpaging);
		int rowcount = adao.selectRowCount(find);
		int abspage = 1;
		if(rowcount % pagesize == 0) {
			abspage = 0;
		}
		int pagecount = rowcount / pagesize + abspage;
		int firstpage = 1;
		int lastpage = 10;
		if(page % 10 == 1) {
			firstpage = page;
		}else if(page % 10 != 0 && page > 10){
			firstpage = page / 10 * 10 + 1;
		}else if(page % 10 == 0 && page > 10) {
			firstpage = (page / 10 - 1) * 10 + 1;
		}
		if(page % 10 != 0 && page/10 == pagecount/10) {
			lastpage = pagecount % 10;
		}
		int[] pages = new int[lastpage];
		for(int i = 0; i < lastpage; i++) {
			pages[i] = firstpage++;
		}
		model.addAttribute("authors", authors);
		model.addAttribute("pages",pages);
		model.addAttribute("pagenum",page);
		model.addAttribute("pagemax",pagecount);
		return "admin/author_search.admininfo";
	}
	@RequestMapping(value="/authorinsertform", method=RequestMethod.GET)
	public String authorInsertForm(Model model) {
		
		return "admin/author_insert_form.admininfo";
	}
	@RequestMapping(value="/authorinsert", method=RequestMethod.POST)
	public String authorInsert(@ModelAttribute Author author, @RequestParam CommonsMultipartFile img, HttpSession session) {
		AuthorDAO adao = sqlSession.getMapper(AuthorDAO.class);
		adao.insertAuthor(author);
		int code = adao.selectAuthorCode();
		String originalname = img.getOriginalFilename();
		String imgname = "";
		if(originalname.equals("")) {
		}else {
			imgname = code + ".jpg";
			try {
				String path = session.getServletContext().getRealPath("/resources/images/author/");
				byte bytes[] = img.getBytes();
				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(path+imgname));
				output.write(bytes);
				output.flush();
				output.close();
			}catch (Exception e) {
				
			}
		}
		return "redirect:authorsearch";
	}
	@RequestMapping(value="/authordelete", method=RequestMethod.GET)
	public String authorDelete(@RequestParam int code) {
		AuthorDAO adao = sqlSession.getMapper(AuthorDAO.class);
		adao.deleteAuthor(code);
		return "redirect:authorsearch";
	}
	@RequestMapping(value="/authorupdateform", method=RequestMethod.GET)
	public String authorUpdateForm(Model model, @RequestParam int code) {
		AuthorDAO adao = sqlSession.getMapper(AuthorDAO.class);
		Author authors = adao.selectAuthor(code);
		model.addAttribute("authors", authors);
		return "admin/author_update_form.admininfo";
	}
	@RequestMapping(value="/authorupdate", method=RequestMethod.POST)
	public String authorUpdate(@ModelAttribute Author author, @RequestParam CommonsMultipartFile img, HttpSession session) {
		AuthorDAO adao = sqlSession.getMapper(AuthorDAO.class);
		adao.updateAuthor(author);
		int code = author.getCode();
		String originalname = img.getOriginalFilename();
		String imgname = "";
		if(originalname.equals("")) {
		}else {
			imgname = code + ".jpg";
			try {
				String path = session.getServletContext().getRealPath("/resources/images/author/");
				byte bytes[] = img.getBytes();
				BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(path+imgname));
				output.write(bytes);
				output.flush();
				output.close();
			}catch (Exception e) {
				
			}
		}
		return "redirect:authorsearch";
	}
	@RequestMapping(value="/buyrequestsearch", method=RequestMethod.GET)
	public String buyRequestSearch(Model model, String state) {
		if(state == null) {
			state = "";
		}
		int pagesize = 10;
		int startrow = 0;
		int endrow = startrow + pagesize;
		BuyrequestDAO dao = sqlSession.getMapper(BuyrequestDAO.class);
		boardpaging.setFind(state);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ArrayList<Buyrequest> buyrequest = dao.selectBuyRequestPaging(boardpaging);
		int rowcount = dao.selectRowCount(state);
		int abspage = 1;
		if(rowcount % pagesize == 0) {
			abspage = 0;
		}
		int pagecount = rowcount / pagesize + abspage;
		if(pagecount > 10) {
			pagecount = 10;
		}
		int[] pages = new int[pagecount];
		for(int i = 0; i < pagecount; i++) {
			pages[i] = i+1;
		}
		model.addAttribute("buyrequest", buyrequest);
		model.addAttribute("state", state);
		model.addAttribute("pages",pages);
		model.addAttribute("pagenum",1);
		model.addAttribute("pagemax",pagecount);
		return "admin/buyrequest_search.admininfo";
	}
	@RequestMapping(value="/requeststateupdate", method=RequestMethod.GET)
	public String requestStateUpdate(@RequestParam String state, @RequestParam String id) {
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		BuyrequestDAO dao = sqlSession.getMapper(BuyrequestDAO.class);
		HashMap rollkey = new HashMap();
		rollkey.putIfAbsent("state", state);
		rollkey.putIfAbsent("buyerid", id);
		if(state.equals("배송완료")) {
			rollkey.putIfAbsent("completeday", sdf.format(date));
		}
		dao.updateState(rollkey);
		return "redirect:buyrequestsearch";
	}
	@RequestMapping(value = "/buyrequestpageselected", method = RequestMethod.GET)
	public String buyrequestPageSelected(Model model, int page, @RequestParam String state) {
		int pagesize = 10;
		int startrow = (page - 1) * (pagesize);
		int endrow = pagesize;
		BuyrequestDAO dao = sqlSession.getMapper(BuyrequestDAO.class);
		boardpaging.setFind(state);
		boardpaging.setStartrow(startrow);
		boardpaging.setEndrow(endrow);
		ArrayList<Buyrequest> buyrequest = dao.selectBuyRequestPaging(boardpaging);
		int rowcount = dao.selectRowCount(state);
		int abspage = 1;
		if(rowcount % pagesize == 0) {
			abspage = 0;
		}
		int pagecount = rowcount / pagesize + abspage;
		int firstpage = 1;
		int lastpage = 10;
		if(page % 10 == 1) {
			firstpage = page;
		}else if(page % 10 != 0 && page > 10){
			firstpage = page / 10 * 10 + 1;
		}else if(page % 10 == 0 && page > 10) {
			firstpage = (page / 10 - 1) * 10 + 1;
		}
		if(page % 10 != 0 && page/10 == pagecount/10) {
			lastpage = pagecount % 10;
		}
		int[] pages = new int[lastpage];
		for(int i = 0; i < lastpage; i++) {
			pages[i] = firstpage++;
		}
		model.addAttribute("buyrequest", buyrequest);
		model.addAttribute("state", state);
		model.addAttribute("pages",pages);
		model.addAttribute("pagenum",page);
		model.addAttribute("pagemax",pagecount);
		return "admin/buyrequest_search.admininfo";
	}
	@ResponseBody
	@RequestMapping(value = "/productinfoinsert", method = RequestMethod.POST)
	public ArrayList<BuyRequestProduct> productInfoInsert(@RequestParam String code) {
		BuyRequestProductDAO dao = sqlSession.getMapper(BuyRequestProductDAO.class);
		ArrayList<BuyRequestProduct> data = dao.selectBuyRequestProduct(code);
		return data;
	}
	@RequestMapping(value="/faqsearch", method=RequestMethod.GET)
	public String faqsearch(Model model) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		ArrayList<Board> faq = dao.faqList();
		model.addAttribute("faqs", faq);
		return "admin/faq_search.admininfo";
	}
	@RequestMapping(value="/faqinsertform", method=RequestMethod.GET)
	public String faqInsertForm() {
		
		return "admin/faq_insert_form.admininfo";
	}
	@RequestMapping(value="/faqinsert", method=RequestMethod.POST)
	public String faqInsert(@ModelAttribute Board board) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.insertFaq(board);
		return "redirect:faqsearch";
	}
	@RequestMapping(value="/faqupdateform", method=RequestMethod.GET)
	public String faqUpdateForm(Model model, @RequestParam int code) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		Board faq = dao.selectFaq(code);
		model.addAttribute("faq", faq);
		return "admin/faq_update_form.admininfo";
	}
	@RequestMapping(value="/faqupdate", method=RequestMethod.POST)
	public String faqUpdate(@ModelAttribute Board board) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.updateFaq(board);
		return "redirect:faqsearch";
	}
	@RequestMapping(value="/faqdelete", method=RequestMethod.GET)
	public String faqDelete(@RequestParam int code) {
		BoardDAO dao = sqlSession.getMapper(BoardDAO.class);
		dao.deleteFaq(code);
		return "redirect:faqsearch";
	}
	@RequestMapping(value="/attendance", method=RequestMethod.GET)
	public String attendance(Model model) {
		File file = new File("C:\\Users\\IT\\Downloads\\CoolTermWin\\test.txt");
		Date date = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd E요일 a hh:mm:ss");
        try {
            // BufferedReader 변수에 file을 넣는다
            BufferedReader reader = new BufferedReader(new FileReader(file));
 
            // 파일을 한줄씩 읽어 넣기 위한 변수 line
            String line = null;
 
            // 하나의 line을 split 하여 넣을 배열 splitedStr
            String[] splitedStr = null;
            
            line = reader.readLine();
            
 
            // 한 줄씩 읽어서 line에 넣은 후 null이 아니면 실행
            while( (line = reader.readLine()) != null ) {
 
                // 초기화
                splitedStr = null;
 
                // 탭을 기준으로 잘라서 splitedStr 에 넣는다
                splitedStr = line.split("\t");
 
                // 배열에 들어간 길이 만큼 반복한다
                for (int i = 0; i < splitedStr.length; i++) {
 
                        // 양쪽의 공백을 제거하고 다시 입력한다
                    splitedStr[i] = splitedStr[i].trim();
 
                        // splitedStr 을 List<Class명>에 입력하는 등 이용가능하다
                }
            }
            model.addAttribute("time", format.format(date));
            model.addAttribute("attendance", splitedStr[0]);
            
            reader.close();
 
        } catch (FileNotFoundException fnf) {
            fnf.printStackTrace();
        } catch( IOException e) {
            e.printStackTrace();
        }
		return "admin/attendance.admininfo";
	}
	@RequestMapping(value="/staffCheckForm", method=RequestMethod.GET)
	public String staffCheckForm() {		
		return "admin/staff_check_form.admininfo";
	}
	@RequestMapping(value="staffInfoOn", method=RequestMethod.GET)
	public String staffInfoOn() throws Exception {
		serial.connect();		
		return "redirect:staffCheckForm";
	}
	@RequestMapping(value="staffInfoOff", method=RequestMethod.GET)
	public String staffInfoOff(){				
		return "redirect:staffCheckForm";
	}
	
	
	
}
