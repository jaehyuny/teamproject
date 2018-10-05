<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>쿠폰처리</title>
</head>
<body>
<!-- body container -->
<div class="container basket_container">

<table class="table">
<caption>쿠폰</caption>
<thead>
	<tr>
		<th>쿠폰 코드</th>
		<th>이름</th>
		<th>고정할인</th>
		<th>퍼센트할인</th>
		<th>퍼센트할인 최대치</th>
		<th>적용최소가격</th>
		<th>카테고리제한</th>
		<th>이미지주소</th>
		<th>무료배송여부</th>
		<th>할인기한</th>
	</tr>
</thead>
<tbody>
	<c:forEach items="${couponList}" var="coupon">
		<tr>
			<td>${coupon.code}</td>
			<td>${coupon.name}</td>
			<td>${coupon.fixedsale}</td>
			<td>${coupon.percentsale}</td>
			<td>${coupon.percentmaxsale}</td>
			<td>${coupon.moneycondition}</td>
			<td>${coupon.catcondition}</td>
			<td>${coupon.imglink}</td>
			<td>${coupon.isfreeshiping}</td>
			<td>${coupon.exfireday}</td>
		</tr>
	</c:forEach>
</tbody>
</table>

<table class="table" style="margin-top:50px;">
<caption>겟쿠폰</caption>
<thead>
	<tr>
		<th>소유자 ID</th>
		<th>쿠폰 코드</th>
		<th>쿠폰 마감일</th>
		<th>소유 코드</th>
		<th>사용상태</th>
	</tr>
</thead>
<tbody>
	<c:forEach items="${getcouponList}" var="getcoupon">
		<tr>
			<td>${getcoupon.id}</td>
			<td>${getcoupon.couponcode}</td>
			<td>${getcoupon.exfireday}</td>
			<td>${getcoupon.code}</td>
			<td>${getcoupon.isusing}</td>
		</tr>
	</c:forEach>
</tbody>
</table>



<h1>쿠폰처리</h1>
<form method="POST" action="addCoupon">
<h3>CouponTable</h3>
<label>쿠폰코드(숫자)</label><input type="text" name="code"><br>
<label>쿠폰이름(문자)</label><input type="text" name="name"><br>
<label>고정할인(숫자)</label><input type="text" name="fixedsale"><br>
<label>퍼센트할인(숫자)</label><input type="text" name="percentsale"><br>
<label>퍼센트할인 최대치(숫자)</label><input type="text" name="percentmaxsale"><br>
<label>적용최소가격(숫자)</label><input type="text" name="moneycondition"><br>
<label>카테고리제한(문자)</label><input type="text" name="catcondition"><br>
<label>이미지주소(문자)</label><input type="text" name="imglink"><br>
<label>무료배송여부(숫자)</label><input type="text" name="isfreeshiping"><br>
<label>할인기한(숫자)</label><input type="text" name="exfireday"><br>

<button type="submit" class="btn">전송</button>

</form>

<h1>겟쿠폰처리</h1>
<form method="POST" action="addGetCoupon">
<h3>GetCouponTable</h3>
<label>ID</label><input type="text" name="id"><br>
<label>CouponCode</label><input type="text" name="couponcode"><br>
<label>쿠폰소유코드</label><input type="text" name="code"><br>
<label>사용여부</label><input type="text" name="isusing">

<button type="submit" class="btn">전송</button>

</form>

</div>
<!-- body container end -->

<script>


</script>


</body>
</html>