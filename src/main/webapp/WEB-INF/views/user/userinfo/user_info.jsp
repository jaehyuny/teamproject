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
	<div class="alert alert-success" role="alert">
		<div class="container">
			<div class="row">
				<div class="col-sm-4">
					<div class="row">
						<div class="col-sm-12" style="text-align: center;">
							<h4>${sessionname}님
								<a href="#" id="btn-user-grade"> <small> <c:if
											test="${user.grade==1}">[브론즈]</c:if> <c:if
											test="${user.grade==2}">[실버]</c:if> <c:if
											test="${user.grade==3}">[골드]</c:if> <c:if
											test="${user.grade==4}">[플레티넘]</c:if> <c:if
											test="${user.grade==5}">[다이아몬드]</c:if>
								</small></a>
							</h4>
							<div style="display: none;" id="user-grade">
								<h6>총 구입액 : ${ordersum.totalsum}원</h6>
								<h6>3개월간 구입액 : ${ordersum.threemonthsum}원</h6>
								<c:if test="${user.grade==1}">
									<h6>포인트 적립 : 1%</h6>																		
								</c:if>
								<c:if test="${user.grade==2}">
									<h6>포인트 적립 : 2%</h6>
									<h6>매월 5% 할인쿠폰 1장</h6>									
								</c:if>
								<c:if test="${user.grade==3}">
									<h6>포인트 적립 : 3%</h6>
									<h6>매월 5% 할인쿠폰 3장</h6>
								</c:if>
								<c:if test="${user.grade==4}">
									<h6>포인트 적립 : 4%</h6>
									<h6>매월 10% 할인쿠폰 3장</h6>
								</c:if>
								<c:if test="${user.grade==5}">
									<h6>포인트 적립 : 5%</h6>
									<h6>매월 10% 할인쿠폰 10장</h6>
								</c:if>																
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12 pri-col" style="text-align: center;">
							<button type="button" class="btn sec-back" id="btn-grade-form"
								style="font-size: 12px">등급혜택</button>
							<button type="button" class="btn fth-back" id="btn-next-grade"
								style="font-size: 12px" href="#">다음 등급</button>
						</div>
					</div>
				</div>
				<div class="col-sm-2">
					<div class="row">
						<div class="col-sm-12"
							style="text-align: center; margin-top: 10px">
							<h6>
								최근 주문<small>(3개월)</small>
							</h6>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12" style="text-align: center;">
							<a href="myOrder">${ordercount}개</a>
						</div>
					</div>
				</div>
				<div class="col-sm-2">
					<div class="row">
						<div class="col-sm-12"
							style="text-align: center; margin-top: 10px">
							<h6>쿠폰</h6>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12" style="text-align: center;">
							<a href="myCoupon">${owncoupon}개</a>
						</div>
					</div>
				</div>
				<div class="col-sm-2">
					<div class="row">
						<div class="col-sm-12"
							style="text-align: center; margin-top: 10px">
							<h6>포인트</h6>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12" style="text-align: center;">
							<a href="myPoint">${user.point}point</a>
						</div>
					</div>
				</div>
				<div class="col-sm-2">
					<div class="row">
						<div class="col-sm-12"
							style="text-align: center; margin-top: 10px">
							<h6>독후감</h6>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12" style="text-align: center;">
							<a href="myReview">${countreview}개</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="alert alert-light" role="alert" style="display: none;"
		id="grade-form">
		<h6 class="alert-heading">
			<small>등급 혜택</small>
		</h6>
		<hr>
		<p>
			<small>nullpointers 서점의 grade는 5개로 브론즈, 실버, 골드, 플레티넘, 다이아입니다.
				각 등급별로 결제금액의 1, 2, 3, 4, 5% 만큼 포인트를 적립할 수 있습니다. 또한 매월 실버는 1장(5% 할인), 골드는
				3장(5% 할인), 플레티넘은 3장(10% 할인), 다이아는 10장(10% 할인)의 할인쿠폰을 얻습니다.</small>
		</p>
	</div>
	<div class="alert alert-light" role="alert" style="display: none;"
		id="next-grade">
		<h6 class="alert-heading">
			<small>다음 등급</small>
		</h6>
		<hr>
		<p>
			<small>nullpointers 서점의 grade는 결제금액에 따라서 올라갑니다. 총결제금액 기준으로
				10만원, 50만원, 100만원, 500만원 이상일 경우 승급되며, 3개월간 결제금액이 1만원, 5만원, 10만원,
				50만원 미만일 경우에 1단계씩 강등됩니다.</small>
		</p>
	</div>
	<div style="margin-top: 50px"></div>
	<div class="container">
		<div class="row">
			<div class="col-sm-12 fth-col">
				<h4>${sessionname}님께서
					최근 주문한 상품<small>(3개월)</small>
				</h4>
			</div>
		</div>
		<div class="row" id="row">
			<table id="table_id" class="display" style="text-align: center;">
				<thead>
					<tr>
						<th>주문일</th>
						<th>상품코드</th>
						<th>상품명</th>
						<th>결제금액</th>
						<th>배송상태</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${buyrequests}" var="buyrequest">
						<tr>
							<td>${buyrequest.time}</td>
							<td>${buyrequest.code}</td>
							<td><a href="myOrderDetail?code=${buyrequest.code}">${buyrequest.bookname}</a></td>
							<td>${buyrequest.pay}원</td>
							<td>${buyrequest.state}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>