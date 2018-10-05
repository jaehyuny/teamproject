<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니</title>
</head>
<body>
<!-- body container -->
<div class="container basket_container">
<h1>장바구니</h1>
<form method="POST" action="orderMain" class="basket_form">
<section>
	<table class="table table_order">
		<colgroup>
			<col style="width:62%;">
			<col style="width:15%;">
			<col style="width:8%;">
			<col style="width:15%;">
		</colgroup>
		<thead>
			<tr>
				<th><label class="checkbox_label">
							<input type="checkbox" class="order_check_all" checked="checked">
							<span class="checkmark"></span>
						</label>상품정보</th>
				<th>가격</th>
				<th>개수</th>
				<th>합계</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="basket" items="${basketList}">
				<tr class="basket_item">
					<td>
						<label class="checkbox_label">
							<input type="checkbox" class="order_check" checked="checked">
							<input type="hidden" name="checkedNum" class="checkedNum">
							<input type="hidden" name="bookcode" class="basket_bookcode" value="${basket.bookcode}">
							<span class="checkmark"></span>
						</label>
						<img src="resources/images/books/${basket.bookcode}.jpg">
						<p><a href="bookDetailPage?bookcode=${basket.bookcode}">${basket.bookname}</a></p>
					</td>
					<td><span class="real_price numeric" data-numeric="${basket.bookprice}">${basket.bookprice}</span>원</td>
					<td><input type="text" name="amount" value="${basket.amount}" class="form-control order_amount" data-parsley-type="digits"></td>
					<td style="position:relative;">
						<span class="total_price numeric" data-numeric="${basket.amount * basket.bookprice}">${basket.amount * basket.bookprice}</span>원
						<div class="delete_basket"><i class="fas fa-minus"></i></div>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</section>
<section>
	<table class="table table_total">
		<colgroup>
			<col style="width:25%;">
			<col style="width:25%;">
			<col style="width:25%;">
			<col style="width:25%;">
		</colgroup>
		<thead>
			<tr>
				<th>상품금액</th>
				<th>배송비</th>
				<th>결제 예정금액</th>
				<th>적립예정 포인트</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><span class="sum_total numeric" data-numreric></span>원<div class="cal_icon">+</div></td>
				<td><span class="delivery_price numeric" data-numeric="2000">2000</span>원<div class="cal_icon">=</div></td>
				<td><span class="last_price numeric" data-numeric></span>원</td>
				<td class="expected_point">
					<ul>
						<li>기본적립<span class="savePoint numeric" data-point="${sessionGrade.amount}" data-numeric></span></li>
						<li>추가적립<span>0P</span></li>
					</ul>
				</td>
			</tr>
		</tbody>
	</table>

</section>
<section style="text-align:center;">
	<button type="button" class="btn btn_order">선택 상품 주문하기</button>
</section>

</form>

</div>
<!-- body container end -->

<script>


</script>


</body>
</html>