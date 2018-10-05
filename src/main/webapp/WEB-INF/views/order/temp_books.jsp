<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 상세 정보</title>
</head>
<body>
<!-- body container -->
<div class="container">
<h1>임시 책 선택, 주문 페이지</h1>

<form name="temp_books" class="temp_books" method="post" action="orderMain">

<c:forEach var="book" items="${bookList}">
<hr>
<a class="temp_book" href="orderMain?code=${book.code}"><b>${book.code}</b> ${book.name}</a>
<p>${book.isbn }</p>
<p>${book.scale }</p>
<p>${book.discription }</p>
<p>${book.contentlist }</p>
<hr>
</c:forEach>

</form>




</div>
<!-- body container end -->

<script>

$(document).ready(function(){

	
})

</script>


</body>
</html>