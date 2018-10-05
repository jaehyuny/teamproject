<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="list-group">
		<h3 class="pri-col" style="text-align: center; margin-top: 30px"><a href="userInfo" class="pri-col">회원 정보</a></h3>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-bottom-left-radius: 0; border-bottom-right-radius: 0" id="dropdownMenuButton"
				data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">일반
				주문정보</button>
			<div class="dropdown-menu pri-back-alpha" aria-labelledby="dropdownMenuButton">
				<a class="dropdown-item" href="myOrder">내 주문</a>				
			</div>
		</div>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-radius: 0" id="dropdownMenuButton"
				data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">중고
				주문정보</button>
			<div class="dropdown-menu pri-back-alpha" aria-labelledby="dropdownMenuButton">
				<a class="dropdown-item" href="myUsedBuy">내 구매상품</a> <a
					class="dropdown-item" href="myUsedSell">내 판매상품</a>	
			</div>
		</div>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-radius: 0" id="dropdownMenuButton"
				data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">포인트
				및 쿠폰</button>
			<div class="dropdown-menu pri-back-alpha" aria-labelledby="dropdownMenuButton">
				<a class="dropdown-item" href="myPoint">내 포인트</a> <a
					class="dropdown-item" href="myCoupon">내 쿠폰</a> 					
			</div>
		</div>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-radius: 0" id="dropdownMenuButton"
				data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">커뮤니티
				정보</button>
			<div class="dropdown-menu pri-back-alpha" aria-labelledby="dropdownMenuButton">
				<a class="dropdown-item" href="myReview">내 독후감</a>
				<a class="dropdown-item" href="myComment">내 평가</a>				
				<a class="dropdown-item" href="myQuestion">내 문의</a>
				<a class="dropdown-item" href="faqPage">FAQ</a>				
			</div>
		</div>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-top-left-radius: 0; border-top-right-radius: 0; margin-bottom: 100px"
				id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true"
				aria-expanded="false">회원정보수정</button>
			<div class="dropdown-menu pri-back-alpha" aria-labelledby="dropdownMenuButton">
				<a class="dropdown-item" href="userInfoUpForm">회원정보수정</a>
				<a class="dropdown-item" href="passwordUpForm">비밀번호변경</a>
				<a class="dropdown-item" href="userInfoDelForm">회원 탈퇴</a>
			</div>
		</div>
	</div>
</body>
</html>