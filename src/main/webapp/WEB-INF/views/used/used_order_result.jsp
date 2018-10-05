<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>중고 주문 완료</title>
</head>
<body>
<!-- body container -->
<div class="container">
<h1>주문 결과</h1>
축하드립니다! 당신은 호갱이 되셨습니다~~
<table class="table">
	<tbody>
		<tr>
			<td>기존 소지 포인트</td>
			<td>${beforepoint }</td>
		</tr>
		<tr>
			<td>거래후 차감 포인트</td>
			<td>${totalusedpoint }</td>
		</tr>
			<tr>
			<td>잔여 포인트</td>
			<td>${afterpoint }</td>
		</tr>
	</tbody>
</table>
</div>
</body>
</html>