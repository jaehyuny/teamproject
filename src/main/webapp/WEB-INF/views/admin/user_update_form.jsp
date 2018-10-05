<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="userupdate" id="user-update-form" method="post">
		<div class="container">
			<div class="row">
				<div class="col-sm-3"></div>
				<div class="col-sm-6">
					<div class="row">
						<div class="col-sm-12">
							<div class="alert pri-back" style="margin-top: 10px">
								<h4 style="text-align: center;">회원정보</h4>
							</div>

						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text user-form">아이디</span>
								</div>
								<input type="email" class="form-control" id="id" name="id" value="${user.id}" readonly>
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
								<input type="text" class="form-control" id="password" name="password" value="${user.password}"
									required="true" data-parsley-error-message="비밀번호를 입력하세요!"
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
					<div class="row">
						<div class="col-sm-12">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text user-form">이름</span>
								</div>
								<input type="text" class="form-control" id="name" name="name" value="${user.name}"
									required="true" data-parsley-error-message="이름을 입력하세요!"
									data-parsley-errors-container="div[id='nameError']">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text user-form">닉네임</span>
								</div>
								<input type="text" class="form-control" id="nickname" name="nickname" value="${user.nickname}">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div id="nameError" style="color: #FF0000; text-align: center;"></div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text user-form">전화번호</span>
								</div>
								<input type="text" class="form-control" id="phone1" name="phone1" value="${user.phone1}"
									required="true" data-parsley-type="number"
									data-parsley-error-message="숫자로 된 전화번호를 입력하세요!"
									data-parsley-errors-container="div[id='phoneError']">
								<input type="text" class="form-control" id="phone2" name="phone2" value="${user.phone2}"
								    required="true" data-parsley-type="number"
									data-parsley-error-message="숫자로 된 전화번호를 입력하세요!"
									data-parsley-errors-container="div[id='phoneError']">
								<input
									type="text" class="form-control" id="phone3" name="phone3" value="${user.phone3}"
									required="true" data-parsley-type="number"
									data-parsley-error-message="숫자로 된 전화번호를 입력하세요!"
									data-parsley-errors-container="div[id='phoneError']">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div id="phoneError" style="color: #FF0000; text-align: center;"></div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text user-form">등급</span>
								</div>
								<select id="grade" name="grade" class="form-control">
									<c:forEach var="grade" items="${grade}" varStatus="status">
										<option value="${grade.code}" <c:if test="${grade.code == user.grade}">selected</c:if>>${grade.name}</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text user-form">포인트</span>
								</div>
								<input type="text" class="form-control" id="point" name="point" value="${user.point}">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text user-form">환불은행</span>
								</div>
								<input type="text" class="form-control" id="returnbank" name="returnbank" value="${user.returnbank}">
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-12">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text user-form">환불계좌</span>
								</div>
								<input type="text" class="form-control" id="returnfinance" name="returnfinance" value="${user.returnfinance}">
							</div>
						</div>
					</div>
					<div class="row" style="margin-bottom: 10px">
						<div class="col-sm-4">
							<button type="button" class="btn pri-back btn-block" id="userupdate-save">확인</button>
						</div>
						<div class="col-sm-4">
						<c:choose>
							<c:when test="${user.id != 'admin@nullpointers.com'}">
							<button type="button" class="btn btn-danger btn-block" id="userdelete">삭제</button>
							</c:when>
							<c:otherwise>
							</c:otherwise>
						</c:choose>
						</div>
						<div class="col-sm-4">
							<button type="reset" class="btn btn-warning btn-block">리셋</button>
						</div>
					</div>
				</div>
				<div class="col-sm-3"></div>
			</div>
		</div>
	</form>
	<!-- Modal -->
	<div id="user-Modal" class="modal fade" role="dialog">
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
					<button type="button" class="btn modal-negative pri-back" data-dismiss="modal">취소</button>
				</div>
			</div>

		</div>
	</div>
</body>
</html>