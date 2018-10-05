<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="http://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
<link rel="stylesheet" href="resources/themes/fontawesome-stars.css">
<script src="resources/js/jquery.barrating.min.js"></script>
<style>
.noneclass {
	display: none;
}
</style>
</head>
<body>
	<script type="text/javascript">
		$(document).ready(function() {
			$('.score').barrating('show', {
				theme : 'fontawesome-stars',
				showSelectedRating : true,
				allowEmpty : true,
				emptyValue : '0',
			});
			$('.eval-score').barrating('show', {
				theme : 'fontawesome-stars',
				showSelectedRating : true,
				allowEmpty : true,
				emptyValue : '0',
				readonly : true
			});
		});
	</script>
	<div style="margin-top: 50px"></div>
	<form style="width: 100%; margin: 0 auto;">
		<div style="margin-top: 50px"></div>
		<div class="container">
			<div class="row">
				<div class="col-sm-12 fth-col">
					<h4>주문 상세 내역</h4>
				</div>
			</div>
			<div class="row" id="row">
				<table class="display table_id_orderdetail"
					style="text-align: center;">
					<thead>
						<tr>
							<th>주문일시</th>
							<th>책 이름</th>
							<th>받는 사람</th>
							<th>책 가격</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>${order.time}</td>
							<td><a href="#" id="btn-booknames">${order.bookname}</a></td>
							<td><a href="#" id="btn-receiver">${order.receivername}</a></td>
							<td>${order.realprice}원</td>
						</tr>
					</tbody>
				</table>
				<div class="alert alert-light noneclass" role="alert"
					id="booknames-form">
					<h6 class="alert-heading">
						<small>구매한 책</small>
					</h6>
					<hr>
					<p>
						<c:forEach items="${booknames}" var="booknames">
						<small>${booknames.bookname} ${booknames.amount}권<br></small>
						</c:forEach>
					</p>
				</div>
				<div class="alert alert-light noneclass" role="alert"
					id="receiver-form">
					<h6 class="alert-heading">
						<small>받는 사람 : ${order.receivername}</small>
					</h6>
					<hr>
					<p>						
						<small>전화 번호 : ${order.receivertell}</small><br>						
						<small>핸드폰 번호 : ${order.receiverphone}</small><br>
						<small>우편 번호 : ${order.postno}</small><br>
						<small>주소 : ${order.address1}</small><br>
						<small>주소 : ${order.address2}</small>
					</p>
				</div>
				<table class="display table_id_orderdetail"
					style="text-align: center; margin-top: 50px">
					<thead>
						<tr>
							<th>포인트 사용</th>
							<th>배송비</th>
							<th>지출 금액</th>
							<th>포인트 적립</th>
							<th>주문현황</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>${order.usedpoint}point</td>
							<td>${order.shippingprice}원</td>
							<td>${order.pay}원</td>
							<td>${order.getpoint}point</td>
							<td>${order.state}<c:if
									test="${order.state=='입금대기'||'입금완료'}">
									<button type="button" data-id="${sessionid}" data-code="${order.code}" class="btn btn-danger btn_orderCancel">주문취소</button>
								</c:if>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</form>
	<!-- Modal -->
	<div class="modal fade" role="dialog">
		<div class="modal-dialog">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Modal Header</h4>
				</div>
				<div class="modal-body">
					<p>Some text in the modal.</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn modal-positive btn-danger"
						data-dismiss="modal"></button>
					<button type="button" class="btn modal-negative btn-secondary"
						data-dismiss="modal"></button>

				</div>
			</div>
		</div>
	</div>
	
</body>
</html>