<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>1:1문의</title>
<style>
a{color:#666; text-decoration: none;}
.table th{text-align: center;}
.table td{text-align: center;}
.table:after{content:""; display:block; clear:both;}
.qna_list .qna_header{border-top:1px solid #000; padding:15px 0;}
.qna_list .qna_header span{display:inline-block; text-align:center;}
.qna_list .num{width:12%;}
.qna_list .title{width:74%;}
.qna_list .result{width:12%;}
.qna_list .qna_body{border-top:1px solid #ccc;}
.qna_list .article .question{border-bottom:1px solid #ccc;}
.qna_list .article .question .num{display:inline-block; text-align:center; padding:15px 0; width:12%;}
.qna_list .article .question .title{display:inline-block; text-align:left; padding:15px 0 15px 2%; width:74%;}
.qna_list .article .question .result{display:inline-block; text-align:center; padding:15px 0; width:12%;}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$('#myQna').DataTable({
	    	responsive: true,
	    	searching: false,  
	    	ordering: false,
	    	"pagingType": "simple",
	    	"pageLength": 10,
	    	"info": false,
	    	lengthChange : false,    	    	
	    	"columns": [
	    	    { "width": "10%" },
	    	    { "width": "50%" },    	    
	    	    { "width": "20%" },
	    	    { "width": "20%" },
	    	  ],
	    });       
	});
</script>
</head>
<body>
<div class="container">
<form>
	<div style="text-align:center!important; width:100%; margin-top:30px; margin-bottom:30px;">
		<h3>내 문의 내역</h3>
	</div>
	<table class="table" id="myQna">
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>날짜</th>
				<th>처리 여부</th>
			</tr>
		</thead>
		<tbody>
		<c:choose>
			<c:when test="${sessionid ne 'admin@nullpointers.com'}">
			<c:forEach var="qna" items="${myqna}">
			<tr>
				<td>${qna.code}</td>
				<td style="text-align:left;">
				<c:choose>
					<c:when test="${qna.boardname eq 'qna_user'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 회 원 ] ${qna.title}</a>
					</c:when>
					<c:when test="${qna.boardname eq 'qna_refund'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 반품,환불 ] ${qna.title}</a>
					</c:when>
					<c:when test="${qna.boardname eq 'qna_book'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 도 서 ] ${qna.title}</a>
					</c:when>
					<c:when test="${qna.boardname eq 'qna_report'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 신 고 ] ${qna.title}</a>
					</c:when>
					<c:when test="${qna.boardname eq 'qna_order'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 주문 ] ${qna.title}</a>
					</c:when>
					<c:when test="${qna.boardname eq 'qna_nomal'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 일반 ] ${qna.title}</a>
					</c:when>
				</c:choose>
				</td>
				<td style="font-size:12px;">${qna.time}</td>
				<td>
					<c:choose>
						<c:when test="${qna.ref == 0}">답변대기</c:when>
						<c:when test="${qna.ref == 1}">답변완료</c:when>
					</c:choose>
				</td>
			</tr>
			</c:forEach>
			</c:when>
			<c:when test="${sessionid eq 'admin@nullpointers.com'}">
			<c:forEach var="qna" items="${allqna}">
			<tr>
				<td>${qna.code}</td>
				<td style="text-align:left;">
				<c:choose>
					<c:when test="${qna.boardname eq 'qna_user'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 회 원 ] ${qna.title}</a>
					</c:when>
					<c:when test="${qna.boardname eq 'qna_refund'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 반품,환불 ] ${qna.title}</a>
					</c:when>
					<c:when test="${qna.boardname eq 'qna_book'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 도 서 ] ${qna.title}</a>
					</c:when>
					<c:when test="${qna.boardname eq 'qna_report'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 신 고 ] ${qna.title}</a>
					</c:when>
					<c:when test="${qna.boardname eq 'qna_order'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 주문 ] ${qna.title}</a>
					</c:when>
					<c:when test="${qna.boardname eq 'qna_nomal'}">
						<a href="javascript:void()" onClick="location.href='myQnaDetail?code='+'${qna.code}'+'&boardname='+'${qna.boardname}'">[ 일반 ] ${qna.title}</a>
					</c:when>
				</c:choose>
				</td>
				<td style="font-size:12px;">${qna.time}</td>
				<td>
					<c:choose>
						<c:when test="${qna.ref == 0}">답변대기</c:when>
						<c:when test="${qna.ref == 1}">답변완료</c:when>
					</c:choose>
				</td>
			</tr>
			</c:forEach>
			</c:when>
		</c:choose>
		</tbody>
	</table>
	<c:if test="${sessionid ne 'admin@nullpointers.com'}">
	<div class="row">
		<div class="col-10"></div>
		<div class="col-2">
			<a href="javascript:void(0)" type="button" class="btn pri-back" onclick="location.href='contactUs'">문의하기</a>
		</div>
	</div>
	</c:if>
</form>
</div>
</body>
</html>