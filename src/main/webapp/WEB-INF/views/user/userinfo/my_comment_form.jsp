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
						님의 <big><big>C</big></big>omment
					</h4>
				</div>
			</div>
			<div class="row" id="row">
				<table id="table-id-comment" class="display"
					style="text-align: center;">
					<thead>
						<tr>
							<th>작성날짜</th>
							<th>책 이름</th>
							<th><img alt="" src="resources/images/icons/star.PNG"
								width="20px"></th>
							<th><img alt="" src="resources/images/icons/like.png"
								width="20px"></th>
							<th><img alt="" src="resources/images/icons/dislike.png"
								width="20px"></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${evaluates}" var="evaluate" varStatus="status">
							<tr>
								<td>${evaluate.time}</td>
								<td>
									<div class="accordion" id="accordionExample">
										<div class="card">
											<div class="card-header" id="headingOne">
												<h5 class="mb-0">
													<button class="btn btn-link" type="button"
														data-toggle="collapse" data-target="#collapse${status.count}"
														aria-expanded="true" aria-controls="collapseOne">
														${evaluate.bookname}</button>
												</h5>
											</div>

											<div id="collapse${status.count}" class="collapse"
												aria-labelledby="headingOne" data-parent="#accordionExample">
												<div class="card-body">${evaluate.content}</div>
											</div>
										</div>
									</div>
								</td>
								<td><img alt="" src="resources/images/icons/star.PNG"
									width="10px">*${evaluate.score}</td>
								<td>${evaluate.likecount}</td>
								<td>${evaluate.dislikecount}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</form>
</body>
</html>