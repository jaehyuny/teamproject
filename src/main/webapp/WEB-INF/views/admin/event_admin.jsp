<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<div class="container" style="padding:40px 0;">


<c:forEach items="${eventlist}" var="event">
	<a href="${event.pagelink}" class="event_item">
		<p>${event.code}</p>
		<div class="event_img_box">
			<img src="${event.picturelink}">
		</div>
		<p><strong>${event.title}</strong></p>
		<p><span class="eventDate">${event.startday}</span> ~ <span class="eventDate">${event.endday}</span></p>
	</a>
</c:forEach>

<ul class="pagination justify-content-center">
	<c:if test="${pageNum != 1}">
	<li class="page-item">
		<a class="page-link" href="eventAdmin?pageNum=${pageNum - 1}">Previous</a>
	</li>
	</c:if>
	<c:forEach var="page" begin="1" end="${pageCount}">
	<li class="page-item <c:if test="${pageNum == page}"> active</c:if>">
		<a class="page-link" href="eventAdmin?pageNum=${page}">
		${page}
		<c:if test="${pageNum == page}">
		<span class="sr-only">(current)</span>
		</c:if>
		</a>
	</li>
	</c:forEach>
	<c:if test="${pageNum != pageCount}">
	<li class="page-item">
		<a class="page-link" href="eventAdmin?pageNum=${pageNum + 1}">Next</a>
	</li>
	</c:if>
</ul>



<a href="eventWritePage" class="btn btn-primary btn_eventWrite">이벤트 작성</a>

</div>


<script>

$(document).ready(function(){
	$(".eventDate").each(function(){
		var date = $(this).text().substring(0,10);
		$(this).text(date);
	})
});

</script>





</body>
</html>