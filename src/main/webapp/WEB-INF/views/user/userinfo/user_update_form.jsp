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
	<form style="width: 70%; margin: 0 auto;" action="userInfoUpdate"
		id="user-update-form">
		<div>
			<h4 style="text-align: center; margin-bottom: 30px">회원 정보 수정</h4>
		</div>
		<div class="form-row">
			<div class="form-group col-md-12">
				<label>아이디</label> <input type="email" class="form-control" id="id"
					placeholder="id" readonly="readonly" name="id" value="${user.id}">
			</div>
		</div>
		<div class="form-row">
			<div class="form-group col-md-12">
				<label>비밀번호</label> <input type="password" class="form-control"
					id="password" placeholder="Password" name="password"
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
				<label>이름</label> <input type="text" class="form-control" id="name"
					placeholder="name" readonly="readonly" name="name"
					value="${user.name}">
			</div>
		</div>
		<div class="form-row">
			<div class="form-group col-md-12">
				<label>별명</label> <input type="text" class="form-control"
					id="nickname" placeholder="nickname" name="nickname"
					value="${user.nickname}" required="true"
					data-parsley-error-message="별명을 입력하세요!"
					data-parsley-errors-container="div[id='nicknameError']">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div id="nicknameError" style="color: #FF0000; text-align: center;"></div>
			</div>
		</div>
		<div class="form-row">
			<div class="form-group col-md-4">
				<label>전화번호1</label> <input type="text" class="form-control"
					id="phone1" name="phone1" placeholder="ex)010" maxlength="3"
					value="${user.phone1}" required="true" data-parsley-type="number"
					data-parsley-error-message="숫자로 된 전화번호를 입력하세요!"
					data-parsley-errors-container="div[id='phoneError']">
			</div>
			<div class="form-group col-md-4">
				<label>전화번호2</label> <input type="text" class="form-control"
					id="phone2" name="phone2" placeholder="ex)1234" maxlength="4"
					value="${user.phone2}" required="true" data-parsley-type="number"
					data-parsley-error-message="숫자로 된 전화번호를 입력하세요!"
					data-parsley-errors-container="div[id='phoneError']">
			</div>
			<div class="form-group col-md-4">
				<label>전화번호3</label> <input type="text" class="form-control"
					id="phone3" name="phone3" placeholder="ex)5678" maxlength="4"
					value="${user.phone3}" required="true" data-parsley-type="number"
					data-parsley-error-message="숫자로 된 전화번호를 입력하세요!"
					data-parsley-errors-container="div[id='phoneError']">
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div id="phoneError" style="color: #FF0000; text-align: center;"></div>
			</div>
		</div>
		<button type="button" class="btn btn-block pri-back"
			id="userinfo-update" style="margin-bottom: 30px">수정하기</button>
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
					<button type="button" class="btn modal-positive pri-back" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>