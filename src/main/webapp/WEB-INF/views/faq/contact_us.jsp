<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
	.select_area{margin:7px 0 20px; padding:16px 19px; border:1px solid #e0e0e0; line-height:24px; height:90px;}
	.select_area:after{content:""; clear:both; display:block;}
	.select_area .area01{float:left; width:280px;}
	.select_area .area02{float:left; width:280px;}
	.select_area .area03{float:left; width:280px;}
	label{vertical-align:middle;}
	ul{list-style:none; display:block;}
	li{display:list-item; text-align:-webkit-match-parent;}
	input{font-family:dotum,돋움; font-size:12px; line-height:18px;}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$('#qna_save').on('click',function(){
			//문의 분류, 문의 제목, 문의 내용 작성 체크
			if(!$('input[name="boardname"]:checked').val()){
				alert("문의 분류를 선택해주세요");
			}else if($('#qna_title').val()==""){
				alert("문의하실 제목을 입력하세요");
			}else if($('#qna_content').val()==""){
				alert("문의하실 내용을 입력하세요");
			}else{
				$('#qna_insert_form').submit();
			}
		});
		$('#attachfile').hide();
		$('.radio').on('change',function(){
			var radioval = $('input[name="boardname"]:checked').val();
			//문의사항이 신고일경우에만 파일 첨부칸 보여짐
			if(radioval=='qna_report'){
				$('#attachfile').show();
			}else{
				$('#attachfile').hide();
			}
		});
		//경로에서 파일명만 추출
		$('input:file[name="qnaimage"]').change(function(){
			var file = $(this).val();
			var filename = file.split('\\').pop().toLowerCase();
			checkFileName(filename);
		});
		//파일명에서 확장자만 추출
		function checkFileName(filename){
			var ext = filename.split('.').pop().toLowerCase();
			//확장자 체크
			if($.inArray(ext,['jpg','jpge','png','gif','bmp'])==-1){
				alert("이미지 파일만 등록 가능합니다");
				//확장자가 이미지가 아닐경우 파일업로드창 초기화
				if(/(MSIE|Trident)/.test(navigator.userAgent)){
					//인터넷 익스플로러
					$('#fileupload').replaceWith($('#fileupload').clone(true));
				}else{
					//IE제외 나머지 브라우저
					$("#fileupload").val("");
				}
			}
		}
	});
</script>
</head>
<body>
<div class="container">
	<form id="qna_insert_form" action="qnaInsert" method="post" enctype="multipart/form-data">
		<input type="hidden" name="userid" value="${sessionid}">
		<div style="text-align:center; margin-top:30px; margin-bottom:30px;">
			<h3>1:1 문의하기</h3>
		</div>
		<div class="select_area">
			<ul class="area01">
				<li>
					<input type="radio" class="radio" id="radio01" name="boardname" value="qna_user">
					<label for="radio01">회원정보,서비스</label>
				</li>
				<li>
					<input type="radio" class="radio" id="radio04" name="boardname" value="qna_refund">
					<label for="radio04">반품,교환,환불</label>
				</li>
			</ul>
			<ul class="area02">
				<li>
					<input type="radio" class="radio" id="radio02" name="boardname" value="qna_book">
					<label for="radio02">도서정보</label>
				</li>
				<li>
					<input type="radio" class="radio" id="radio05" name="boardname" value="qna_report">
					<label for="radio05">상품불량,불량이용자 신고</label>
				</li>
			</ul>
			<ul class="area03">
				<li>
					<input type="radio" class="radio" id="radio03" name="boardname" value="qna_order">
					<label for="radio03">주문,결제</label>
				</li>
				<li>
					<input type="radio" class="radio" id="radio06" name="boardname" value="qna_nomal">
					<label for="radio06">일반,기타,건의</label>
				</li>
			</ul>
		</div>
		<div class="row my-3">
			<div class="col-12">
				<input type="text" class="form-control" id="qna_title" name="title" placeholder="문의 제목">
			</div>
		</div>
		<div class="row my-3">
			<div class="col-12">
				<textarea class="form-control" rows="10" style="width:100%;" id="qna_content" name="content" placeholder="문의할 내용을 입력하세요"></textarea>
			</div>
		</div>
		<div class="row my-3" id="attachfile">
			<div class="col-2">
				<label class="form-control" style="border:none;">첨부 파일</label>
			</div>
			<div class="col-10">
				<input type="file" accept=".jpg,.jpge,.png,.gif,.bmp" id="fileupload" name="qnaimage" class="form-control" style="font-size:12px">
			</div>
		</div>
		<div class="row my-3">
			<div class="col-6"></div>
			<div class="col-3">
				<a href="javascript:void()" type="button" class="btn pri-back btn-block" id="qna_save">문의하기</a>
			</div>
			<div class="col-3">
				<a href="javascript:void()" type="button" class="btn pri-back btn-block" onclick="location.href='myQuestion'">목록으로</a>
			</div>
		</div>
	</form>
</div>
</body>
</html>