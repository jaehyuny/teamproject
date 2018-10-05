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
	<input type="hidden" id="updatemsg" value="${updatemsg}">
	<form style="width: 70%; margin: 0 auto;" action="userInfoDelete"
		id="user-delete-form">
		<div>
			<h4 style="text-align: center; margin-bottom: 30px">회원 탈퇴</h4>
		</div>
		<div class="form-row">
			<div class="form-group col-md-12">
				<label>아이디</label> <input type="email" class="form-control" id="id"
					placeholder="id" name="id" required="true" value="${sessionid}" readonly="readonly"
					data-parsley-type="email"
					data-parsley-error-message="email 형식의 아이디를 입력하세요!"
					data-parsley-errors-container="div[id='idError']">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div id="idError" style="color: #FF0000; text-align: center;"></div>
			</div>
		</div>
		<div class="form-row">
			<div class="form-group col-md-12">
				<label>비밀번호</label> <input type="password" class="form-control"
					placeholder="Password" id="password" name="password"
					required="true" data-parsley-error-message="비밀번호를 입력하세요!"
					data-parsley-errors-container="div[id='passwordError']">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div id="passwordError" style="color: #FF0000; text-align: center;"></div>
			</div>
		</div>
		<div class="form-row">
			<div class="form-group col-md-12">
				<label>비밀번호 확인</label> <input type="password" class="form-control"
					placeholder="Password confirm" id="password-confirm" name="password-confirm" 
					required="true" data-parsley-error-message="비밀번호 확인을 입력하세요!"
					data-parsley-errors-container="div[id='confirmError']">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div id="confirmError" style="color: #FF0000; text-align: center;"></div>
			</div>
		</div>
		<button type="button" class="btn btn-block btn-danger"
			id="userinfo-delete" style="margin-bottom: 30px">탈퇴하기</button>
	</form>
	<!-- Modal -->
	<div class="modal fade" role="dialog">
		<div class="modal-dialog">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Modal Header</h4>
				</div>
				<div class="modal-body">
					<p>Some text in the modal.</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn modal-positive btn-danger"
						data-dismiss="modal"></button>
					<button type="button" class="btn modal-negative btn-secondary"
						data-dismiss="modal"></button>
																
				</div>
			</div>
		</div>
	</div>
</body>
</html>