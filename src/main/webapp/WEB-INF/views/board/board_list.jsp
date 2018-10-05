<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>자유 게시판</title>
<style type="text/css">
	.modal-body{text-align:center; font-size:20px}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var sessionid = $('#sid').val();
		$('#bwrite').on('click',function(){
			if(sessionid==""){
				$('#bModal').show();
				$('.modal-header').hide();
				$('#bModalbtn').on('click',function(){
					$(location).attr('href',"loginForm");
				});
				$('#bModalcancle').on('click',function(){
					$('#bModal').hide()
				});
			}else{
				$(location).attr('href',"boardInsertForm");
			}
		});
	});
	function fn_paging(page){
		$(location).attr('href',"boardList?curPage="+page);
	}
</script>
</head>
<body>


<div class="container">
	<form action="boardList" method="get">
		<input type="hidden" id="sid" value="${sessionid}">
		<table class="table table-hover">
			<colgroup>
				<col style="width: 7%;">
				<col style="width: 35%;">
				<col style="width: 20%;">
				<col style="width: 10%;">
				<col style="width: 10%;">
				<col style="width: 9%;">
				<col style="width: 9%;">
			</colgroup>
			<thead>
				<tr>
					<th style="text-align: center">번호</th>
					<th style="text-align: center">제목</th>
					<th style="text-align: center">작성자</th>
					<th style="text-align: center">작성일</th>
					<th style="text-align: center">조회수</th>
					<th style="text-align: center">좋아요</th>
					<th style="text-align: center">싫어요</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="board" items="${boards}">
				<tr>
					<td style="text-align: center">${board.code}</td>
					<c:choose>
						<c:when test="${board.ismanageronly==1}"><td style="text-align: left"><i class="fas fa-lock"></i><a href="boardDetailForm?code=${board.code}&boardname=${board.boardname}"> ${board.title}</a></td></c:when>
						<c:otherwise><td style="text-align: left"><a href="boardDetailForm?code=${board.code}&boardname=${board.boardname}">${board.title}</a></td></c:otherwise>
					</c:choose>
					<td style="text-align: center">${board.username}</td>
					<td style="text-align: center; font-size: 10px">${board.time}</td>
					<td style="text-align: center">${board.hit}</td>
					<td style="text-align: center">${board.likecount}</td>
					<td style="text-align: center">${board.dislikecount}</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="row my-3">
			<div class="col-1"></div>
			<div class="col-10">
				<c:if test="${pagination.curRange ne 1}"><a href="#" onClick="fn_paging(1)">[처음]</a></c:if>
		 		<c:if test="${pagination.curPage ne 1}"><a href="#" onClick="fn_paging('${pagination.prevPage}')">[이전]</a></c:if>
			 	<c:forEach var="pageNum" begin="${pagination.startPage}" end="${pagination.endPage}">
			 		<c:choose>
			 			<c:when test="${pageNum eq pagination.curPage}">
			 				<span style="font-weight: bold;"><a href="#" onClick="fn_paging('${pageNum}')">${pageNum}</a></span>
			 			</c:when>
			 			<c:otherwise>
			 				<a href="#" onClick="fn_paging('${pageNum}')">${pageNum}</a>
			 			</c:otherwise>
			 		</c:choose>
			 	</c:forEach>
			 	<c:if test="${pagination.curPage ne pagination.pageCount && pagination.pageCount > 0}">
			 		<a href="#" onClick="fn_paging('${pagination.nextPage}')">[다음]</a>
			 	</c:if>
			 	<c:if test="${pagination.curRange ne pagination.rangeCount && pagination.rangeCount > 0}">
			 		<a href="#" onClick="fn_paging('${pagination.pageCount}')">[끝]</a>
			 	</c:if>
			</div>
			<div class="col-1"></div>
		</div>
		<div class="row my-3">
			<div class="col-1"></div>
			<div class="col-2">
				<select class="form-control">
					<option value="all">전체</option>
					<option value="btitle">제목</option>
					<option value="buserid">작성자</option>
				</select>
			</div>
			<div class="col-2">
				<input type="text" class="form-control" id="find" name="find" value="${find}">
			</div>
			<div class="col-2">
				<button type="submit" class="btn pri-back btn-block">검색</button>
			</div>
			<div class="col-2">
				<a href="javascript:void(0);" type="button" class="btn pri-back btn-block" id="bwrite">글쓰기</a>
			</div>
			<div class="col-2">
			<a href="/project" type="button" class="btn pri-back btn-block">홈으로</a>
			</div>
			<div class="col-1"></div>
		</div>
	</form>
	<!-- The Modal -->
	<div class="modal" id="bModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title"></h4>
					<button type="button" class="close" data-dismiss="modal"></button>
				</div>
				<!-- Modal body -->
				<div class="modal-body">
					<p>로그인이 필요한 서비스입니다!</p>
					<p>로그인 하시겠습니까?</p>
				</div>
				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-success" data-dismiss="modal" id="bModalbtn">로그인</button>
					<button type="button" class="btn btn-danger" data-dismiss="modal" id="bModalcancle">취소</button>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>