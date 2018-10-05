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
						님의 <big><big>U</big></big>sed Buy
					</h4>
				</div>
			</div>
			<div class="row" id="row">
				<table id="table-id-usedbuy" class="display"
					style="text-align: center;">
					<thead>
						<tr>
							<th>구입일자</th>
							<th>판매자</th>
							<th>책</th>
							<th>가격</th>
							<th>거래상태</th>
							<c:if test="${usedtrade.state!='거래완료'}"><th>거래완료</th></c:if>
							<c:if test="${usedtrade.state=='거래완료'}"><th>판매자평가</th></c:if>							
						</tr>
					</thead>
					<tbody>											
						<c:forEach items="${usedtrades}" var="usedtrade">							
							<tr>
								<td>${usedtrade.time}</td>
								<td>${usedtrade.sellerid}</td>
								<td>${usedtrade.bookname}</td>
								<td>${usedtrade.finalprice}</td>
								<td>${usedtrade.state}</td>
								<c:if test="${usedtrade.state!='거래완료'}"><td><a href="#" class="btn-trade-complete">완료하기</a>
									<input type="hidden" value="${usedtrade.code}"></td></c:if>
								<c:if test="${usedtrade.state=='거래완료' && usedtrade.score==0}"><td><a href="#" id="btn-eval">평가하기</a></td></c:if>
								<c:if test="${usedtrade.state=='거래완료' && usedtrade.score!=0}"><td><a href="#" id="btn-eval-see">평가보기</a></td></c:if>
							</tr>
							<tr class="noneclass">
								<td colspan="2">
									<select class="score" name="score">
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="3">3</option>
										<option value="4">4</option>
										<option value="5">5</option>
									</select>
								</td>
								<td style="display: none"></td>
								<td colspan="3"	style="word-break:break-all;" >
									<textarea rows="1" cols="50" name="evaltext" style="vertical-align: middle;"></textarea>									
									<button type="submit" class="btn btn-outline-primary" style="vertical-align: middle;">입력</button>
								</td>
								<td style="display: none"></td>
								<td style="display: none"></td>
								<td></td>							
							</tr>
							<tr class="noneclass">
								<td colspan="2">
									<select class="eval-score">
										<c:forEach begin="1" end="5" step="1" varStatus="status">										
											<option value="${status.count}"
												<c:if test="${status.count==usedtrade.score}">selected</c:if>	
											>${status.count}</option>																						
										</c:forEach>
									</select>
								</td>
								<td style="display: none"></td>
								<td colspan="3"	style="word-break:break-all; vertical-align: middle;" >
									${usedtrade.evaltext}																		
								</td>
								<td style="display: none"></td>
								<td style="display: none"></td>
								<td></td>							
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