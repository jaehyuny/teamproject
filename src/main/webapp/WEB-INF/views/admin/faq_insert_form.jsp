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
	<form id="faq_insert_form" name="faq_insert_form" method="post" action="faqinsert">
		<input type="hidden" name="boardname" value="faq">
		<input type="hidden" name="ip" value="admin">
		<div class="container">
			<div class="row" style="margin-top: 30px">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 100px; height: 100px"> 질문</span>
					</div>
					<textarea class="form-control noresize" id="title" name="title"></textarea>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 100px; height: 200px"> 답변</span>
					</div>
					<textarea class="form-control noresize" id="content" name="content"></textarea>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row" style="margin-top: 30px; margin-bottom:30px">
				<div class="col-md-4"></div>
				<div class="col-md-2" style="text-align: center">
					<button type="submit" id="faqsave" class="btn pri-back btn-block save">확인</button>
				</div>
				<div class="col-md-2">
					<button type="reset" class="btn btn-warning btn-block">리셋</button>
				</div>
				<div class="col-md-4"></div>
			</div>
		</div>
	</form>
</body>
</html>