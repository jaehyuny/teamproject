<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>자유게시판</title>
<style>
a{color:#666; text-decoration: none;}
.modal-body{text-align:center; font-size:20px}
.free_box{min-height: 200px; padding:15px 13px; border:2px solid #e8e8e8; margin:20px 0;}
.free_head{padding:2px 8px; border-bottom:1px solid #ebebeb;}
.free_head h2{display:inline; color: #000; font-size:15px; font-family:"Nanum Gothic", sans-serif;}
.free_head .title{float:left; padding-bottom:2px;}
.free_head .report{float:right; padding:0 5px; margin:0 5px; border:1px solid #e8e8e8; font-size:14px;}
.free_head:after{content:""; display:block; clear:both;}
.free_user{position:relative; min-height:62px; margin:10px; padding:5px 10px; border:1px solid #e8e8e8}
.free_user .user_info{width:100%;vertical-align:top;}
.free_user .user_info .title{font-weight:bold; padding:0 0 6px 0; font-size:110%;}
.free_user .user_info .item{padding-bottom:5px; color:#666;  vertical-align:middle; font-size:14px}
.free_user .user_info .item strong.th{display:inline-block; width:48px;}
.free_user .user_info .item .line{padding:0 3px; font-size:15px;}
.free_user .user_info .item .interval{padding:0 20px 0 20px;}
.free_user .user_info .item .info{display:inline-block; width:400px; padding-bottom:1px;}
.free_user .user_info .item .star{display:inline-block; padding-bottom:1px;}
.free_user:after{content:""; display:block; clear:both;}
.free_body_view{width:100%;}
.free_body{margin: 10px 0; line-height:1.4; overflow-x:auto; overflow-y:hidden; margin:10px; padding:5px;}
.free_widget{width:535px; margin:10px auto; text-align:center}
.free_widget .likecount{float:left; width:105px; height:79px; padding-top:18px; background:url(resources/images/like_box.gif) no-repeat left top; text-align:center;}
.free_widget .likecount span{display:block; margin-bottom:5px;}
.free_widget .likecount .lcount{padding-left:25px; font-family:font-size:20px; font:20px tahoma; background:url(resources/images/icons/like.png) no-repeat left center; background-size:18px;}
.free_widget .likecount .dcount{padding-left:25px; font-family:font-size:20px; font:20px tahoma; background:url(resources/images/icons/dislike.png) no-repeat left center; background-size:18px;}
.free_widget .free_box{width:415px margin-left:110px; padding:8px 0; border:3px #e0e0e0 solid;}
.free_widget .free_box table{width:100%;}
.free_widget .free_box th{text-align:left; width:100px; padding-left:18px; border-right:1px solid #e0e0e0;}
.free_widget .free_box th strong{color:#009dc8;}
</style>
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
<script type="text/javascript">
	//좋아요, 싫어요 관련
	function clickLike(){
		togglefreeLike('좋아요');
	}
	function clickDisLike(){
		togglefreeLike('싫어요');
	}
	function togglefreeLike(eval){
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
					togglefreeBadge(data.userlike);
				},
				error : function(xr,status,error){
					//통신 실패시 실행할 내용
					alert('서버 에러가 발생했습니다.');
				}
			});
		}
	}
	//툴팁
	function togglefreeBadge(userlike){
		if(userlike == '좋아요'){
			$('#clike').attr('title',"이미 추천하셨습니다. 클릭시 취소됩니다");
			$('#cdislike').attr('title',"이미 추천하셨습니다. 클릭시 비추천으로 변경됩니다");
		}else if(userlike == '싫어요'){
			$('#cdislike').attr('title',"이미 비추천하셨습니다. 클릭시 취소됩니다.");
			$('#clike').attr('title',"이미 비추천하셨습니다. 클릭시 추천으로 변경됩니다.");
		}else{
			$('#clike').attr('title',"이 게시글을 추천합니다.");
			$('#cdislike').attr('title',"이 게시글을 비추천합니다.");
		}
	}
	$(document).ready(function(){
		var userlike = $('#ulike').val();
		togglefreeBadge(userlike);
		var code = $('#bcode').val();
		var bname = $('#bname').val();
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
	<input type="hidden" id="bscore" value="${board.score}">
	<input type="hidden" id="bname" value="${board.boardname}">
	<input type="hidden" id="bcode" value="${board.code}">
	<input type="hidden" id="ulike" value="${boardlike.eval}">
	<div class="free_box">
		<form>
		<div class="free_head">
			<div class="title">
				<h2>${board.title}</h2>
			</div>
			<div class="report" style="cursor:pointer"><i class="fas fa-ban"></i> 신고</div>
		</div>
		<div class="free_user">
			<table>
				<tr>
					<td class="user_info">
						<div class="item">
							<strong class="th">작 성 자</strong>
							<span class="line">|</span>
							<span class="info">${board.username} (${board.harfid})</span>
						</div>
						<div class="item">
							<strong class="th">조 회 수</strong>
							<span class="line">|</span>
							<span class="info">${board.hit} 회</span>
							<strong class="th">게 시 일</strong>
							<span class="line">|</span>
							<span>${board.time}</span>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<table class="free_body_view">
			<tbody>
				<tr>
					<td>
						<div class="free_body">
							${board.content}
						</div>
					</td>
				</tr>
			</tbody>
		</table>
		<div style="margin:10px 0; padding:10px 0; border-top:1px solid #e8e8e8; border-bottom:1px solid #e8e8e8; text-align:center;">이 게시글을</div>
		<div class="free_widget row">
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
						<a href="javascript:void(0)" type="button" id="modifybtn" class="btn pri-back" style="width:32%">수 정</a>
						<a href="javascript:void(0)" type="button" id="deletebtn" class="btn pri-back" style="width:32%">삭 제</a>
						<a href="boardList" type="button" class="btn pri-back" style="width:32%">목 록</a>
					</div>
					<div class="col-3"></div>
				</c:when>
				<c:otherwise>
					<div class="col-5"></div>
					<div class="col-2">
						<a href="boardList" type="button" class="btn pri-back btn-block">목록</a>
					</div>
					<div class="col-5"></div>
				</c:otherwise>
			</c:choose>
		</div>
		</form>
	</div>
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