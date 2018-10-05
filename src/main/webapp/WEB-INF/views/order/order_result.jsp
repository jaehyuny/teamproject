<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 완료</title>
</head>
<body>
<!-- body container -->
<div class="container container_order_result">
<h1>주문 완료</h1>
	<table class="table table_order_result">
		<caption>주문 정보</caption>
		<colgroup>
			<col style="width:25%">
			<col style="width:75%">
		</colgroup>
		<tr>
			<th rowspan="${fn:length(products)+1}">주문한 상품</th>
		</tr>
		<c:forEach items="${products}" var="product">
			<tr>
				<td><i class="italic_bookname">${product.bookname}</i> <i class="italic_amount">x${product.amount}</i> <span class="numeric" data-numeric="${product.finalprice}">${product.finalprice}</span>원</td>
			</tr>
		</c:forEach>
		<tr>
			<th>총 구매 가격</th>
			<td><span class="numeric" data-numeric="${buyrequest.finalprice}">${buyrequest.finalprice}</span>원</td>
		</tr>
		<tr>
			<th>배송비</th>
			<td><span class="numeric" data-numeric="${buyrequest.shippingprice}"></span>원</td>
		</tr>
		<tr>
			<th rowspan="${fn:length(couponList)+1}">사용한 쿠폰</th>
			<c:if test="${fn:length(couponList) == 0}">
				<td></td>
			</c:if>
		</tr>
		<c:forEach items="${couponList}" var="coupon">
			<tr>
				<td>${coupon.name}</td>
			</tr>
		</c:forEach>
		<tr>
			<th>사용한 포인트</th>
			<td><span class="numeric" data-numeric="${buyrequest.usedpoint}"></span>P</td>
		</tr>
		<tr>
			<th>적립한 포인트</th>
			<td><span class="numeric" data-numeric="${buyrequest.getpoint}"></span>P</td>
		</tr>
	</table>
	
	<table class="table table_order_result">
		<caption>받는 사람</caption>
		<colgroup>
			<col style="width:25%">
			<col style="width:75%">
		</colgroup>
		<tr>
			<th>받으시는 분</th>
			<td>${buyrequest.receivername }</td>
		</tr>
		<tr>
			<th>휴대폰 번호</th>
			<td>${buyrequest.receiverphone}</td>
		</tr>
		<tr>
			<th>전화 번호</th>
			<td>${buyrequest.receivertell}</td>
		</tr>
		<tr>
			<th>우편번호</th>
			<td>${buyrequest.postno}</td>
		</tr>
		<tr>
			<th>주소</th>
			<td>${buyrequest.address1}</td>
		</tr>
		<tr>
			<th>상세주소</th>
			<td>${buyrequest.address2}</td>
		</tr>
	</table>

<a href="mainPage" class="btn btn_home">홈으로</a>


</div>
</body>
</html>