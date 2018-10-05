package com.team.project;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Optional;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.team.project.entities.Address;
import com.team.project.entities.Basket;
import com.team.project.entities.Book;
import com.team.project.entities.BuyRequestProduct;
import com.team.project.entities.Buyrequest;
import com.team.project.entities.Coupon;
import com.team.project.entities.Getcoupon;
import com.team.project.entities.Grade;
import com.team.project.entities.User;
import com.team.project.service.AddressDAO;
import com.team.project.service.BasketDAO;
import com.team.project.service.BookDAO;
import com.team.project.service.BuyRequestProductDAO;
import com.team.project.service.BuyrequestDAO;
import com.team.project.service.BuyrequestService;
import com.team.project.service.CouponDAO;
import com.team.project.service.UserDAO;

@Controller
public class OrderController {
	
	@Inject
	SqlSession sqlSession;
	@Inject
	User user;
	@Inject
	Book book;
	@Inject
	Basket basket;
	@Inject
	Coupon coupon;
	@Inject
	Getcoupon getcoupon;
	@Inject
	Buyrequest buyrequest;
	@Inject
	Grade grade;
	@Inject
	Address address;
	@Autowired
	BuyRequestProduct buyProduct;
	@Inject
	BuyrequestService buyService;
	
	@RequestMapping(value = "orderMain", method = RequestMethod.POST)
	public String orderMain(Model model, 
			@RequestParam(defaultValue="99999999") int code,
			@RequestParam(value="checkedNum", required=false) ArrayList<Integer> checked,
			@RequestParam(value="amount") ArrayList<Integer> amountList,
			HttpSession session) {
		
		Logger logger = LoggerFactory.getLogger(this.getClass());
		
		BookDAO bookDAO = sqlSession.getMapper(BookDAO.class);
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		UserDAO userDAO = sqlSession.getMapper(UserDAO.class);
		AddressDAO addressDAO = sqlSession.getMapper(AddressDAO.class);

		int checkedBookCount = 0;
		int amountTotal = 0;
		/* 책을 선택해서 온 경우가 아니라면 기본값 99999999을 받아, 
		 * 책의 정보를 읽어오지 않는다.*/
		if(code != 99999999) {
			/* 책을 골라서 구매하기를 눌렀을 때 */
			session.setAttribute("sessionWay", 0);	//세션에 접근 방식을 저장. 바로 구매하기로 왔을 시 0
			book = bookDAO.selectBook(code);
			checkedBookCount = 1;
			amountTotal = amountList.get(0);
			/* 비정상적인 방법으로 수량이 0개가 들어왔을 때 되돌려보냄 */
			if(amountList.get(0) == 0){
				return "redirect:/";
			}
			model.addAttribute("book", book);
			model.addAttribute("bookAmount", amountList.get(0));
			session.setAttribute("sessionBook", book);	//세션에 책 정보 저장
			session.setAttribute("sessionAmount", amountTotal);	//세션에 구매 수량 저장
		} else {
			/* 책을 골라서 온 것이 아닐 때만 장바구니를 호출한다.*/
			session.setAttribute("sessionWay", 1);	//세션에 접근 방식을 저장. 장바구니에서 왔을 시 1
			ArrayList<Basket> basketList = (ArrayList<Basket>) session.getAttribute("sessionBasketList");
			ArrayList<Basket> checkedList = new ArrayList<>();
			for(int i = 0; i < checked.size(); i++) {
				if(checked.get(i).equals(1)) {
					checkedList.add(basketList.get(i));
					checkedBookCount += 1;
					/* 비정상적인 방법으로 수량이 0개가 들어왔을 때 되돌려보냄 */
					if(amountList.get(i) == 0){
						return "redirect:basket";
					}
					checkedList.get(i).setAmount(amountList.get(i));
					book = bookDAO.selectBook(checkedList.get(i).getBookcode());
					checkedList.get(i).setBookcategory(book.getCat1());
					amountTotal += amountList.get(i);
				} else {
					checkedList.add(null);
				}
			}
			model.addAttribute("basketList", checkedList);
			session.setAttribute("sessionCheckedList", checkedList);	//세션에 유효한 장바구니 품목 저장
		}

		model.addAttribute("amountTotal", amountTotal);	//총 구매 수량
		model.addAttribute("checkedBookCount", checkedBookCount);	//몇 종의 책인지
		
		/* 세션에 저장된 접속자의 아이디를 불러와, 보유 중인 쿠폰을 뽑아낸다.*/
		String userid = (String) session.getAttribute("sessionid");
		ArrayList<Coupon> userCoupons = couponDAO.selectUserCoupon(userid);
		model.addAttribute("userCoupons", userCoupons);
		session.setAttribute("sessionCoupons", userCoupons);	//세션에 사용 가능한 쿠폰 배열 저장
		
		/* 무료배송쿠폰을 제외해서 저장하는 배열 생성*/
		ArrayList<Coupon> saleCoupons = new ArrayList<>();
		/* 무료배송쿠폰만 저장하는 배열 생성*/
		ArrayList<Coupon> deliveryCoupons = new ArrayList<>();
		for(Coupon item:userCoupons) {
			if (item.getIsfreeshiping() == 0) {
				saleCoupons.add(item);
			} else if (item.getIsfreeshiping() == 1) {
				deliveryCoupons.add(item);
			}
		}
		
		model.addAttribute("saleCoupons", saleCoupons);
		model.addAttribute("saleCouponCount", saleCoupons.size());
		model.addAttribute("deliveryCouponCount", deliveryCoupons.size());
		model.addAttribute("deliveryCoupons", deliveryCoupons);
		
		/* 배송지 등에 나타낼 유저 정보를 넣는다.*/
		user = userDAO.selectUser(userid);
		model.addAttribute("user", user);
		
		/* 세션에 저장된 접속자의 등급을 불러와, 적용한다.
		 * 포인트 적립율을 적용하기 위함이다.*/
		
		/* 배송지 주소록을 불러온다. */
		ArrayList<Address> addressList = addressDAO.selectUserAddress(userid);
		model.addAttribute("addressList", addressList);
		
		return "order/order.page";
	}
	
