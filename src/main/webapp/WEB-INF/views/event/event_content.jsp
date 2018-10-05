<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>event</title>
</head>
<body>
<!-- body container -->
<div class="container event_content_container">
	<h4>${event.title}</h4>
	<p>시작일 : ${event.startday}</p>
	<p>종료일 : ${event.endday}</p>
	<div>
		${event.content}
	</div>


</div>
<!-- body container end -->



</body>
</html>