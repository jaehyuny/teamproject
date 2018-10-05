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
		.background{
			background-color:#6d77c5;
			padding-top : 10px;
			padding-bottom: 15px;
		}
		.categories{
			margin-left: 0px;
			margin-right: 0px;
		}
		.background a{
			color: #FFFFFF;
			margin-right: 25px;
		}	
		
		.detailsearch{
			height:auto;
			max-height:0px;
			transition:0.5s;
			overflow: hidden;
			border-bottom: 2px solid #999;

		}
		.bookcard{
			margin: 10px;
			padding: 20px;
			background-color: #f5f5f5;
			border-radius: 3px;
			border: 1px solid #d8d8d8;
		}
		.detailsearch-active{
			max-height:430px;
		}
		.orderselect{
			width:200px !important;
			display: inline-block !important;
		}
		.bookimage{
			width:150px;
			height:200px;
		}
		.center{
			text-align: center;
		}
		.input-group-text:not(.flowtext){
			width: 70px;
		}
		ul{
			margin-bottom: 0px;
		}
		</style>
		<script>
			$(document).ready(function(){
				var isOpenedDetailSearch = false;
				$("#detail-search-button").on("click",function(){
					if(isOpenedDetailSearch == false){
						$(".detailsearch").addClass("detailsearch-active");
						isOpenedDetailSearch = true;
					}else{
						$(".detailsearch").removeClass("detailsearch-active");
						isOpenedDetailSearch = false;
					}
				});
				$('#detail-search-submitbutton').on("click",function(){
					advancedSearch();
				});
				$('#order-descbutton').on("click",function(){
					$('#desc').val(1);
					advancedSearch();
				});
				$('#order-ascbutton').on("click",function(){
					$('#desc').val(0);
					advancedSearch();
				});
				$('#order-select').on("change",function(){
					advancedSearch();
				});
			});
			function advancedSearch(){
				if($('#detail-search-lowestprice').val()==""){
					$('#detail-search-lowestprice').val(0);
				}
				if($('#detail-search-highestprice').val()==""){
					$('#detail-search-highestprice').val(1000000);
				}
				location.href="bookListPageAdvanced?category="+$("#detail-search-select option:selected").val()
						+"&order="+$("#order-select option:selected").val()+"&desc="+$("#desc").val()
						+"&bookname="+$("#detail-search-bookname").val()+"&author="+$("#detail-search-author").val()
						+"&publisher="+$("#detail-search-publisher").val()
						+"&lowestprice="+$("#detail-search-lowestprice").val()+"&highestprice="+$("#detail-search-highestprice").val();
			}
		</script>
	</head>
	<body>
		<!-- 사전정보 -->
		<input type="hidden" id="desc" value="0"/>

		<!-- 카테고리 -->
		<div class="background">
			<div class="container">
				<h4 style="color:#FFFFFF">카테고리</h4>
				<div class="row categories">
				<c:forEach items="${category}" var="cats">
					<a href="bookListPage?category=${cats.name}"> ${cats.name} </a> 
				</c:forEach>
				</div>
			</div>
		</div>

		<!-- 현재 선택된 카테고리 분류 표시-->
		<nav aria-label="breadcrumb">
		  <ol class="breadcrumb" style="margin-bottom: 0px">
				<div class="container">
					<li class="breadcrumb-item active" aria-current="page">${selectedcategoryname}</li>
				</div>
		  </ol>
		</nav>
		
		<!-- 사용자가 상세검색버튼을 눌렀을때 표시되는 상세검색창 -->
		<div class="detailsearch">
			<div class="container">
				<div style="margin-top:10px; margin-bottom:5px;">
				<label style="font-size: 25px">상세검색</label>
				<select id="detail-search-select" class="orderselect form-control" style="float:right; margin-top: 3px;">
					<c:forEach items="${category}" var="cats">
					<option values="${cats.name}" ${selectedcategoryname == cats.name?"selected":"" }>${cats.name}</option>
					</c:forEach>
				</select>
				</div>
					<div class="row">
					<div class="col-lg-4">
						<div class="input-group mb-3">
						  <div class="input-group-prepend">
							<span class="input-group-text" id="basic-addon1">도서명</span>
						  </div>
						  <input id="detail-search-bookname" type="text" class="form-control" placeholder="책의 이름.." aria-label="Username" aria-describedby="basic-addon1">
						</div>
					</div>
					<div class="col-lg-4">
						<div class="input-group mb-3">
						  <div class="input-group-prepend">
							<span class="input-group-text" id="basic-addon1">저자</span>
						  </div>
						  <input id="detail-search-author" type="text" class="form-control" placeholder="author" aria-label="Username" aria-describedby="basic-addon1">
						</div>
					</div>
					<div class="col-lg-4">
						<div class="input-group mb-3">
						  <div class="input-group-prepend">
							<span class="input-group-text" id="basic-addon1">출판사</span>
						  </div>
						  <input id="detail-search-publisher" type="text" class="form-control" placeholder="출판사의 이름.." aria-label="Username" aria-describedby="basic-addon1">
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-6">
						<div class="input-group mb-3">
						  <div class="input-group-prepend">
							<span class="input-group-text" id="basic-addon1">가격</span>
						  </div>
						  <input maxlength="7" oninput="maxLengthCheck(this)" id="detail-search-lowestprice" type="number" class="form-control" placeholder="price" aria-label="Username" aria-describedby="basic-addon1">
							<div class="input-group-prepend">
							<span class="input-group-text flowtext" id="basic-addon1">~</span>
						  </div>
						  <input maxlength="7" oninput="maxLengthCheck(this)" id="detail-search-highestprice" type="text" class="form-control" placeholder="price" aria-label="Username" aria-describedby="basic-addon1">
						</div>
					</div>
					<div class="col-md-6">
						<div class="input-group mb-3">
						<div class="input-group-prepend">
							<span class="input-group-text" id="basic-addon1">출간일<span>
						  </div>
						  <input id="detail-search-frompublishday" type="text" class="form-control" placeholder="date" aria-label="Username" aria-describedby="basic-addon1">
							<div class="input-group-prepend">
							<span class="input-group-text flowtext" id="basic-addon1">~</span>
						  </div>
						  <input id="detail-search-topublishday" type="text" class="form-control" placeholder="date" aria-label="Username" aria-describedby="basic-addon1">
						</div>
					</div>
				</div>
				<button id="detail-search-submitbutton" class="btn btn-primary mb-2" type="button">
					위 정보로 상세 검색합니다.
				</button>
				<br>
			</div>
		</div>

		<!--  검색결과 표시 및 버튼2개 표시 -->
		<div class="container">
			<label style="float: left; font-size: 30px">검색결과 : ${fn:length(books) }건</label>
			<span style="float: right; margin-top: 10px">
			<img style="width:30px; height:30px;" src="resources/images/icons/tile.png" alt="카드보기"/>
			<img style="width:30px; height:30px;" src="resources/images/icons/list.png" alt="리스트보기"/>
			</span>
		</div>
		
		<!--  정렬 및 상세검색버튼 -->
		<div class="container" style="clear: both;">
			<label>정렬</label>
			<select id="order-select" name="order" class="form-control orderselect">
				<option value="평점" ${order=="평점"?"selected":""}>평점</option>
				<option value="평가수" ${order=="평가수"?"selected":""}>평가수</option>
				<option value="신상품" ${order=="신상품"?"selected":""}>신상품</option>
				<option value="가격" ${order=="가격"?"selected":""}>가격</option>
			</select>
			<img id="order-descbutton" style="width:30px; height:30px;" src="resources/images/icons/uparrow.png" alt="오름차순"/>
			<img id="order-ascbutton" style="width:30px; height:30px;" src="resources/images/icons/downarrow.png" alt="내림차순"/>
			<button class="btn btn-primary" type="button" id="detail-search-button">상세검색..</button>
		</div>
		
		<br>

		<!-- 책 리스트 -->
		<div class="container">
			<div class="row" style="justify-content: center">
			<c:forEach items="${books}" var="book">
				<li class="bookcard center">
					<a href="bookDetailPage?bookcode=${book.code}"><img class="bookimage" src="resources/images/books/${book.code}.jpg"></a>
					<ul class="prev_info" style="width:200px">
						<li class="center">
						<a href="bookDetailPage?bookcode=${book.code}">
							<b>${book.name}</b>
						</a>
						</li>
						<li class="center"><span class="prev_writer">${book.authorname }</span>
						<span class="prev_publish">${book.publisher }</span></li>
						<li class="center price_color"><span class="numeric" data-numeric="${book.realprice }"></span>원</li>
						<li style="text-align: center">
						<c:forEach var="score" begin="1" end="${book.averagescore }" step="1">
						<img src="resources/images/icons/star.PNG" width="25px" height="25px">
						</c:forEach>
						${book.averagescore}(${book.evaluaternum})
						</li>
					</ul>
				</li>
			</c:forEach>
			</div>
		</div>
		<c:if test="${fn:length(books)==0}">
		<div class="container">
			<h1>검색 결과가 없습니다.</h1>
		</div>
		</c:if>
		<br>
	</body>
</html>