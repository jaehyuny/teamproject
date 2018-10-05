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

<div class="container event_write_container">
	<form id="eventForm" action="eventWrite" method="POST" enctype="multipart/form-data">
		<div class="input-group">
			<div class="input-group-prepend">
				<span class="input-group-text">이벤트 제목</span>
			</div>
			<input type="text" class="form-control" name="title" value="" required>
		</div>
		<div class="input-group">
			<div class="input-group-prepend">
				<span class="input-group-text">이벤트 시작일</span>
			</div>
			<input type="text" class="form-control" name="startday" id="eventStartDay" value="" placeholder="yyyy-mm-dd HH:mm:ss" required>
		</div>
		<div class="input-group">
			<div class="input-group-prepend">
				<span class="input-group-text">이벤트 종료일</span>
			</div>
			<input type="text" class="form-control" name="endday" id="eventEndDay" value="" placeholder="yyyy-mm-dd HH:mm:ss" required>
		</div>
	
		<div class="area_mainImage">
			<h4>메인 이미지 등록</h4>
			<input type="file" id="insertImage_main" name="picturelink">
			<div class="event_image_box">
				<img src="resources/images/icons/no-image-icon.png" id="image_eventMain" class="image_event">
			</div>
		</div>
		<div class="area_textImage">
			<h4>본문 이미지 등록</h4>
			<input type="file" id="insertImage_text" name="eventimage">
			<div class="event_image_box">
				<img src="resources/images/icons/no-image-icon.png" id="image_eventText" class="image_event">
			</div>
		</div>
		<p>이벤트 내용</p>
		<textarea class="form-control" name="content" style="resize:none; height:250px;"></textarea>
	
		<button type="submit" class="btn btn-primary btn_submit_event">등록하기</button>
	</form>


</div>


<script>

$(document).ready(function(){
	$("#insertImage_main").on("change", function(e){
		var tmppath = URL.createObjectURL(e.target.files[0]);
		$('#image_eventMain').attr('src', tmppath);
	});
	$("#insertImage_text").on("change", function(e){
		var tmppath = URL.createObjectURL(e.target.files[0]);
		$('#image_eventText').attr('src', tmppath);
	});
	
});

</script>





</body>
</html>