	@RequestMapping(value = "tempBooks", method = RequestMethod.GET)
	public String tempBooks(Model model) {
		BookDAO bookDAO = sqlSession.getMapper(BookDAO.class);
		ArrayList<Book> bookList = bookDAO.selectAll();
		model.addAttribute("bookList", bookList);
		return "order/temp_books.page";
	}
	
	@RequestMapping(value = "basket", method = RequestMethod.GET)
	public String basket(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		
		/* 세션에 저장된 접속자의 아이디를 불러온다.
		 * 비회원일 경우 저장된 세션이 없기 때문에 xxx를 불러오게 된다. */
		String optUserid = (String) Optional.ofNullable(session.getAttribute("sessionid")).orElse("xxx");
		
		ArrayList<Basket> basketList = buyrequestDAO.selectBasket(optUserid);
		
		session.setAttribute("sessionBasketList", basketList);	//sessionBasketList에 접속자의 장바구니 저장
		model.addAttribute("basketList", basketList);

		return "order/basket.page";
	}
	
	@RequestMapping(value = "deleteBasket", method = RequestMethod.POST)
	@ResponseBody
	public int deleteBasket(@RequestParam("bookcode") int bookcode, HttpSession session) {
		BasketDAO basketDAO= sqlSession.getMapper(BasketDAO.class);
		
		String userid = (String) session.getAttribute("sessionid");
		basket.setUserid(userid);
		basket.setBookcode(bookcode);

		int result = basketDAO.deleteBasket(basket);
		if(result > 0) {
			int basketCount = (int) session.getAttribute("sessionBasketCount");
			session.setAttribute("sessionBasketCount", basketCount -1);
		}
		
		return result;
	}
	
	@RequestMapping(value = "usableCoupons", method = RequestMethod.POST)
	@ResponseBody
	public String usableCoupons() {
		return "";
	}
	
