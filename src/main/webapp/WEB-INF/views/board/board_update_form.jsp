<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시글 수정</title>
<style>
.modal-body{text-align:center; font-size:20px}
.review_book{position:relative; min-height:93px; padding:5px 10px; border:1px solid #e8e8e8}
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
.boardBookSearch{
			transition: transform 500ms cubic-bezier(0.000, 0.575, 0.000, 0.995);
			height:0px;
			max-height:0px;
			transform:scaleX(0.9);
			overflow: hidden;
		}
		.boardBookSearch-clicked{
			transform:scaleX(1);
			height:auto;
			max-height:1000px;
			display: block;
		}
</style>
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
<script type="text/javascript">
	$(function(){
		//textarea에 ckeditor 적용
		CKEDITOR.replace('b_content');
		//ckeditor 이미지 업로드
		CKEDITOR.on('dialogDefinition',function(ev){
			var dialogName = ev.data.name;
			var dialogDefinition = ev.data.definition;
			switch(dialogName){
			case 'image':
				//dialogDefinition.removeContents('info');
				dialogDefinition.removeContents('Link');
				dialogDefinition.removeContents('advanced');
			}
		});
	});
	$(document).ready(function(){
		if($('#boardname').val()=="freeboard"){
			$('#selectBookCode').val(999999999);
		}
		var imgname = $('#selectBookCode').val();
		$("#book_img").attr('src',"resources/images/books/"+imgname+".jpg");
		var bscore = $('#boardscore').val();
		$('#score').barrating('show',{
			theme: 'fontawesome-stars',
			initialRating: bscore,
			showSelectedRating: true,
		});
		var averagescore = parseInt($('#boardaveragescore').val());
		$('#uscore').barrating('show',{
			theme: 'fontawesome-stars',
			initialRating: averagescore,
			showSelectedRating: true,
			readonly: true,
		});
		$('#booksearch').prop("readonly","true");
		//저장
		$('#boardsave').on('click',function(){
			$('#board_update_form').submit();
		});
		//삭제
		$('#deletebtn').on('click',function(){
			$('#deleteModal').show();
			$('.modal-header').hide();
			$('#modalbtn_d').on('click',function(){
				$(location).attr('href',"boardDelete?code="+$('#bcode').val()+"&boardname="+$('#boardname').val());
			});
			$('#modalbtn_c').on('click',function(){
				$('#deleteModal').hide();
			});
		});
		if($('#boardname').val()=="freeboard"){
			$('.review_book').hide();
			$('.review_book_search').hide();
		}
		if($('#boardname').val()=="reviewboard"){
			$('.review_book').show();
			$('.review_book_search').show();
			$('#checklabel').hide();
		}
		//도서정보 검색
		$('#booksearchbtn').on('click',function(){
			var name = $('#booksearch').val();
			if(name==""){
				alert("검색할 도서명을 입력하세요");
				return;
			}
			$.ajax({
				type : 'POST',
				data : "name="+name,
				datatype : 'json',
				url : 'boardBookSearch',
				success : function(data){
					//통신 성공시 실행할 내용
					$('.boardBookSearch').addClass('boardBookSearch-clicked')
					var selectHtmlText = "";
					for(var i=0; i<data.length; i++){
						selectHtmlText += "<option value='"+data[i].name+"' code='"+data[i].code+"'>"+data[i].name+" "+data[i].publisher+"</option>";
					}
						$('#search-select').html(selectHtmlText);
				},
				error : function(xr,status,error){
					//통신 실패시 실행할 내용
					alert("ajax error");
				}
			});
		});
		//검색된 책 정보 선택시 해당 도서 정보를 도서정보용 박스에 입력시킴
		$('#search-select').on('change',function(){
			var selectedBookCode = $("#search-select option:selected").attr("code");				
			var selectedBookName = $('#search-select option:selected').val();
			$('#selectBookCode').val(selectedBookCode);
			$('#booksearch').val(selectedBookName);
			$('.review_book').show();
			$.ajax({
				type : 'POST',
				data : "code="+selectedBookCode,
				datatype : 'json',
				url : 'boardBookSelected',
				success : function(data){
					//통신 성공시 실행할 내용
					$("#book_img").attr('src',"resources/images/books/"+data.code+".jpg");
					$('#booktitle').text(data.name);
					$('#authorname').text(data.authorname);
					$('#cat').text(data.cat1);
					$('#publisher').text(data.publisher);
					$('#publishdate').text(data.publishyear+"년 "+data.publishmonth+"월 "+data.publishday+"일");
					//ajax로 조회한 책의 평점정보를 별점으로 표시, destroy는 클릭 도서 변경시 해당 도서의 별점으로 변경되게하기위해 사용됨 
					$('#uscore').barrating('destroy');
					var userscore = parseInt(data.averagescore);
					$('#uscore').barrating('show',{
						theme: 'fontawesome-stars',
						initialRating: userscore,
						showSelectedRating: true,
						readonly: true,
					});
				},
				error : function(xr,status,error){
					//통신 실패시 실행할 내용
					alert("ajax error");
				}
			});
		});
		//선택버튼 클릭시 해당 도서로 정보를 고정시키기위해 사용
		$('#bookselectbtn').on('click',function(){
			$('.boardBookSearch').removeClass('boardBookSearch-clicked')
			$('#booksearch').prop("readonly","true");
		});
		//선택 버튼 클릭후 독후감을 작성할 도서를 변경하고자할때 검색 초기단계로 돌아감
		$('#bookresetbtn').on('click',function(){
			$('#booksearch').removeAttr("readonly");
			$('#selectBookCode').val(999999999);
			$('#booksearch').val("");
			$('.review_book').hide();
		});
		$('#booksearch').on('keydown',function(){
			$('#selectBookCode').val(999999999);
		});
	});
</script>
</head>
<body>
<div class="container">
<form id="board_update_form" action="boardUpdate" method="post" enctype="multipart/form-data">
	<input type="hidden" id="bcode" name="code" value="${board.code}"/>
	<input type="hidden" id="isreview" name="isreview" value="${board.isreview}"/>
	<input type="hidden" id="userid" name="userid" value="${sessionid}"/>
	<input type="hidden" id="selectBookCode" name="bookcode" value="${board.bookcode}"/>
	<input type="hidden" id="boardname" name="boardname" value="${board.boardname}"/>
	<input type="hidden" id="boardscore" value="${board.score}"/>
	<input type="hidden" id="boardaveragescore" value="${board.averagescore}"/>
	<div class="row my-4">
		<h4 style="text-align: center !important; width: 100%">작성글 수정</h4>
	</div>
	<div class="row my-3">
		<div class="col-2">
			<c:choose>
				<c:when test="${board.boardname eq 'freeboard'}"><label class="form-control">자유 게시판</label></c:when>
				<c:when test="${board.boardname eq 'reviewboard'}"><label class="form-control">독후감</label></c:when>
			</c:choose>
		</div>
		<div class="col-10">
			<input class="form-control" name="title" placeholder="제목을 입력하세요" value="${board.title}">
		</div>
	</div>
	<div class="row my-3">
		<div class="col-12">
			<textarea type="text" class="form-control" rows="30" id="b_content" name="content" style="text-align: left">${board.content}</textarea>
		</div>
	</div>
	<div class="review_book">
		<table>
			<tr>
				<td class="review_book_item">
					<img class="book_img" src="" width="100" height="120" id="book_img">
				</td>
				<td class="book_info">
					<div class="title" id="booktitle">${board.bookname}</div>
					<div class="item">
						<strong class="th">저 &nbsp; 자</strong>
						<span class="line">|</span>
						<span class="info" id="authorname">${board.authorname}</span>
						<strong class="th">분 &nbsp; 류</strong>
						<span class="line">|</span>
						<span id="cat">${board.cat1}</span>
					</div>
					<div class="item">
						<strong class="th">출판사</strong>
						<span class="line">|</span>
						<span class="info" id="publisher">${board.publisher}</span>
						<strong class="th">출판일</strong>
						<span class="line">|</span>
						<span id="publishdate">${board.publishyear}년 ${board.publishmonth}월 ${board.publishday}일</span>
					</div>
					<div class="item">
						<strong class="th">내평점</strong>
						<span class="line">|</span>
						<span class="star" style="width: 400px;">
						<select id="score" name="score">
							<c:forEach var="i" begin="1" end="5">
								<option value="${i}">${i}</option>
							</c:forEach>
						</select>
						</span>
						<strong class="th">평 &nbsp; 점</strong>
						<span class="line">|</span>
						<span class="star">
						<select id="uscore">
							<c:forEach var="i" begin="1" end="5">
								<option value="${i}">${i}</option>
							</c:forEach>
						</select>
						</span>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div class="row my-3 review_book_search">
		<div class="input-group col-12">
			<input type="text" class="form-control" id="booksearch" name="booksearch" placeholder="도서명 검색" value="${board.bookname}">
			<div class="input-group-append">
				<button type="button" class="btn btn-outline-primary" id="booksearchbtn">검 색</button>
				<button type="button" class="btn btn-outline-primary" id="bookselectbtn">선 택</button>
				<button type="button" class="btn btn-outline-primary" id="bookresetbtn">취 소</button>
			</div>
		</div>
	</div>
	 <div class="form-group boardBookSearch">
			<label >검색</label>
			<select multiple class="form-control" id="search-select">
			</select>
		  </div>
	<div class="row my-3">
		<div class="col-2">
			<div class="form-check" id="checklabel">
				<label class="form-check-label">
					<input type="checkbox" class="form-check-input" id="ismanageronly" name="ismanageronly" value="${board.ismanageronly}"
					<c:if test="${board.ismanageronly==1}">checked="checked"</c:if>>관리자만 보기
				</label>
			</div>
		</div>
		<div class="col-3"></div>
		<div class="col-2">
			<a href="javascript:void(0)" type="button" class="btn pri-back btn-block" id="boardsave">저 장</a>
		</div>
		<div class="col-2">
			<a href="javascript:void(0)" type="button" class="btn pri-back btn-block" id="deletebtn">삭 제</a>
		</div>
		<div class="col-2">
			<a href="boardList" type="button" class="btn pri-back btn-block">취 소</a>
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