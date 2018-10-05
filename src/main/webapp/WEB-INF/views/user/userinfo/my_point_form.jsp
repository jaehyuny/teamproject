<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div style="margin-top: 50px"></div>
	<form style="width: 100%; margin: 0 auto;">
		<div style="margin-top: 50px"></div>
		<div class="container">
			<div class="row">
				<div class="col-sm-12 fth-col">
					<h4>${sessionname}
						님의 <big><big>P</big></big>oint
					</h4>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12 fth-col">
					<h5>현재 ${sessionname} 님의 Point는 ${user.point}원입니다.</h5>
				</div>
			</div>
			<div class="row" style="margin-top: 50px">
				<div class="col-sm-12 fth-col">
					<h5>포인트 내역</h5>
				</div>
			</div>
			<div class="row" id="row-coupon">
				<table id="table-id-point" class="display"
					style="text-align: center;">
					<thead>
						<tr>
							<th>거래일</th>
							<th>내용</th>
							<th>적립P</th>
							<th>사용P</th>
							<th>잔여P</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${points}" var="point">						
							<tr>								
								<td>${point.time}</td>
								<td>${point.bookname}</td>
								<td>${point.getpoint}point</td>
								<td>${point.usedpoint}point</td>
								<td>${point.stackpoint}point</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</form>
</body>
</html>