	/**
	 * 최종 결제 버튼을 눌렀을 때 실행된다. 
	 * @param receiverInfo 받는 사람의 정보(ArrayList)
	 * @param bookCode 책의 코드(ArrayList)
	 * @param bookCoupon 책에 사용된 쿠폰(ArrayList)
	 * @param bookPoint 책에 사용된 포인트(ArrayList)
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "orderResult", method = RequestMethod.POST)
	@ResponseBody
	public Object orderResult(
			@RequestParam("receiverInfo") ArrayList<String> receiverInfo,
			@RequestParam("bookCode") ArrayList<Integer> bookCode,
			@RequestParam("bookCoupon") ArrayList<Integer> bookCoupon,
			@RequestParam("bookPoint") ArrayList<Integer> bookPoint,
			HttpSession session) {

		ArrayList<String> result = new ArrayList<>();
		ArrayList<Basket> orderList = new ArrayList<>();
		UserDAO userDAO = sqlSession.getMapper(UserDAO.class);
		BookDAO bookDAO = sqlSession.getMapper(BookDAO.class);
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		BuyRequestProductDAO buyproductDAO = sqlSession.getMapper(BuyRequestProductDAO.class);
		int insertResult = 0;
		int orderWay = (int) session.getAttribute("sessionWay");	//바로 구매하기 = 0, 장바구니 = 1
		
		/* view 에서 가져오는 정보들 */
		int couponcode = 0;
		int couponcode2 = 0;
		int usedpoint = 0;
		String receivername = receiverInfo.get(1);
		String receivertell = receiverInfo.get(2);
		String receiverphone = receiverInfo.get(3);
		String postno = receiverInfo.get(4);
		String address1 = receiverInfo.get(5);
		String address2 = receiverInfo.get(6);
		String returnbank = receiverInfo.get(7);
		String returnfinance = receiverInfo.get(8);
		
		/* controller 에서 가져오는 정보들 */
		String userId = (String) session.getAttribute("sessionid");
		Grade userGrade = (Grade) session.getAttribute("sessionGrade");
		ArrayList<Coupon> couponList = (ArrayList<Coupon>) session.getAttribute("sessionCoupons");
		
		/* 가격 계산 */
		int bookcode = 0;
		int amount = 0;
		int price = 0;
		int getpoint = 0;
		int finalpriceProduct = 0;
		int finalpriceTotal = 0;
		int SHIPPING_PRICE = 2000;
		HashMap<String, Integer> priceAndPoint = new HashMap<>();

		/* view에서 보낸 쿠폰코드가 실제로 보유 중인 쿠폰코드인지 검증 */
		String couponResult = "";
		couponcode = Integer.parseInt(receiverInfo.get(0));
		if(orderWay == 0) {
			couponcode2 = bookCoupon.get(0);
			couponResult = couponValidate(couponcode, couponcode2, session);
			if(couponResult.equals("error")) {
				result.add("쿠폰 오류입니다.");
				return result;
			}
		} else {
			for(Integer item:bookCoupon) {
				couponcode2 = item;
				couponResult = couponValidate(couponcode, couponcode2, session);
				if(couponResult.equals("error")) {
					result.add("쿠폰 오류입니다.");
					return result;
				}
			}
		}
		
		/* 포인트 사용량 체크 */
		user = userDAO.selectUser(userId);
		int userPoint = user.getPoint();
		int chkPoint = 0;
		for(int point:bookPoint) {
			if(point > 0) {
				chkPoint += point;
			}
		}
		if(chkPoint > userPoint) {
			return "POINT ERROR";
		}
		
		if(orderWay == 0) {
			book = (Book) session.getAttribute("sessionBook");
			bookcode = book.getCode();
			amount = (int) session.getAttribute("sessionAmount");
			price = book.getRealprice();
			
		} else {
			ArrayList<Basket> checkedList = (ArrayList<Basket>) session.getAttribute("sessionCheckedList");
			
			checkedList.stream().filter(e -> e != null).forEach(e -> orderList.add(e));
			
//			checkedList.stream().forEach(e -> {
//				if(e != null) {
//					orderList.add(e);
//				}
//			});
			
//			for(Basket item:checkedList) {
//				if (item != null) {
//					orderList.add(item);
//				}
//			}
		}
		
