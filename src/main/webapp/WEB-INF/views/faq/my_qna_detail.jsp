<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
	
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$('.qna_answer').hide();
		$('.answer_btn_group').hide();
		$('#answerbtn').on('click',function(){
			if($('#bref').val()==1){
				alert("답변이 완료된 게시물입니다");
			}else{
				$('.qna_answer').show();
				$('.qna_btn_group').hide();
				$('.answer_btn_group').show();
			}
		});
		$('#answer_cancle').on('click',function(){
			$('.qna_answer').hide();
			$('.qna_btn_group').show();
			$('.answer_btn_group').hide();
		});
		$('#answer_save').on('click',function(){
			$('#qnaDetail').submit();
		});
	});
</script>
</head>
<body>
<div class="container">
<form id="qnaDetail" action="answerQna" method="post" enctype="multipart/form-data">
	<input type="hidden" id="bcode" name="code" value="${board.code}"/>
	<input type="hidden" id="bname" name="boardname" value="${board.boardname}"/>
	<input type="hidden" id="bref" value="${board.ref}"/>
	<div style="text-align:center; margin-top:30px; margin-bottom:30px;">
		<h3>내 문의 내역</h3>
	</div>
	<div>
		<table class="table">
			<colgroup>
				<col style="width:20%;">
				<col style="width:30%;">
				<col style="width:20%;">
				<col style="width:30%;">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">등록일</th>
					<td><span>${board.time}</span></td>
					<th scope="row">처리상태</th>
					<td><span>${board.qnastate}</span></td>
				</tr>
				<tr>
					<th scope="row">제목</th>
					<td colspan="3"><span>${board.title}</span></td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td colspan="3"><div><span style="white-space:pre-wrap">${board.content}</span></div></td>
				</tr>
			</tbody>
		</table>
	</div>
	<c:if test="${board.attachfile != null}">
	<div class="row my-3">
		<div class="col-2">
			<label style="border:none; text-align:center">첨부파일</label>
		</div>
		<div class="col-10">
			<a href="boardDownload?b_attach=${board.filename}"><input type="text" class="form-control" readonly="readonly" value="${board.filename}"></a>
		</div>
	</div>
	</c:if>
	<div class="qna_answer">
		<div class="col-12">
			<textarea class="form-control" id="qna_answer_area" rows="10" style="width:100%" name="content">${board.content}
			
[답변]

</textarea>
		</div>
	</div>
	<div class="row my-3 qna_btn_group">
		<c:choose>
			<c:when test="${sessionid eq 'admin@nullpointers.com'}">
				<div class="col-4"></div>
				<div class="col-2">
					<a href="javascript:void()" type="button" id="answerbtn" class="btn pri-back btn-block">답변하기</a>
				</div>
				<div class="col-2">
					<a href="javascript:void()" type="button" onClick="location.href='myQuestion'" class="btn pri-back btn-block">문의목록</a>
				</div>
				<div class="col-4"></div>
			</c:when>
			<c:otherwise>
				<div class="col-5"></div>
				<div class="col-2">
					<a href="javascript:void()" onClick="location.href='myQuestion'" type="button" class="btn pri-back btn-block">문의목록</a>
				</div>
				<div class="col-5"></div>
			</c:otherwise>
		</c:choose>
	</div>
	<div class="row my-3 answer_btn_group">
		<div class="col-4"></div>
		<div class="col-2">
			<a href="javascript:void()" type="button" id="answer_save" class="btn pri-back btn-block">답변등록</a>
		</div>
		<div class="col-2">
			<a href="javascript:void()" type="button" id="answer_cancle" class="btn pri-back btn-block">답변취소</a>
		</div>
		<div class="col-4"></div>
	</div>
</form>
</div>
</body>
</html>