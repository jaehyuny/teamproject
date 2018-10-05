<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
	.noresize {
	  resize: none; /* 사용자 임의 변경 불가 */
	}
</style>
</head>
<body>
	<form id="author_insert_form" name="author_insert_form" method="post" action="authorinsert" data-parsley-validate="true" enctype="multipart/form-data">
		<input type="hidden" id="confirm_yn" value="n">
		<div class="container">
			<div class="row" style="margin-top: 30px">
				<div class="col-md-4"></div>
				<div class="col-md-4" style="text-align: center">
				<a href=#><img id="insertimage" src="resources/images/noimage.jpg" title="클릭 후 이미지 변경" alt="클릭 후 이미지 변경" width="120px" height="160px"></a>
				</div>
				<div class="col-md-4"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-6">
					<div>
						<input type="file" id="insertphoto" name="img" style="visibility: hidden">
					</div>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 저자이름</span>
					</div>
					<input type="text" id="authorname" name="name" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 생년월일</span>
					</div>
					<input type="text" id="birthyear" name="birthyear" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px; height: 200px"> 저자소개</span>
					</div>
					<textarea class="form-control noresize" id="discription" name="discription"></textarea>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row" style="margin-top: 30px; margin-bottom:30px">
				<div class="col-md-4"></div>
				<div class="col-md-2" style="text-align: center">
					<button type="submit" id="authorsave" class="btn pri-back btn-block save">확인</button>
				</div>
				<div class="col-md-2">
					<button type="reset" class="btn btn-warning btn-block">리셋</button>
				</div>
				<div class="col-md-4"></div>
			</div>
			<!-- Modal -->
			<div id="myModal" class="modal fade" role="dialog">
				<div class="modal-dialog">

					<!-- Modal content-->
					<div class="modal-content">
						<div class="modal-header" style="background-color: #9999cc">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h4 class="modal-title"></h4>
						</div>
						<div class="modal-body">
							<p>Some text in the modal.</p>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-success modal_btn1" data-dismiss="modal">close</button>
							<button type="button" class="btn btn-success modal_btn2" data-dismiss="modal">취소</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>