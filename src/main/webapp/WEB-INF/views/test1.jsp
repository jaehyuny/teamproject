<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="container">

<button type="button" class="btn">주소바꾸기</button>

<p>잡소리 주절주절</p>

</div>
<script>
$(".btn").on("click", function(){
	var stateObj = {foo : "bar"}; 
	history.pushState(stateObj, "page 2", "주소만 바꿈");
	
})

</script>

</body>
</html>