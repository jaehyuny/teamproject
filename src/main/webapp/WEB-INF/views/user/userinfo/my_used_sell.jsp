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
	<form style="width: 100%; margin: 0 auto;" action="myUsedBuyInput">
		<div style="margin-top: 50px"></div>
		<div class="container">
			<div class="row">
				<div class="col-sm-12 fth-col">
					<h4>${sessionname}
						님의 <big><big>U</big></big>sed Sell
					</h4>
				</div>
			</div>
			<div class="row" id="row">
				<table id="table-id-usedsell" class="display"
					style="text-align: center;">
					<thead>
						<tr>
							<th>등록일자</th>
							<th>책</th>
							<th>가격</th>
							<th>거래여부</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${usedsells}" var="usedsell">
							<tr>
								<td>${usedsell.time}</td>
								<td>${usedsell.bookname}</td>
								<td>${usedsell.price}</td>
								<c:if test="${usedsell.state=='판매중'}">
									<td>${usedsell.state}</td>
								</c:if>
								<c:if test="${usedsell.state=='거래중'}">
									<td>${usedsell.state}</td>
								</c:if>
								<c:if test="${usedsell.state=='거래완료'}">
									<td><a href="#" id="btn-used-sell">${usedsell.state}</a></td>
								</c:if>
							</tr>
							<tr class="noneclass">
								<td><div>거래일자</div>${usedsell.tradetime}</td>
								<td><div>평점</div> <select class="eval-score">
										<c:forEach begin="1" end="5" step="1" varStatus="status">
											<option value="${status.count}"
												<c:if test="${status.count==usedtrade.score}">selected</c:if>>${status.count}</option>
										</c:forEach>
								</select></td>
								<td colspan="2"><div>판매자평가</div>${usedsell.evaltext}</td>
								<td style="display: none;"></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</form>
</body>
</html>