		buyrequest.setBuyerid(userId);
		buyProduct.setBookcode(bookcode);	//buyProduct
		
		buyrequest.setState("입금대기");	//임시
		
		long time = System.currentTimeMillis() + 172800000;	//임시로 배송 소요일 2일로 설정
		buyrequest.setCompleteday(new Timestamp(time));	//임시
		buyrequest.setReceivername(receivername);
		buyrequest.setReceiverphone(receiverphone);
		buyrequest.setReceivertell(receivertell);
		buyrequest.setPostno(postno);
		buyrequest.setAddress1(address1);
		buyrequest.setAddress2(address2);
		buyrequest.setReturnbank(returnbank);
		buyrequest.setReturnfinance(returnfinance);
		
		couponcode = Integer.parseInt(Optional.ofNullable(receiverInfo.get(0)).orElse("0"));
        if(couponcode == 0) {
            buyrequest.setShippingprice(SHIPPING_PRICE);
        } else {
            buyrequest.setShippingprice(0);
        }

		buyrequest.setCouponcode(couponcode);
		
		if(orderWay == 0) {	//바로구매 시
			bookcode = bookCode.get(0);
			book = bookDAO.selectBook(bookcode);
			couponcode2 = bookCoupon.get(0);
			usedpoint = bookPoint.get(0);
			buyProduct.setBookcode(bookcode);
			buyProduct.setCoupon(couponcode2);
			buyrequest.setUsedpoint(usedpoint);
			buyProduct.setUsedpoint(usedpoint);
			buyProduct.setAmount(amount);
			buyProduct.setPrice(price);
			priceAndPoint = priceCalculate(couponcode2, price, amount, usedpoint, session);
			/* 도서정가제 체크 */
			if(priceAndPoint == null) {
				return "DISCOUNT ERROR";
			}
			finalpriceProduct = priceAndPoint.get("finalprice");
			buyrequest.setFinalprice(finalpriceProduct);
			buyProduct.setFinalprice(finalpriceProduct);
			getpoint =  priceAndPoint.get("getpoint");
			buyrequest.setGetpoint(getpoint);
			/* 현재 재고와 구매하려는 책의 수량을 비교*/
			book = bookDAO.selectBook(bookcode);
			if(book.getStock() < amount) {
				return "stock error";
			}
			book.setCode(bookcode);
			book.setStock(amount);
			user.setId(userId);
			user.setPoint(getpoint - usedpoint);
			//실행할 쿼리들이 모인 클래스
			buyService.addBuyrequest(buyrequest, user, couponcode);
			buyProduct.setOrdercode(buyrequest.getCode());
			buyService.addBuyproduct(buyProduct, book, couponcode2);
		} else {	//장바구니로 구매 시
			for(int i=0; i<orderList.size(); i++) {
				usedpoint += bookPoint.get(i);
				priceAndPoint = priceCalculate(bookCoupon.get(i), orderList.get(i).getBookprice(), orderList.get(i).getAmount(), bookPoint.get(i), session);
				/* 도서정가제 체크 */
				if(priceAndPoint == null) {
					return "DISCOUNT ERROR";
				}
				finalpriceTotal += priceAndPoint.get("finalprice");
				getpoint += priceAndPoint.get("getpoint");
				
				bookcode = bookCode.get(i);
				amount = orderList.get(i).getAmount();
				/* 현재 재고와 구매하려는 책의 수량을 비교*/
				book = bookDAO.selectBook(bookcode);
				if(book.getStock() < amount) {
					return "stock error";
				}
			}
			buyrequest.setUsedpoint(usedpoint);
			buyrequest.setFinalprice(finalpriceTotal);
			buyrequest.setGetpoint(getpoint);
			user.setId(userId);
			user.setPoint(getpoint - usedpoint);
			//실행할 쿼리들이 모인 클래스
			buyService.addBuyrequest(buyrequest, user, couponcode);
			for(int i=0; i<orderList.size(); i++) {
				bookcode = bookCode.get(i);
				couponcode2 = bookCoupon.get(i);
				usedpoint = bookPoint.get(i);
				buyProduct.setOrdercode(buyrequest.getCode());
				buyProduct.setBookcode(bookcode);
				buyProduct.setCoupon(couponcode2);
				buyProduct.setUsedpoint(usedpoint);
				buyProduct.setAmount(orderList.get(i).getAmount());
				buyProduct.setPrice(orderList.get(i).getBookprice());
				priceAndPoint = priceCalculate(couponcode2, orderList.get(i).getBookprice(), orderList.get(i).getAmount(), usedpoint, session);
				finalpriceProduct = priceAndPoint.get("finalprice");
				buyProduct.setFinalprice(finalpriceProduct);
				book.setCode(bookcode);
				book.setStock(orderList.get(i).getAmount());
				//실행할 쿼리들이 모인 클래스
				buyService.addBuyproduct(buyProduct, book, couponcode2);
			}
		}
		
