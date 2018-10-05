<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="login" id="login-insert-form">
		<div class="container">
			<div class="row">
				<div class="col-sm-3"></div>
				<div class="col-sm-6">
					<div class="row">
						<div class="col-sm-12">
							<div class="alert sec-back" style="margin-top: 10px">
								<h4 style="text-align: center;">로그인</h4>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text user-form">아이디</span>
								</div>
								<input type="email" class="form-control" id="id" name="id"
									required="true" data-parsley-type="email"
									data-parsley-error-message="email 형식의 아이디를 입력하세요!"
									data-parsley-errors-container="div[id='idError']">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div id="idError" style="color: #FF0000; text-align: center;"></div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text user-form">비밀번호</span>
								</div>
								<input type="password" class="form-control" id="password"
									name="password" required="true"
									data-parsley-error-message="비밀번호를 입력하세요!"
									data-parsley-errors-container="div[id='passwordError']">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div id="passwordError"
								style="color: #FF0000; text-align: center;"></div>
						</div>
					</div>
					<div class="row" style="margin-bottom: 10px">
						<div class="col-sm-6">
							<button type="button" class="btn sec-back btn-block" id="login">확인</button>
						</div>
						<div class="col-sm-6">
							<button type="reset" class="btn btn-warning btn-block">취소</button>
						</div>
					</div>
				</div>
				<div class="col-sm-3"></div>
			</div>
		</div>
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
					<button type="button" class="btn modal-positive pri-back"
						data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>
</body>
</html>