<%@ page session="true"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>
Nullpointers : IT 전문 인터넷 서점
</title>
</head>
<body>
	<header>
		<div class="container" style="overflow: inherit;">
			<nav class="gnb gnb_top">
				<ul>
					<li><a href="chat">채팅</a></li>
					<li><a href="faqPage">고객센터</a></li>					
					<li><a href="myOrder">주문배송</a></li>
					<li><a href="userInsertForm">회원가입</a></li>
					<li><a id="BasketMenuButton" href="#" data-toggle="dropdown">
							<i class="fas fa-shopping-cart"> <c:if
									test="${sessionBasketCount != null}">
									<span class="count_basket">${sessionBasketCount}</span>
								</c:if>
						</i>
					</a> <c:if test="${sessionname!=null }">
							<div class="dropdown-menu gnb_login"
								aria-labelledby="BasketMenuButton" style="margin-top: 10px;">
								<a class="dropdown-item gnb_login" href="basket"
									style="color: #fff; text-align: center;">일반 장바구니</a> <a
									class="dropdown-item gnb_login" href="usedBasketPage"
									style="color: #fff; text-align: center;">중고거래 장바구니</a>
							</div>
						</c:if></li>
					<c:if test="${sessionname==null}">
						<li class="gnb_login"><a href="loginForm">로그인</a></li>
					</c:if>
					<c:if test="${sessionname!=null}">
						<li>
							<div class="dropdown">
								<button class="btn gnb_login dropdown-toggle" type="button"
									style="color: #fff" id="dropdownMenuButton"
									data-toggle="dropdown" aria-haspopup="true"
									aria-expanded="false">${sessionname}님</button>
								<div class="dropdown-menu gnb_login"
									aria-labelledby="dropdownMenuButton">
									<c:if test="${sessionname!='관리자'}">
										<a class="dropdown-item gnb_login" href="userInfo"
											style="color: #fff; text-align: center;">회원정보</a>
									</c:if>
									<c:if test="${sessionname=='관리자'}">
										<a class="dropdown-item gnb_login" href="adminpage"
											style="color: #fff; text-align: center;">관리자 정보</a>
									</c:if>
									<a class="dropdown-item gnb_login" href="logout"
										style="color: #fff; text-align: center;">로그아웃</a>
								</div>
							</div>
						</li>
					</c:if>

				</ul>
			</nav>
		</div>
		<div class="header_top container" style="clear: both;">
			<h1 class="main_logo mr-md-4">
				<a href="mainPage">NullPointers</a>
			</h1>
			<select id="main-search-select" class="custom-select col-4 col-md-2">
				<option>컴퓨터공학</option>
				<option>IT에세이</option>
				<option>컴퓨터입문/활용</option>
				<option>전산통계/해석</option>
				<option>OS</option>
			</select> <input id="main-search-keyword" type="search" class="form-control col-6 col-md-3 mr-md-4">
				<img onclick="location.href='bookListPageAdvanced?category='+$('#main-search-select option:selected').val()+'&order=평점&desc=0&bookname='+$('#main-search-keyword').val()+'&author=&publisher=&lowestprice=0&highestprice=1000000'" class="main_search_image" src="resources/images/btn_search3.gif"/>
		</div>
		<hr>
		<div class="row gnb_bar">
			<nav class="gnb container container_over">
				<ul class="btn_gnb_mobile">
					<li></li>
					<li></li>
					<li></li>
				</ul>
				<ul class="gnb_bar_depth1">
					<li><a href="javascript:void(0)" class="gnb_bar_category">카테고리</a>
						<div class="gnb_bar_depth2">
							<ul>
								<li><a href="bookListPage?category=컴퓨터공학">컴퓨터공학</a></li>
								<li><a href="bookListPage?category=IT에세이">IT에세이</a></li>
								<li><a href="bookListPage?category=컴퓨터입문/활용">컴퓨터입문/활용</a></li>
								<li><a href="bookListPage?category=전산통계/해석">전산통계/해석</a></li>
								<li><a href="bookListPage?category=OS">OS</a></li>
								<li><a href="bookListPage?category=네트워크">네트워크</a></li>
								<li><a href="bookListPage?category=보안/해킹">보안/해킹</a></li>
								<li><a href="bookListPage?category=데이터베이스">데이터베이스</a></li>
								<li><a href="bookListPage?category=개발방법론">개발방법론</a></li>
								<li><a href="bookListPage?category=게임">게임</a></li>
							</ul>
							<ul>
								<li><a href="bookListPage?category=웹프로그래밍">웹프로그래밍</a></li>
								<li><a href="bookListPage?category=프로그래밍/언어">프로그래밍/언어</a></li>
								<li><a href="bookListPage?category=모바일프로그래밍">모바일프로그래밍</a></li>
								<li><a href="bookListPage?category=OA/사무자동화">OA/사무자동화</a></li>
								<li><a href="bookListPage?category=웹사이트">웹사이트</a></li>
								<li><a href="bookListPage?category=그래픽">그래픽</a></li>
								<li><a href="bookListPage?category=멀티미디어">멀티미디어</a></li>
								<li><a href="bookListPage?category=CAD">CAD</a></li>
								<li><a href="bookListPage?category=자격증/수험서">자격증/수험서</a></li>
								<li><a href="bookListPage?category=대학교재">대학교재</a></li>
							</ul>
						</div></li>
					<li><a href="boardList">게시판</a></li>
					<li><a href="reviewList">독후감</a></li>
					<li><a href="usedMainPage">중고 장터</a></li>
<!-- 					<li onclick="changeBody('test1')"><a href="#">테스트</a></li> -->
					<li><a href="eventList">이벤트</a></li>
					<!-- 
					<li><a href="#">신상품</a></li>
					<li><a href="#">이벤트</a></li>
					<li><a href="#">포인트 게임</a></li>
					 -->
				</ul>
			</nav>
		</div>

	</header>

<script>
function changeBody(url){
	$("#main").children().remove();
	$("#main").load(url, function(data){
// 		console.log(data);
		$page = $(data);
		console.log($page);
		console.log($page.children());
		$("#main").html($page.children(".container"));
	});
	
}

</script>



</body>
</html>