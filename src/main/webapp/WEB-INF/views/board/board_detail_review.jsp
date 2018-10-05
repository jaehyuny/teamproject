<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>독후감 보기</title>
<style>
a{color:#666; text-decoration: none;}
.modal-body{text-align:center; font-size:20px}
.review_box{min-height: 200px; padding:15px 13px; border:2px solid #e8e8e8; margin:20px 0;}
.review_head{padding:2px 8px; border-bottom:1px solid #ebebeb;}
.review_head h2{display:inline; color: #000; font-size:15px; font-family:"Nanum Gothic", sans-serif;}
.review_head .title{float:left; padding-bottom:2px;}
.review_head .b_username{border-left:1px solid #ccc; margin-left:10px; padding-left:10px;}
.review_head .date{float:right; color:#999; font:12px tahoma normal;}
.review_head:after{content:""; display:block; clear:both;}
.review_book{position:relative; min-height:93px; margin:10px; padding:5px; border:1px solid #e8e8e8}
.review_book_item{vertical-align:top;}
.review_book_item .book_img{display:block;margin-right:10px; border:1px solid #6d6d6d;}
.review_book .book_info{width:100%;vertical-align:top;}
.review_book .book_info .title{font-weight:bold; padding:0 0 6px 0; font-size:110%;}
.review_book .book_info .item{padding-bottom:5px; color:#666;  vertical-align:middle; font-size:14px}
.review_book .book_info .item strong.th{display:inline-block; width:48px;}
.review_book .book_info .item .line{padding:0 3px; font-size:15px;}
.review_book .book_info .item .interval{padding:0 20px 0 20px;}
.review_book .book_info .item .info{display:inline-block; width:400px; padding-bottom:1px;}
.review_book .book_info .item .star{display:inline-block; padding-bottom:1px;}
.review_book:after{content:""; display:block; clear:both;}
.review_body_view{width:100%;}
.review_body{margin: 10px 0; line-height:1.4; overflow-x:auto; overflow-y:hidden; margin:10px; padding:5px;}
.review_widget{width:535px; margin:10px auto; text-align:center}
.review_widget .likecount{float:left; width:105px; height:79px; padding-top:18px; background:url(resources/images/like_box.gif) no-repeat left top; text-align:center;}
.review_widget .likecount span{display:block; margin-bottom:5px;}
.review_widget .likecount .lcount{padding-left:25px; font-family:font-size:20px; font:20px tahoma; background:url(resources/images/icons/like.png) no-repeat left center; background-size:18px;}
.review_widget .likecount .dcount{padding-left:25px; font-family:font-size:20px; font:20px tahoma; background:url(resources/images/icons/dislike.png) no-repeat left center; background-size:18px;}
.review_widget .review_box{width:415px margin-left:110px; padding:8px 0; border:3px #e0e0e0 solid;}
.review_widget .review_box table{width:100%;}
.review_widget .review_box th{text-align:left; width:100px; padding-left:18px; border-right:1px solid #e0e0e0;}{}
.review_widget .review_box th strong{color:#009dc8;}
</style>
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
<script type="text/javascript">
	//클릭시 해당 책의 구매페이지를 새창으로 오픈
	function bookDetail(bookcode){
		window.open("bookDetailPage?bookcode="+bookcode);
	}
	function clickLike(){
		toggleReviewLike('좋아요');
	}
	function clickDisLike(){
		toggleReviewLike('싫어요');
	}
	function toggleReviewLike(eval){
		var code = $('#bcode').val();
		var boardname = $('#bname').val();
		if(${sessionid eq null}){
			alert("로그인 해야합니다.");
		}else{
			$.ajax({
				type : 'POST',
				data : "boardcode="+code+"&boardname="+boardname+"&eval="+eval,
				datatype : 'json',
				url : "toggleBoardLike",
				success : function(data){
					//통신 성공시 실행할 내용
					$('#likeClick').text(data.likecount);
					$('#dislikeClick').text(data.dislikecount);
					toggleReviewBadge(data.userlike);
				},
				error : function(xr,status,error){
					//통신 실패시 실행할 내용
					alert('서버 에러가 발생했습니다.');
				}
			});
		}
	}
	//툴팁
	function toggleReviewBadge(userlike){
		if(userlike == '좋아요'){
			$('#clike').attr('title',"이미 추천하셨습니다. 클릭시 취소됩니다");
			$('#cdislike').attr('title',"이미 추천하셨습니다. 클릭시 비추천으로 변경됩니다");
		}else if(userlike == '싫어요'){
			$('#cdislike').attr('title',"이미 비추천하셨습니다. 클릭시 취소됩니다.");
			$('#clike').attr('title',"이미 비추천하셨습니다. 클릭시 추천으로 변경됩니다.");
		}else{
			$('#clike').attr('title',"이 독후감이 유용하다면 클릭하여 추천하세요.");
			$('#cdislike').attr('title',"이 독후감이 유용하지않았다면 클릭하여 비추천하세요.");
		}
	}
	$(document).ready(function(){
		//별점
		var score = $('#bscore').val();
		$('#score').barrating('show',{
			theme: 'fontawesome-stars',
			showSelectedRating: true,
			initialRating: score,
			readonly: true,
		});
		var userlike = $('#ulike').val();
		toggleReviewBadge(userlike);
		$('#modifybtn').on('click',function(){
			$(location).attr('href',"boardUpdateForm?code="+$('#bcode').val()+"&boardname="+$('#bname').val());
		});
		$('#deletebtn').on('click',function(){
			$('#deleteModal').show();
			$('.modal-header').hide();
			$('#modalbtn_d').on('click',function(){
				$(location).attr('href',"boardDelete?code="+$('#bcode').val()+"&boardname="+$('#bname').val());
			});
			$('#modalbtn_c').on('click',function(){
				$('#deleteModal').hide();
			});
		});
	});
</script>
</head>
<body>
<div class="container">
	<form>
	<input type="hidden" id="bscore" value="${board.score}">
	<input type="hidden" id="bname" value="${board.boardname}">
	<input type="hidden" id="bcode" value="${board.code}">
	<input type="hidden" id="ulike" value="${boardlike.eval}">
	<div class="review_box">
		<div class="review_head">
			<div class="title">
				<h2>${board.title}</h2>
				<span class="b_username">${board.username}</span>
			</div>
			<div class="date">${board.time}</div>
		</div>
		<div class="review_book">
			<table>
				<tr>
					<td class="review_book_item">
						<a href="javascript:bookDetail(${board.bookcode})">
							<img class="book_img" alt="${board.bookname}" src="resources/images/books/${board.bookcode}.jpg" width="100" height="120">
						</a>
					</td>
					<td class="book_info">
						<div class="title">
							<a href="javascript:bookDetail(${board.bookcode})">${board.bookname}</a>
						</div>
						<div class="item">
							<strong class="th">저 &nbsp; 자</strong>
							<span class="line">|</span>
							<span class="info">${board.authorname}</span>
							<strong class="th">평 &nbsp; 점</strong>
							<span class="line">|</span>
							<span class="star">
							<select id="score">
								<c:forEach var="i" begin="1" end="5">
									<option value="${i}" <c:if test="${i==board.score}">selected="selected"</c:if>>${i}</option>
								</c:forEach>
							</select>
							</span>
						</div>
						<div class="item">
							<strong class="th">출판사</strong>
							<span class="line">|</span>
							<span class="info">${board.publisher}</span>
							<strong class="th">출판일</strong>
							<span class="line">|</span>
							<span>${board.publishyear}.${board.publishmonth}.${board.publishday}</span>
						</div>
						<div class="item">
							<strong class="th">정 &nbsp; 가</strong>
							<span class="line">|</span>
							<span class="info">
								<c:choose>
									<c:when test="${board.price==board.realprice}"><strong>${board.price}</strong> 원</c:when>
									<c:otherwise><strong style="text-decoration: line-through;">${board.price}</strong> 원</c:otherwise>
								</c:choose>
							</span>
							<strong class="th">판매가</strong>
							<span class="line">|</span>
							<span><strong>${board.realprice}</strong> 원 ( ${board.discount}% 할인 )</span>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<table class="review_body_view">
			<tbody>
				<tr>
					<td>
						<div class="review_body">
							${board.content}
						</div>
					</td>
				</tr>
			</tbody>
		</table>
		<div style="margin:10px 0; padding:10px 0; border-top:1px solid #e8e8e8; text-align:center;">이 독후감이 유용하셨나요?</div>
		<div class="review_widget row">
			<div style="cursor:pointer;float:none;margin:0 auto;" class="likecount" id="clike" onClick="clickLike()" data-toggle="tooltip" title="">
				<span style="font-size: 13px">추 &nbsp; 천</span>
				<strong class="lcount" id="likeClick">${board.likecount}</strong>
			</div>
			<div style="cursor:pointer;float:none;margin:0 auto;" class="likecount" id="cdislike" onClick="clickDisLike()" data-toggle="tooltip" title="">
				<span style="font-size: 13px">비추천</span>
				<strong class="dcount" id="dislikeClick">${board.dislikecount}</strong>
			</div>
		</div>
		<div style="margin:10px 0; border-top:1px solid #e8e8e8; text-align:center;"></div>
		<div class="row">
			<c:choose>
				<c:when test="${board.userid eq sessionid}">
					<div class="col-3"></div>
					<div class="col-6">
						<a href="javascript:void(0)" type="button" class="btn pri-back" id="modifybtn" style="width:32%">수 정</a>
						<a href="javascript:void(0)" type="button" class="btn pri-back" id="deletebtn" style="width:32%">삭 제</a>
						<a href="reviewList" type="button" class="btn pri-back" style="width:32%">목 록</a>
					</div>
					<div class="col-3"></div>
				</c:when>
				<c:otherwise>
					<div class="col-5"></div>
					<div class="col-2">
						<a href="reviewList" type="button" class="btn pri-back btn-block">목 록</a>
					</div>
					<div class="col-5"></div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
	</form>
	<!-- The Modal -->
	<div class="modal" id="deleteModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">Modal Heading</h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				<!-- Modal body -->
				<div class="modal-body">
					<p>삭제된 게시물은 복구할 수 없습니다.</p>
					<p>이 게시물을 삭제하시겠습니까?</p>
				</div>
				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-danger" id="modalbtn_d" data-dismiss="modal">삭 제</button>
					<button type="button" class="btn btn-warning" id="modalbtn_c" data-dismiss="modal">취 소</button>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>