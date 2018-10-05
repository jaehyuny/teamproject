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
	<form id="coupon_insert_form" name="coupon_insert_form" method="post" action="couponinsert" data-parsley-validate="true" enctype="multipart/form-data">
		<input type="hidden" id="confirm_yn" value="n">
		<div class="container">
			<div class="row" style="margin-top: 30px">
				<div class="col-md-4"></div>
				<div class="col-md-4" style="text-align: center">
				<a href=#><img id="insertimage" src="resources/images/coupon/cp7.png" title="클릭 후 이미지 변경" alt="클릭 후 이미지 변경" width="300px" height="150px"></a>
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
						<span class="input-group-text" style="width: 150px"> 쿠폰이름</span>
					</div>
					<input type="text" id="couponname" name="name" class="form-control" placeholder="쿠폰이름을 입력하세요" required="true" data-parsley-error-message="사용가능한 쿠폰이름이 아닙니다" data-parsley-errors-container="div[id='nameError']">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="col-md-6">
					<div id="nameError" style="color: #f00"></div>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 고정할인효과</span>
					</div>
					<input type="text" id="couponfixedsale" name="fixedsale" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 퍼센트할인효과</span>
					</div>
					<input type="text" id="couponpercentsale" name="percentsale" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 퍼센트최대치</span>
					</div>
					<input type="text" id="couponpercentmaxsale" name="percentmaxsale" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 얼마이상구매</span>
					</div>
					<input type="text" id="couponmoneycondition" name="moneycondition" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 카테고리제한</span>
					</div>
					<select id="catcondition" name="catcondition" class="form-control">
						<option value="">없음</option>
						<c:forEach var="categorys" items="${categorys}" varStatus="status">
							<option value="${categorys.name}">${categorys.name}</option>
						</c:forEach>
					</select>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 무료배송여부</span>
					</div>
					<input type="text" id="isfreeshiping" name="isfreeshiping" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 유효기간</span>
					</div>
					<input type="text" id="exfireday" name="exfireday" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 책 갯수제한</span>
					</div>
					<input type="text" id="acceptnum" name="acceptnum" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row" style="margin-top: 30px; margin-bottom:30px">
				<div class="col-md-4"></div>
				<div class="col-md-2" style="text-align: center">
					<button type="submit" id="couponsave" class="btn pri-back btn-block save">확인</button>
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