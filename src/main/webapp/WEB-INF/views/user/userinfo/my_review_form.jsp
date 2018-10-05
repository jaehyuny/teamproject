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
						님의 <big><big>R</big></big>eview
					</h4>
				</div>
			</div>
			<div class="row" id="row">
				<table id="table-id-review" class="display"
					style="text-align: center;">
					<thead>
						<tr>
							<th>작성일시</th>
							<th>제목</th>
							<th>책명</th>
							<th>조회수</th>
							<th><img alt="" src="resources/images/icons/star.PNG"
								width="20px"></th>
							<th><img alt="" src="resources/images/icons/like.png"
								width="20px"></th>
							<th><img alt="" src="resources/images/icons/dislike.png"
								width="20px"></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${reviews}" var="review">
							<tr>
								<td>${review.time}</td>
								<td><a href="#" class="btn-review">${review.title}</a><input type="hidden" value="${review.code}"></td>
								<td>${review.bookname}</td>
								<td>${review.hit}</td>
								<td><img alt="" src="resources/images/icons/star.PNG"
									width="10px">*${review.score}</td>
								<td>${review.likecount}</td>
								<td>${review.dislikecount}</td>								
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</form>	
</body>
</html>