<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
		<meta charset="UTF-8">
		<title>리뷰 : ${book.name }</title>
		<style>
		#main{
			font-family:'notosans';
			font-weight: bold;
			color: #3c3c3c;
		}
		.reviewcard{
			background-image: linear-gradient(#e6e6e6, #f5f5f5);
			border:3px solid #f5f5f5;
			padding: 10px;
			margin: 10px;
			display: inline-block;
			cursor: pointer;
			transition-duration : 0.5s;
			transition-property : all;
		}
		.reviewcard:hover{
			background-image: linear-gradient(#b9b9b9, #e4e4e4);
			border:6px solid #f5f5f5;
		}
		.evaluatecard{
			background-image: linear-gradient(#e6e6e6, #f5f5f5);
			border:3px solid #f5f5f5;
			padding: 10px;
			margin: 10px;
			display: inline-block;
			text-align: left;
			cursor: pointer;
			transition-duration : 0.5s;
			transition-property : all;
		}
		.evaluatecard:hover{
			background-image: linear-gradient(#b9b9b9, #e4e4e4);
			border:6px solid #f5f5f5;
		}
		.bigsize{
			width: 400px;
			height: 250px;
		}
		.xlargesize{
			width:45%;
			min-width:312px;
			height:250px;
		}
		
		.mediumsize{
			width: 31%;
			min-width: 286px;
			height : 190px;
		}
		.smallsize{
			width: 22%;
			min-width: 240px;
			height: 186px;
		}

		#evaluate-tab-button{
			cursor: pointer;
		}
		#review-tab-button{
			cursor: pointer;
		}
		
		.hidden{
			display:none;
		}
		@media (max-width: 992px) { 
			.caracel {
			display: none;
			}
		}
		</style>
		<script>
		var evaluateCode;
		var reviewCode;
		var reviewBoardName;
		function refresh(){
			$(".newevaluate").load(location.href + " .newevaluate2");
			$(".newreview").load(location.href + " .newreview2");
			$("#evaluate-list").load(location.href + " #evaluate-list2");
			$("#review-list").load(location.href + " #review-list2");
		}
		function toggleEvaluateBadge(userlike){
			if(userlike == '좋아요'){
				$('#evaluate-view-alreadylike').removeClass('hidden');
				$('#evaluate-view-alreadylike').text('이미 \'좋아요\' 표시를 했습니다.');
			}else if(userlike == '싫어요'){
				$('#evaluate-view-alreadylike').removeClass('hidden');
				$('#evaluate-view-alreadylike').text('이미 \'싫어요\'  표시를 했습니다.');
			}else{
				$('#evaluate-view-alreadylike').addClass('hidden');
			}
		}
		function toggleReviewBadge(userlike){
			if(userlike == '좋아요'){
				$('#review-view-alreadylike').removeClass('hidden');
				$('#review-view-alreadylike').text('이미 \'좋아요\' 표시를 했습니다.');
			}else if(userlike == '싫어요'){
				$('#review-view-alreadylike').removeClass('hidden');
				$('#review-view-alreadylike').text('이미 \'싫어요\'  표시를 했습니다.');
			}else{
				$('#review-view-alreadylike').addClass('hidden');
			}
		}
		function deleteEvaluate(){
			location.href='deleteEvaluate?code='+evaluateCode+'&bookcode=${book.code}';
		}
		function deleteReview(){
			location.href='deleteReview?code='+reviewCode+'&boardname='+reviewBoardName+'&bookcode=${book.code}';
		}
		function onClickEvaluateLike(){
			toggleEvaluateLike('좋아요');
		}
		function onClickEvaluateDislike(){
			toggleEvaluateLike('싫어요');
		}
		function onClickReviewLike(){
			toggleReviewLike('좋아요');
		}
		function onClickReviewDislike(){
			toggleReviewLike('싫어요');
		}
		function toggleReviewLike(eval){
		  if(${sessionid eq null}){
			  alert("로그인 해야합니다.");
		  }else{
			  $.ajax({
				type : 'POST',
				data : "boardcode="+reviewCode+"&boardname="+reviewBoardName+"&eval="+eval,
				datatype : 'json',
				url : "toggleBoardLike",
				success : function(data){
					//통신 성공시 실행할 내용
					$('#review-view-like').text(data.likecount);
					$('#review-view-dislike').text(data.dislikecount);
					toggleReviewBadge(data.userlike);
					refresh();
				}
			  });
			}
		}
	
		function toggleEvaluateLike(eval){
		  if(${sessionid eq null}){
			  alert("로그인 해야합니다.");
		  }else{
			  $.ajax({
				type : 'POST',
				data : "evaluatecode="+evaluateCode+"&eval="+eval,
				datatype : 'json',
				url : "toggleEvaluateLike",
				success : function(data){
					//통신 성공시 실행할 내용
					$('#evaluate-view-like').text(data.likecount);
					$('#evaluate-view-dislike').text(data.dislikecount);
					toggleEvaluateBadge(data.userlike);
					refresh();
				}
			  });
			}
		}
		function openReviewCard(code,boardname){
			  $.ajax({
				type : 'POST',
				data : "code="+code+"&boardname="+boardname,
				datatype : 'json',
				url : "getReviewByCode",
				success : function(data){
					//통신 성공시 실행할 내용
					var time = new Date(data.time);
					reviewCode=data.code;
					reviewBoardName=data.boardname;
					$('#review-view-topbody').text(data.userid +" - "+ time.getFullYear()+"년 "+time.getMonth()+"월 "+time.getDay()+"일");
					$('#review-view-topbody2').text(data.title);
					var scorehtml = "";
					for(var i=0; i<data.score; i++){
						scorehtml += "<img src='resources/images/icons/star.PNG' width='30px' height='30px'/>";
					}
					$('#review-view-score').html(scorehtml);
					$('#review-view-body').html(data.content);
					var sessionid='${sessionid}';
					$('#review-view-like').text(data.likecount);
					$('#review-view-dislike').text(data.dislikecount);
					toggleReviewBadge(data.userlike);
					//해당 리뷰가 작성자 본인일경우 수정/삭제 표시
					if(data.userid==sessionid){
						$('#review-view-change').show();
						$('#review-view-delete').show();
					}else{
						$('#review-view-change').hide();
						$('#review-view-delete').hide();
					}

					//모달에 데이터 채워서 열어주기
					$('#review-view-modal').modal('show');
				}
			  });
		}
		function openEvaluateCard(code){
			  $.ajax({
				type : 'POST',
				data : "code="+code,
				datatype : 'json',
				url : "getEvaluateByCode",
				success : function(data){
					//통신 성공시 실행할 내용
					var time = new Date(data.time);
					evaluateCode=data.code;
					$('#evaluate-view-topbody').text(data.userid +" - "+ time.getFullYear()+"년 "+time.getMonth()+"월 "+time.getDay()+"일");
					$('#evaluate-view-body').html(data.content);
					var scorehtml = "";
					for(var i=0; i<data.score; i++){
						scorehtml += "<img src='resources/images/icons/star.PNG' width='30px' height='30px'/>";
					}
					$('#evaluate-view-score').html(scorehtml);
					$('#evaluate-view-like').text(data.likecount);
					$('#evaluate-view-dislike').text(data.dislikecount);
					var sessionid='${sessionid}';
					//평가 작성자가 본인일 경우 수정/삭제표시
					if(data.userid==sessionid){
						$('#evaluate-view-change').show();
						$('#evaluate-view-delete').show();
					}else{
						$('#evaluate-view-change').hide();
						$('#evaluate-view-delete').hide();
					}
					toggleEvaluateBadge(data.userlike);
					$('#evaluate-view-modal').modal('show');

				}
			  });
		}
		$(document).ready(function(){
			$('#evaluate-view-delete').on('click',function(){
				
			})
			$('#evaluate-tab-button').on('click',function(){
				$('#review-list').addClass("hidden");
				$('#evaluate-list').removeClass("hidden");
				$('#review-tab-button').removeClass("active");
				$('#evaluate-tab-button').addClass("active");
			});
			$('#review-tab-button').on('click',function(){
				$('#evaluate-list').addClass("hidden");
				$('#review-list').removeClass("hidden");
				$('#review-tab-button').addClass("active");
				$('#evaluate-tab-button').removeClass("active");
			});
		      $('#evaluate-score-select').barrating({
		          theme: 'fontawesome-stars'
		        });
		      $('#evaluate-write-button').on('click',function(){
		    	  if(${sessionid eq null}){
		    		  alert("로그인 해야합니다.");
		    	  }else{
					  $('#evaluate-write-modal').modal('show');
		    	  }
		      });
		      $('#evaluate-write-confirm').on('click',function(){
					alert("evalwrite 동작");
		    	  $.ajax({
		    		type : 'POST',
					data : "bookcode="+${book.code}+"&content="+$('#evaluate-content').val()+"&score="+$('#evaluate-score-select').val(),
					datatype : 'json',
					url : "insertEvaluate",
					success : function(data){
						//통신 성공시 실행할 내용
						if(data=='duplicate'){
							alert("이미 리뷰하셨습니다.");
						}else{
							$(".newevaluate").load(location.href + " .newevaluate2");
						}
					},
					error : function(xr,status,error){
						//통신 실패시 실행할 내용
					}
		    	  });
		    	  $('#evaluate-write-modal').modal('hide');
		      });

		      $('#review-score-select').barrating({
		          theme: 'fontawesome-stars'
		        });
		      $('#review-write-button').on('click',function(){
		    	  if(${sessionid eq null}){
		    		  alert("로그인 해야합니다.");
		    	  }else{
					  $('#review-write-modal').modal('show');
		    	  }
		      });
		      $('#review-write-confirm').on('click',function(){
		    	  $.ajax({
		    		type : 'POST',
					data : "bookcode="+${book.code}+"&content="+$('#review-content').val()+"&score="+$('#review-score-select').val()+"&title="+$('#review-title').val(),
					datatype : 'json',
					url : "insertReview",
					success : function(data){
						//통신 성공시 실행할 내용
						if(data=='duplicate'){
							alert("이미 독후감을 작성하셨습니다.");
						}else{
							$(".newreview").load(location.href + " .newreview2");
							window.location.reload();
						}
					},
					error : function(xr,status,error){
						//통신 실패시 실행할 내용
						alert('오류가 발생했습니다. 다시 시도해주십시오.');
					}
		    	  });
		    	  $('#review-write-modal').modal('hide');
		      });
		});
		</script>
</head>
	<body>
		<!-- 제목 -->
		<div class="container">
			<br>
			<h1>${book.name }</h1>
			<h6>평가 : ${evaluatenum}건, 독후감 : ${ reportnum}건, 평균 평점 : ${book.averagescore }점</h6>
		</div>
		<hr>

		<!-- 가장 높은 추천을 받은 독후감 캐러셀 -->
		<div class="newreview">
		<div class="container caracel newreview2">
			<h4>가장 높은 추천을 받은 독후감!</h4>
			<div class="swiper-container" style="height:600px">
				<!-- Additional required wrapper -->
				<div class="swiper-wrapper">
					<!-- Slides -->
					<c:set var="divwrapper" value="1"/>
					<c:forEach var="one" items="${reporttop20 }" >
					<c:if test="${divwrapper==1 }">
					<div class="swiper-slide" style="text-align:center">
					</c:if>
						<div class="reviewcard bigsize" style="text-align: left; vertical-align: top" onclick="openReviewCard(${one.code},'${one.boardname}')">
						<div style="width: 100%; height:85%">
						<c:choose>
						<c:when test="${one.title  eq  'nodata'}">
						<span class="username">
							글이 없습니다.
						</span>
						</c:when>
						<c:otherwise>
							<span class="username">
								<img class="rounded-circle" src="resources/images/bono.jpg" style="float: left;	" width="50px" height="50px"/>
								${one.userid }
								<c:forEach var="i" begin="1" end="${one.score}" step="1">
									<img src="resources/images/icons/star.PNG" width="25px" height="25px">
								</c:forEach>
							</span>
							<br>
							<span class="">${one.title }</span>
							<div style="clear: both; padding: 10px; max-height:62%; word-break:break-word; overflow-y:hidden; ">
							${one.content }
							</div>
						</div>
						<div>
						<img src="resources/images/icons/like.png" width="30px" height="30px">${one.likecount }
						<span style="display: inline-block;">
							<img src="resources/images/icons/dislike.png" width="30px" height="30px"> ${one.dislikecount }
						</span>
						댓글 : n개
						 <span style="font-size: 15px" > ${one.time }</span>
						</c:otherwise>
						</c:choose>
						</div>
						</div>
					<c:if test="${divwrapper==4 }">
					</div>
					<c:set var="divwrapper" value="0"/>
					</c:if>
					<c:set  var="divwrapper" value="${divwrapper+1 }"/>
					</c:forEach>
				</div>
				<!-- If we need pagination -->
				<div class="swiper-pagination"></div>
			
				<!-- If we need navigation buttons -->
				<div class="swiper-button-prev"></div>
				<div class="swiper-button-next"></div>
			</div>
			<div style="text-align:right ">
				<button class="btn btn-primary" id="review-write-button">독후감 쓰기</button>
			</div>
		</div>
		</div>
		<!-- 최신 리뷰! -->
		<div class="container newevaluate">
			<div class="newevaluate2">
				<h4>최신 리뷰!</h4>
				<div style="text-align:center">
				<c:forEach items="${evaluatetop8 }" var="one" >
				<div class="evaluatecard smallsize" onclick="openEvaluateCard(${one.code})">
					<div style="width:100%; height:75%">
					<span class="username">
						<img class="rounded-circle" src="resources/images/bono.jpg" style="float: left;	" width="50px" height="50px"/>
						<div style="display: inline-block;  width: 75%; text-overflow: ellipsis; overflow: hidden; margin-bottom: -6px">
						${one.userid }
						</div>
						<br>
						<span>
						<c:forEach var="i" begin="1" end="${one.score}" step="1">
							<img src="resources/images/icons/star.PNG" width="25px" height="25px">
						</c:forEach>
						</span>
					</span>
					<div class="container"style="clear: both; text-align: center; word-break:break-word; font-size: 12px; max-height:62%; overflow-y:hidden; ">
						${one.content}
					</div>
					</div>
					<div>
					<img src="resources/images/icons/like.png" width="30px" height="30px">${one.likecount }
						<span style="display: inline-block;">
							<img src="resources/images/icons/dislike.png" width="30px" height="30px"> ${one.dislikecount }
						</span>
						 <span style="font-size: 15px; display: inline-block;" > ${one.time }</span>
					</div>
				</div>
				</c:forEach>
				<div style="text-align:right ">
					<button id="evaluate-write-button" class="btn btn-primary">리뷰 쓰기</button>
				</div>
				</div>
			</div>
		</div>
		<br>
		
		<!-- 상단탭 -->
		<div class="container">
			<h4>모든 평가 살펴보기</h4>
			<ul class="nav nav-tabs">
			  <li class="nav-item">
				<a id="evaluate-tab-button" class="nav-link active">평가</a>
			  </li>
			  <li class="nav-item">
				<a id="review-tab-button" class="nav-link">독후감</a>
			  </li>
			</ul>	
			<select id="amount" style="margin:15px;width: auto; display: inline-block; vertical-align: middle"class="form-control" name="amount">
				<option value="최신">최신 순서로 보기</option>
				<option value="인기">인기 순서로 보기</option>
			</select>
		</div>
		
		<!-- 리뷰 리스트 -->
		<div id="evaluate-list" class="container" style="text-align: center">
			<div id="evaluate-list2">
			<c:forEach items="${bookevaluate }" var="one" >
				<div class="evaluatecard mediumsize" onclick="openEvaluateCard(${one.code})">
					<div style="width:100%; height:80%">
					<span class="username">
						<img class="rounded-circle" src="resources/images/bono.jpg" style="float: left;	" width="50px" height="50px"/>
						<div style="display: inline-block; text-overflow: ellipsis; width: 75% ">
						${one.userid }
						</div>
						<br>
						<c:forEach var="i" begin="1" end="${one.score}" step="1">
							<img src="resources/images/icons/star.PNG" width="25px" height="25px">
						</c:forEach>
					</span>
					<div class="container"style="clear: both; text-align: center; word-break:break-word; max-height:62%; overflow-y:hidden;  ">
						${one.content}
					</div>
					</div>
					<div>
					<img src="resources/images/icons/like.png" width="30px" height="30px">${one.likecount }
						<span style="display: inline-block;">
							<img src="resources/images/icons/dislike.png" width="30px" height="30px"> ${one.dislikecount }
						</span>
						 <span style="font-size: 15px" > ${one.time }</span>
					</div>
				</div>
			</c:forEach>
			</div>
		</div>

		<!-- 독후감리스트 -->
		<div id="review-list" class="container hidden" style="text-align: center;">
			<div id="review-list2">
			<c:forEach var="one" items="${bookreport }" >
				<div class="reviewcard xlargesize" style="text-align: left" onclick="openReviewCard(${one.code},'${one.boardname }')">
				<c:choose>
				<c:when test="${one.title  eq  'nodata'}">
					글이 없습니다.
				</c:when>
				<c:otherwise>
				<div style="width: 100%; height:80%">
					<span class="username">
						<img class="rounded-circle" src="resources/images/bono.jpg" style="float: left;	" width="50px" height="50px"/>
						${one.userid }
						<span>
						<c:forEach var="i" begin="1" end="${one.score}" step="1">
							<img src="resources/images/icons/star.PNG" width="25px" height="25px">
						</c:forEach>
						</span>
					</span>
					<br>
					<span class="">${one.title }</span>
					<div style="clear: both; padding: 10px; max-height:62%; overflow-y:hidden; word-break:break-word; ">
					${one.content }
					</div>
				</div>
				<div>
				<img src="resources/images/icons/like.png" width="30px" height="30px">${one.likecount }
				<span style="display: inline-block;">
					<img src="resources/images/icons/dislike.png" width="30px" height="30px"> ${one.dislikecount }
				</span>
				댓글 : n개
				 <span style="font-size: 15px; display: inline-block;" > ${one.time }</span>
				</div>
				</c:otherwise>
				</c:choose>
				</div>
			</c:forEach>
			</div>
		</div>
		
		<!-- 평가 확인 모달 -->
		<div class="modal fade" id="evaluate-view-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
		  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
			<div class="modal-content">
			  <div class="modal-header">
				<h5 class="modal-title" id="evaluate-view-title">리뷰</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				  <span aria-hidden="true">&times;</span>
				</button>
			  </div>
			  <div class="modal-body">
			  	<div id="evaluate-view-topbody" style="margin-left: 3px">
			  	</div>
			  	<div id="evaluate-view-score" >
			  	</div>
				<div id="evaluate-view-body" style="min-height: 300px; padding:10px;">
				</div>
				<div id="evaluate-view-likeform" style="text-align: center;">
					<div id="evaluate-view-innerlikeform">
						<img src='resources/images/icons/like.png' width='30px' height='30px' onclick="onClickEvaluateLike()" style="cursor: pointer;"> 
						 <span id="evaluate-view-like"></span>
						<img src='resources/images/icons/dislike.png' width='30px' height='30px' onclick="onClickEvaluateDislike()" style="cursor:pointer;"/> 
						 <span id="evaluate-view-dislike"></span>
						 <br>
						 <span id="evaluate-view-alreadylike" class="badge badge-pill badge-primary"></span>
					</div>
				</div>
			  </div>
			  <div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
				<button id="evaluate-view-delete" type="button" class="btn btn-primary" onclick="deleteEvaluate()">삭제</button>
			  </div>
			</div>
		  </div>
		</div>
		
		<!--  독후감 확인 모달 -->
		<div class="modal fade" id="review-view-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
		  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
			<div class="modal-content">
			  <div class="modal-header">
				<h5 class="modal-title" id="review-view-title">독후감</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				  <span aria-hidden="true">&times;</span>
				</button>
			  </div>
			  <div class="modal-body">
			  	<div id="review-view-topbody" style="margin-left: 3px">
			  	</div>
			  	<div id="review-view-topbody2" style="margin-left: 3px; font-size: 17px;">
			  	</div>
			  	<div id="review-view-score" >
			  	</div>
				<div id="review-view-body" style="min-height: 300px; padding:10px;">
				</div>
				<div id="review-view-likeform" style="text-align: center;">
					<div id="reivew-view-innerlikeform">
						<img src='resources/images/icons/like.png' width='30px' height='30px' onclick="onClickReviewLike()" style="cursor: pointer;"> 
						 <span id="review-view-like"></span>
						<img src='resources/images/icons/dislike.png' width='30px' height='30px' onclick="onClickReviewDislike()" style="cursor:pointer;"/> 
						 <span id="review-view-dislike"></span>
						 <br>
						 <span id="review-view-alreadylike" class="badge badge-pill badge-primary"></span>
					</div>
				</div>
			  </div>
			  <div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
				<button id="review-view-change" type="button" class="btn btn-primary">수정(이동됨)</button>
				<button id="review-view-delete" type="button" class="btn btn-primary" onclick="deleteReview()">삭제</button>
			  </div>
			</div>
		  </div>
		</div>
		
		<!-- 리뷰 작성 모달 -->
		<div class="modal fade" id="evaluate-write-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
		  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
			<div class="modal-content">
			  <div class="modal-header">
				<h5 class="modal-title" id="exampleModalLongTitle">리뷰 작성</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				  <span aria-hidden="true">&times;</span>
				</button>
			  </div>
			  <div class="modal-body">
				<input type="hidden" name="bookcode" value="${book.code }"/>
				<textarea class="form-control" id="evaluate-content" style="margin-bottom: 10px" name="content"  rows="5" placeholder="내용을 입력하세요.."></textarea>
				  <select id="evaluate-score-select" name="score">
					  <option value="1">
					  <option value="2">
					  <option value="3">
					  <option value="4">
					  <option value="5">
				  </select>
			  </div>
			  <div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
				<button id="evaluate-write-confirm" type="button" class="btn btn-primary">등록</button>
			  </div>
			</div>
		  </div>
		</div>
		<!-- 독후감 작성 모달 -->
		<div class="modal fade" id="review-write-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
		  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
			<div class="modal-content">
			  <div class="modal-header">
				<h5 class="modal-title" id="exampleModalLongTitle">독후감 작성</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				  <span aria-hidden="true">&times;</span>
				</button>
			  </div>
			  <div class="modal-body">
				<input type="hidden" name="bookcode" value="${book.code }"/>
				<input class="form-control" type="text" id="review-title" placeholder="제목을 입력하세요." style="margin-bottom:10px"/>
				<textarea class="form-control" id="review-content" style="margin-bottom: 10px" name="content"  rows="11" placeholder="내용을 입력하세요.."></textarea>
				  <select id="review-score-select" name="score">
					  <option value="1">
					  <option value="2">
					  <option value="3">
					  <option value="4">
					  <option value="5">
				  </select>
			  </div>
			  <div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
				<button id="review-write-confirm" type="button" class="btn btn-primary">등록</button>
			  </div>
			</div>
		  </div>
		</div>
	</body>
	<script>
		 var mySwiper = new Swiper ('.swiper-container', {
			// Optional parameters
			direction: 'horizontal',
			loop: true,

			// If we need pagination
			pagination: {
			  el: '.swiper-pagination',
			},

			// Navigation arrows
			navigation: {
			  nextEl: '.swiper-button-next',
			  prevEl: '.swiper-button-prev',
			},

			// And if we need scrollbar
			scrollbar: {
			},
			
			autoplay: {
				delay: 6000,
			  },
		  })
		</script>
</html>