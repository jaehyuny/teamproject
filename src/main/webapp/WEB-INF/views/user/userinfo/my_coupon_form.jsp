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
						님의 <big><big>C</big></big>oupon
					</h4>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12 fth-col">
					<h5>일반 쿠폰</h5>
				</div>
			</div>
			<div class="row" id="row">
				<table id="table-id-coupon-normal" class="display"
					style="text-align: center;">
					<thead>
						<tr>
							<th>쿠폰번호</th>
							<th>쿠폰이름</th>
							<th>할인효과</th>
							<th>적용요건</th>
							<th>유효기간</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${normal}" var="normal">
							<tr>
								<td>${normal.code}</td>
								<td>${normal.name}</td>
								<td><c:if test="${normal.fixedsale!=0}">${normal.fixedsale}원 할인</c:if>
									<c:if test="${normal.fixedsale==0}">${normal.percentsale}% 할인(최대 ${normal.percentmaxsale}원 까지)</c:if>
								</td>
								<td>${normal.moneycondition}원 이상 구매시
								<c:if test="${normal.catcondition!=null}">(${normal.catcondition} 카테고리에 한함)</c:if>								
								</td>
								<td>${normal.getexfireday}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="row">
				<div class="col-sm-12 fth-col">
					<h5>배송 쿠폰</h5>
				</div>
			</div>
			<div class="row" id="row-coupon">
				<table id="table-id-coupon-delivery" class="display"
					style="text-align: center;">
					<thead>
						<tr>
							<th>쿠폰번호</th>
							<th>쿠폰이름</th>
							<th>할인효과</th>
							<th>적용요건</th>
							<th>유효기간</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${delivery}" var="delivery">
							<tr>
								<td>${delivery.code}</td>
								<td>${delivery.name}</td>
								<td>무료 배송</td>
								<td>${delivery.moneycondition}원 이상 구매시
								<c:if test="${delivery.catcondition!=null}">(${delivery.catcondition} 카테고리에 한함)</c:if>								
								</td>
								<td>${delivery.getexfireday}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</form>	
</body>
</html>