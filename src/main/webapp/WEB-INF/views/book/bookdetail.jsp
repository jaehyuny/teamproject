<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>order page</title>
		<style>
		#main{
			font-family:'notosans';
			font-weight: bold;
			color: #3c3c3c;
		}
		.background{
			background-color:#6d77c5;
			padding-top : 10px;
			padding-bottom: 15px;
		}
		.grayground{
			background-image: linear-gradient(#e6e6e6, #f5f5f5);
			border:3px solid #f5f5f5;
		}
		.bigheader{
			font-size: 50px;	
		}
		.username{
			font-size:20px;
		}
		.float-left{
			float: left;
		}
		.titlebar{
			background-color: #5861a7;
			color:#FFFFFF;
		}
		.discription{
			padding-top: 30px;
			padding-bottom: 30px;
		}
		#fixednavigator{
			position: fixed;
			top:50px;
			width:40px;
			height:240px;
			background-color: #5861a7;
			opacity: 0.8;
			z-index: 100;
		}
		.fixednavigator-image{
			padding:10px;
			cursor: pointer;
		}
		
		.detail{
			background-color:#5861a7;
			padding-top:5px;
			
			color:#FFF;
			position:fixed;
			margin-left:40px;
			margin-top:-40px;
			width:0px;
			height:40px;
			overflow:hidden;
			transition:all;
			transition-duration:0.5s;
			white-space: nowrap;
			text-overflow: clip;
		}
		
		.fixednavigator-image:hover+.detail{
			padding-left:8px;
			width:200px;
			height:40px;
		}
		</style>
		<script>
	    function fnMove(seq){
	        var offset = $("#div" + seq).offset();
	        $('html, body').animate({scrollTop : offset.top-80}, 400);
	    }
	    $(document).ready(function(){
	    	$('#basket-button').on('click',function(){
				$.ajax({
					type : 'POST',
					data : "bookcode="+$('#bookcode').val()+"&amount="+$('#amount').val(),
					datatype : 'json',
					url : "addBasket",
					success : function(data){
						//통신 성공시 실행할 내용
						if(data=='duplicate'){
							alert("이미 장바구니에 존재합니다.");
						}else{
							alert('장바구니에 추가되었습니다.');
							$(".fa-shopping-cart").load(location.href + " .count_basket");
						}
					},
					error : function(xr,status,error){
						//통신 실패시 실행할 내용
						alert('오류가 발생했습니다. 다시 시도해주십시오.');
					}
				});
	    	});
		});
		</script>
	</head>
	<body>
		<!-- 책 구매용 변수 저장 -->
		<input id="bookcode" type="hidden" value="${book.code }">

		<!-- fixed 네비게이터 -->
		<nav id="fixednavigator">
			<img class="fixednavigator-image" src="resources/images/icons/house.png" onclick="fnMove(1)" width=40px height=40px></img>
			<div class="detail"> 화면 가장 위로</div>
			<img class="fixednavigator-image" src="resources/images/icons/content.png" onclick="fnMove(2)" width=40px height=40px></img>
			<div class="detail"> 책 소개</div>
			<img class="fixednavigator-image" src="resources/images/icons/list.png" onclick="fnMove(3)" width=40px height=40px></img>
			<div class="detail"> 목차</div>
			<img class="fixednavigator-image" src="resources/images/icons/man.png" onclick="fnMove(4)" width=40px height=40px></img>
			<div class="detail"> 저자 소개</div>
			<img class="fixednavigator-image" src="resources/images/icons/alert.png" onclick="fnMove(5)" width=40px height=40px></img>
			<div class="detail"> 주의사항</div>
			<img class="fixednavigator-image" src="resources/images/icons/starbutton.png" onclick="fnMove(6)" width=40px height=40px></img>
			<div class="detail"> 비슷한 책</div>
		</nav>
	
		<!-- 현재 선택된 카테고리 분류 표시-->
		<nav aria-label="breadcrumb">
		  <ol class="breadcrumb" style="margin-bottom: 0px">
				<div class="container">
					<li class="breadcrumb-item active" aria-current="page">${book.cat1}</li>
				</div>
		  </ol> 
		</nav>
	
		<br>

		<!-- 제목과 저자-출판사-출간일 -->
		<div id="div1" class="container">
			<h1>${book.name }</h1>
			<h5>${book.authorname } - ${book.publisher } - ${book. publishyear}년 ${book.publishmonth }월 ${book.publishday }일 </h5>
		</div>
		
		<br>

		<!-- 책 사진 및 평점, 가격 -->
		<div class="container">
			<div class="row">
				<span class="col-md-4">
					<img src="resources/images/books/${book.code }.jpg" width="300px" height="400px">
				</span>
				<div class="col-md-8" style="text-align: right">
					<ul>
						<li draggable="">
							<span class="bigheader" contenteditable="">평점</span>
						</li>
						<li>
							<c:forEach begin="1" end="${book.averagescore}" step="1">
								<img src="resources/images/icons/star.PNG" width="30px" height="30px">
							</c:forEach>
						</li>
						<br>
						<li>
							${evaluatenum}개의 평가 
						</li>
						<li>
							${reportnum }개의 독후감
						</li>
						<li>
							${usedsellnum }개의 중고거래 
						</li>
						<br>
						<li>
							${book.scale }, ${book.booktype }, isbn : ${book.isbn }
						</li>
						<br>
						<li>
							<span class="bigheader">
								<span class="numeric" data-numeric="${book.realprice }"></span>원
								<div>
									<form action="orderMain" method="post" id="buyaction">
									<input type="hidden" name="code" value="${book.code }"/>
									<c:choose>
									<c:when test="${book.stock >= 1 }">
										<select id="amount" name="amount" style="width: auto; display: inline-block; vertical-align: middle"class="form-control" name="amount">
											<c:forEach var="i" begin="1" end="${book.stock }" step="1">
												<option value="${i}">${i}</option>
											</c:forEach>
										</select>
										<button id="buy-button" class="btn btn-primary" type="submit">구매하기</button>
										<button id="basket-button" class="btn btn-primary" type="button">장바구니</button>
									</c:when>
									<c:otherwise>
										<button class="btn btn-primary" disabled>재고 부족</button>
									</c:otherwise>
									</c:choose>
									</form>
								</div>
							</span>
						</li>
				</div>
			</div>
		</div>
		<br>
		
		<!--  중고거래 BOX -->
		<div class="container grayground">
			<h2 class="row mt-3"><span class="col-12">중고거래</span></h2>
			<div class="row" style="align-items: center">
				<span class="col-md-4">최저가 <span class="numeric" data-numeric="${usedselllowest }"></span>원 : 전체 ${usedsellnum }건</span>
				<span class="col-md-8 mb-2" style="text-align: right">
					<button class="btn btn-primary" onclick="location.href='usedBookListPage?bookcode=${book.code}'">
					확인하기
					</button>
				</span>
			</div>
		</div>
		
		<br>
		
		<!-- 리뷰 BOX -->
		<div class="container grayground">
			<h2 class="row mt-3"><span class="col-12">평가 및 감상문</span></h2>
			<div class="row" style="align-items: center">
				<span class="col-12">${evaluatenum}개의 리뷰, ${reportnum}개의 독후감, 평균 평점 ${book.averagescore }<br></span>
				<!-- 짧은 감상평 -->
				<span class="col-12">리뷰</span>
				<c:forEach items="${bookevaluate}" var="one">
					<span class="col-8 mt-3" style="justify-content: center">
						<img class="rounded-circle float-left mr-2" width="60px" height="60px" src="resources/images/bono.jpg">
						<span class="username">
							${one.userid}
							 <span style="font-size: 15px" > - ${one.time }</span>
							<c:forEach var="i" begin="1" end="${one.score}" step="1">
								<img src="resources/images/icons/star.PNG" width="25px" height="25px">
							</c:forEach>
						 </span>
						<br>
						<span class="">${one.content }</span>
					</span>
					<span class="col-4 mt-3" style="text-align: right">
						<img src="resources/images/icons/like.png" width="30px" height="30px"> ${one.likecount }
						<span style="display: inline-block;">
							<img src="resources/images/icons/dislike.png" width="30px" height="30px"> ${one.dislikecount } 
						</span>
					</span>
				 </c:forEach>
				 <c:if test="${evaluatenum eq 0 }">
				 	<span class="col-12">
				 		<h5>아직 평가자가 없습니다. 평가해주세요!</h5>
				 	</span>
				 </c:if>
				 
				<!-- 독후감 -->
				<span class="col-12"><br>독후감</span>
				<c:forEach items="${bookreport}" var="one">
				<span class="col-8 mt-3" style="justify-content: center">
					<img class="rounded-circle float-left mr-2" width="60px" height="60px" src="resources/images/bono.jpg">
					<span class="username">
							${one.userid}
							 <span style="font-size: 15px" > - ${one.time }</span>
							<c:forEach var="i" begin="1" end="${one.score}" step="1">
								<img src="resources/images/icons/star.PNG" width="25px" height="25px">
							</c:forEach>
						 </span>
					<br>
					<span class="">${one.title }</span>
				</span>
				<span class="col-4 mt-3" style="text-align: right">
					<img src="resources/images/icons/like.png" width="30px" height="30px">${one.likecount }
					<span style="display: inline-block;">
						<img src="resources/images/icons/dislike.png" width="30px" height="30px"> ${one.dislikecount }
					</span>
				</span>
				<span class="col-12 mt-1 pl-5 pr-5 pt-3">
				${one.content }
				</span>
				</c:forEach>
				<c:if test="${reportnum eq 0 }">
				 	<span class="col-12">
				 		<h5>아직 이 책의 감상문을 작성한 사람이 없습니다.</h5>
				 	</span>
				 </c:if>

			</div>
			<div class="row">
				<span class="col-12 mb-2" style="text-align: right">
					<button onclick="location.href='bookReviewPage?bookcode=${book.code}'" class="btn btn-primary">
					더보기
					</button>
				</span>
			</div>
		</div>
		
		<br>
		
		<!-- 소개 title -->
		<div id="div2" class="titlebar"> 
			<div class="container">
			<h2>
			소개
			</h2>
			</div>
		</div>
		
		<!-- 소개 내용 -->
		<div class="container discription">
			<c:if test="${book.trailer ne '' }">
			<h4>
			트레일러
			</h4>
			${book.trailer }
			<br>
			<br>
			</c:if>
			<h4>
			줄거리
			</h4>
			${book.discription }

			<h4>
			<br>
			출판사서평
			</h4>
			${book.sellerdiscription }
		</div>

		
		<!-- 목차 title -->
		<div id="div3" class="titlebar"> 
			<div class="container">
			<h2>
			목차
			</h2>
			</div>
		</div>
		
		<!-- 목차 소개 -->
		<div class="container discription">
		${book.contentlist }
		</div>

		<!-- 저자 title -->
		<div id="div4" class="titlebar"> 
			<div class="container">
			<h2>
			저자
			</h2>
			</div>
		</div>
		
		<!-- 저자 소개 -->
		<div class="container discription">
		<img class="float-left" src="resources/images/bono.jpg" width="230px" height="200px" style="padding-right: 30px;"/>
		<h1>${book.authorname }</h1>
		<h4>${book.authoryear }</h4>
		<p>${book.authordiscription }</p>
		</div>

		<!-- 유의사항 title -->
		<div id="div5" class="titlebar"> 
			<div class="container">
				<h2>
				유의사항
				</h2>
			</div>
		</div>
		
		<!-- 유의사항 내용 -->
		<div class="container discription">
			이 책을 구매하실 경우, 절대 환불이 되지 않습니다. 구매에 신중해주십시오.
		</div>

		<!-- 비슷한 책 더보기 title -->
		<div id="div6" class="titlebar" style="background-color: #62c55f"> 
			<div class="container">
				<h2>
				비슷한 책 더보기
				</h2>
			</div>
		</div>
		
		<!-- 비슷한 책 내용 -->
		<div class="container discription">
			이 기능은 현재 구현되지 않을 기능입니다.
		</div>

	</body>
</html>