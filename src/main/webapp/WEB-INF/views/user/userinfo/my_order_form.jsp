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
					<h4>${sessionname}
						님의 <big><big>O</big></big>rder
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