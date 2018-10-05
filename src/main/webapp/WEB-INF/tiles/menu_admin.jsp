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
		<a href="adminpage"><h3 class="pri-col" style="text-align: center; margin-top: 30px">admin page</h3></a>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-bottom-left-radius: 0; border-bottom-right-radius: 0" id="dropdownMenuButton"
				onclick="location.href='usersearch'">회원관리</button>
		</div>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-radius: 0" id="dropdownMenuButton"
				onclick="location.href='couponsearch'">쿠폰관리</button>
		</div>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-radius: 0" id="dropdownMenuButton"
				onclick="location.href='booksearch'">책관리</button>
		</div>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-radius: 0" id="dropdownMenuButton"
				onclick="location.href='authorsearch'">저자관리</button>
		</div>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-radius: 0" id="dropdownMenuButton"
				onclick="location.href='buyrequestsearch'">주문확인</button>
		</div>
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-radius: 0" id="dropdownMenuButton"
				onclick="location.href='faqsearch'">FAQ관리</button>
		</div>
<!-- 		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-radius: 0" id="dropdownMenuButton"
				onclick="location.href='staffCheckForm'">직원관리</button>
		</div> -->
		<div class="btn-group dropright">
			<button class="btn btn-block dropdown-toggle pri-back-alpha"
				type="button" style="border-top-left-radius: 0; border-top-right-radius: 0; margin-bottom: 100px"
				id="dropdownMenuButton" onclick="location.href='eventAdmin'">이벤트관리</button>
		</div>		
	</div>
</body>
</html>