		return buyrequest.getCode();
	}
	
	/**
	 * 쿠폰 유효성 검사
	 * @param couponcode 배송쿠폰을 받아온다
	 * @param couponcode2 할인쿠폰을 받아온다
	 * @param session 이건 그냥 세션
	 * @return 유효성에 문제가 있으면 error, 없으면 good을 반환한다.(String)
	 */
	public String couponValidate(int couponcode, int couponcode2, HttpSession session) {
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		String userid = (String) session.getAttribute("sessionid");
		int couponChk = 0;
		
		if(couponcode != 0) {
			Getcoupon delivery = couponDAO.selectGetCouponInfo(couponcode);
			if(delivery == null) {
				couponChk += 1;
			} else {
				if (delivery.getIsusing() != 0 || !delivery.getId().equals(userid)) {
					couponChk += 1;
				}
			}
		}
		
		if(couponcode2 != 0) {
			Getcoupon discount = couponDAO.selectGetCouponInfo(couponcode2);
			if(discount == null) {
				couponChk += 1;
			} else {
				if (discount.getIsusing() != 0 || !discount.getId().equals(userid)) {
					couponChk += 1;
				}
			}
		}
		
		if(couponChk > 0) {
			return "error";
		}
		
		return "good";
	}
	
	/**
	 * 최종가격 및 적립포인트 계산
	 * @param couponcode2 할인쿠폰. getcoupon의 code로 들어와있다.
	 * @param price 상품의 가격
	 * @param amount 상품의 수량
	 * @param usedpoint 사용한 포인트
	 * @return 마지막으로 계산된 값(HashMap<String, Integer>), finalprice와 getpoint로 저장.
	 */
	public HashMap<String, Integer> priceCalculate(int couponcode2, int price, int amount, int usedpoint, HttpSession session) {
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		HashMap<String, Integer> priceAndPoint = new HashMap<>();
		int discountMoney = 0;
		int finalprice = 0;
		int getpoint = 0;
		
		if(couponcode2 != 0) {
			/* getcoupon의 code 자체에는 쿠폰의 할인 정보가 없다.
			 * getcoupon에서 couponcode를 뽑아, 그것으로 쿠폰의 할인 정보를 받아 온다. */
			Coupon couponDiscount = couponDAO.selectCouponFromGetcoupon(couponcode2);
			
			if (couponDiscount.getFixedsale() > 0) {
				discountMoney = couponDiscount.getFixedsale();
			} else if (couponDiscount.getPercentsale() > 0) {
				discountMoney = price * couponDiscount.getPercentsale() / 100;
			}
			/* 할인 적용 수량 제한이 있는데 구매 수량이 1개가 아닐 경우 */
			if (couponDiscount.getAcceptnum() != 0 && amount != 1) {
				return null;
			}
			
		}
		finalprice = ((price - discountMoney) * amount - usedpoint) / 10 * 10;
		/* 최종가를 수량으로 나눈 값이 본래가격의 85퍼 미만일 경우 */
		if(finalprice / amount < price * 0.85) {
			return null;
		}
		
		grade = (Grade) session.getAttribute("sessionGrade");
		getpoint = ((price - discountMoney) * amount) / 10 * 10 * grade.getAmount() / 100;
		priceAndPoint.put("finalprice", finalprice);
		priceAndPoint.put("getpoint", getpoint);
		
		return priceAndPoint;
	}
	
	@RequestMapping(value = "orderResultPage", method = RequestMethod.GET)
	public String orderResultPage(HttpSession session, Model model) {
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		BuyRequestProductDAO productDAO = sqlSession.getMapper(BuyRequestProductDAO.class);
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		String userid = (String) Optional.ofNullable(session.getAttribute("sessionid")).orElse("xxx");
		buyrequest = buyrequestDAO.selectRecentOrder(userid);
		ArrayList<BuyRequestProduct> products = productDAO.selectRecentBuyProduct(buyrequest.getCode());

		ArrayList<Coupon> couponList = new ArrayList<>();
		if(buyrequest.getCouponcode() !=0 ) {
			coupon = couponDAO.selectCouponFromGetcoupon(buyrequest.getCouponcode());
			couponList.add(coupon);
		}
		for(BuyRequestProduct item:products) {
			if(item.getCoupon() != 0) {
				coupon = couponDAO.selectCouponFromGetcoupon(item.getCoupon());
				couponList.add(coupon);
			}
		}
		
		model.addAttribute("buyrequest", buyrequest);
		model.addAttribute("products", products);
		model.addAttribute("couponList", couponList);
		System.err.println("product : " + products);
		return "order/order_result.page";
	}
	
	@RequestMapping(value = "orderCancel", method = RequestMethod.GET)
	public String orderCancel(HttpSession session,
			@RequestParam String buyerid,
			@RequestParam int code) {
		BuyrequestDAO buyrequestDAO = sqlSession.getMapper(BuyrequestDAO.class);
		
		if(session.getAttribute("sessionid") == null) {
			session.invalidate();
			return "redirect:/";
		} else if (!buyerid.equals(session.getAttribute("sessionid").toString())) {
			session.invalidate();
			return "redirect:/";
		}
		buyrequest.setBuyerid(buyerid);
		buyrequest.setCode(code);
		int result = buyrequestDAO.updateOrderCancel(buyrequest);
		
		
		return "redirect:myOrder";
	}
	
	
	
	
	@RequestMapping(value = "tempCoupon", method = RequestMethod.GET)
	public String tempCoupon(Model model) {
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		ArrayList<Coupon> couponList = couponDAO.selectCouponAll();
		ArrayList<Getcoupon> getcouponList = couponDAO.selectGetCouponAll();
		model.addAttribute("couponList", couponList);
		model.addAttribute("getcouponList", getcouponList);
		
		return "order/temp_coupon.page";
	}
	
	@RequestMapping(value = "addCoupon", method = RequestMethod.POST)
	public String addCoupon(@ModelAttribute Coupon coupon) {
		
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		if(coupon.getCatcondition().equals("")) {
			coupon.setCatcondition(null);
		}
		int result = couponDAO.insertCoupon(coupon);
		
		return "redirect:tempCoupon";
	}
	
	@RequestMapping(value = "addGetCoupon", method = RequestMethod.POST)
	public String addGetCoupon(@ModelAttribute Getcoupon getcoupon) {
		
		CouponDAO couponDAO = sqlSession.getMapper(CouponDAO.class);
		int result = couponDAO.insertGetCoupon(getcoupon);
		
		return "redirect:tempCoupon";
	}
	
	/**
	 * 트랙잭션 테스트용 메소드
	 * @return
	 */
	@Transactional
	@RequestMapping(value = "testTransaction", method = RequestMethod.GET)
	public String testTransaction() {
		UserDAO userDAO =  sqlSession.getMapper(UserDAO.class);
		user.setId("dog@dog.net");
		user.setPoint(100);
		userDAO.addUserPoint(user);
		user.setPoint(200);
		userDAO.subtractUserPoint(user);
		return "redirect:/";
	}
	
}
