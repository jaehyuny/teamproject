<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>중고 주문 완료</title>
</head>
<body>
<!-- body container -->
<div class="container">
<h1>주문 결과</h1>
${fail }
	<table class="table">
		<tbody>
			<c:forEach var="one" items="${faillist}">
			<tr>
				<td>${one }<td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>
</body>
</html>