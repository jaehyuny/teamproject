<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>order page</title>
</head>
<body>
<!-- body container -->
<div class="container basket_container">
<h1>주문/결제</h1>

<form method="POST" action="orderResult" id="getOrder">
<input type="hidden" name="receivertell">
<input type="hidden" name="receiverphone">
<input type="hidden" name="couponcode" id="orderCouponDelivery" value="0">
<input type="hidden" name="couponcode2" id="orderCouponDiscount" value="0">
<section class="section_table_order">
	<h3><span>주문상품 목록</span></h3>
	<table class="table table_order">
		<colgroup>
			<col style="width:50%;">
			<col style="width:14%;">
			<col style="width:14%;">
			<col style="width:7%;">
			<col style="width:15%;">
		</colgroup>
		<thead>
			<tr>
				<th>상품정보</th>
				<th>가격</th>
				<th>할인가</th>
				<th>개수</th>
				<th>합계</th>
			</tr>
		</thead>
		<tbody>
			<c:if test="${book == null}">
				<c:forEach var="basket" items="${basketList}">
					<c:if test="${basket != null}">
						<tr class="order_item order_product" data-category="${basket.bookcategory}" data-code="${basket.bookcode}" data-usingcoupon="0" data-usingpoint="0">
							<td>
								<img src="resources/images/books/${basket.bookcode}.jpg">
								<p>${basket.bookname}</p>
							</td>
							<td><span class="real_price numeric" data-numeric="${basket.bookprice}">${basket.bookprice}</span>원</td>
							<td>
								<span class="discount_price numeric" data-numeric="${basket.bookprice}"></span>원<br>
								<button type="button" class="btn btn_applyCoupon btn_discountCoupon">쿠폰</button>
							</td>
							<td><input type="text" name="amount" value="${basket.amount}" class="form-control order_amount" data-parsley-type="digits" readonly></td>
							<td>
								<span class="total_price numeric" data-numeric="${basket.amount * basket.bookprice}">${basket.amount * basket.bookprice}</span>원
								<br>
								<button type="button" class="btn btn_usePoint">포인트</button>
								<div class="box_point">
									<p class="show_point has_point">보유 포인트 : <strong data-numeric="${user.point}" class="numeric">${user.point}</strong></p>
									<p class="show_point usable_point">사용 가능 포인트 : <strong data-maxpoint="${user.point}" data-numeric="${user.point}" class="numeric">${user.point}</strong></p>
									<p class="show_point max_point">최대 포인트 : <strong data-maxpoint="${basket.amount * basket.bookprice * 0.15}" data-numeric="${basket.amount * basket.bookprice * 0.15}" class="numeric"></strong></p>
									<p class="used_point">사용 포인트 : <strong data-numeric="0" class="numeric"></strong></p>
									<input type="text" class="form-control input_usePoint" value="0">
									<button type="button" class="btn btn_applyPoint">사용</button>
								</div>
							</td>
						</tr>
					</c:if>
				</c:forEach>
			</c:if>
			<c:if test="${book != null}">
				<tr class="order_item order_product" data-category="${book.cat1}" data-code="${book.code}" data-usingcoupon="0" data-usingpoint="0">
					<td>
						<img src="resources/images/books/${book.code}.jpg">
						<p>${book.name}</p>
					</td>
					<td><span class="real_price numeric" data-numeric="${book.realprice}">${book.realprice}</span>원</td>
					<td>
						<span class="discount_price numeric" data-numeric="${book.realprice}"></span>원<br>
						<button type="button" class="btn btn_applyCoupon btn_discountCoupon">쿠폰</button>
					</td>
					<td><input type="text" name="amount" value="${bookAmount}" class="form-control order_amount" data-parsley-type="digits" readonly></td>
					<td>
						<span class="total_price numeric" data-numeric="${bookAmount * book.realprice}">${bookAmount * book.realprice}</span>원
						<br>
						<button type="button" class="btn btn_usePoint">포인트</button>
						<div class="box_point">
							<p class="show_point has_point">보유 포인트 : <strong data-maxpoint="${user.point}" data-numeric="${user.point}" class="numeric">${user.point}</strong></p>
							<p class="show_point usable_point">사용 가능 포인트 : <strong data-maxpoint="${user.point}" data-numeric="${user.point}" class="numeric">${user.point}</strong></p>
							<p class="show_point max_point">최대 포인트 : <strong data-maxpoint="${bookAmount * book.realprice * 0.15}" data-numeric="${bookAmount * book.realprice * 0.15}" class="numeric"></strong></p>
							<p class="used_point">사용 포인트 : <strong data-numeric="0" class="numeric"></strong></p>
							<input type="text" class="form-control input_usePoint" value="0">
							<button type="button" class="btn btn_applyPoint">사용</button>
						</div>
					</td>
				</tr>
			</c:if>
		</tbody>
	</table>
	<div class="modal_order modal_selectCoupon">
		<h4>쿠폰 적용</h4>
		<ul class="coupon_list book_coupon_list" data-couponcount="${saleCouponCount}">
			<c:forEach var="coupon" items="${saleCoupons}">
				<li data-code="${coupon.code}" data-name="${coupon.name}" 
				data-fixedsale="${coupon.fixedsale}" data-percentsale="${coupon.percentsale}" 
				data-percentmaxsale="${coupon.percentmaxsale}" data-moneycondition="${coupon.moneycondition}" 
				data-catcondition="${coupon.catcondition}" data-getexfireday="${coupon.getexfireday}" 
				data-ownercode="${coupon.ownercode}" data-acceptnum="${coupon.acceptnum}">
					<span class="coupon_summary">${coupon.name}(${coupon.getexfireday})</span>
					<button type="button" class="btn btn_usecoupon usecoupon_discount">사용</button>
					<button type="button" class="btn btn_usecoupon btn_using">취소</button>
				</li>
			</c:forEach>
		</ul>
		<ul class="coupon_list delivery_coupon_list">
			<c:forEach var="coupon" items="${deliveryCoupons}">
				<li data-code="${coupon.code}" data-name="${coupon.name}" 
				data-getexfireday="${coupon.getexfireday}" data-isfreeshiping="${coupon.isfreeshiping}" data-ownercode="${coupon.ownercode}">
					<span class="coupon_summary">${coupon.name}(${coupon.getexfireday})</span>
					<button type="button" class="btn btn_usecoupon usecoupon_delivery">사용</button>
					<button type="button" class="btn btn_usecoupon btn_using">취소</button>
				</li>
			</c:forEach>
		</ul>
	</div>
	<table class="table table_total">
		<colgroup>
			<col style="width:25%;">
			<col style="width:25%;">
			<col style="width:25%;">
			<col style="width:25%;">
		</colgroup>
		<thead>
			<tr>
				<th>상품금액</th>
				<th class="order_item order_delivery" data-delivery="0" data-usingcoupon="0">배송비<button type="button" class="btn btn_applyCoupon btn_deliveryCoupon">쿠폰</button></th>
				<th>결제 예정금액</th>
				<th>적립예정 포인트</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><span class="sum_total numeric" data-numreric></span>원<div class="cal_icon">+</div></td>
				<td><span class="delivery_price numeric" data-numeric="2000">2000</span>원<div class="cal_icon">=</div></td>
				<td><span class="last_price numeric" data-numeric></span>원</td>
				<td class="expected_point">
					<ul>
						<li>기본적립<span class="savePoint numeric" data-point="${sessionGrade.amount}" data-numeric></span></li>
						<li>추가적립<span>0P</span></li>
					</ul>
				</td>
			</tr>
		</tbody>
	</table>
</section>
<section>
	<h3><span>배송지</span></h3>
	<table class="table table_delivery table_order_info">
		<colgroup>
			<col style="width:25%;"></col>
			<col style="width:75%;"></col>
		</colgroup>
		<tr class="orderer_info">
			<th rowspan="3">주문자 정보</th>
			<td><span>${user.name}</span></td>
			
		</tr>
		<tr class="orderer_info">
			<td><span>${user.id}</span></td>
		</tr>
		<tr class="orderer_info">
			<td><span>${user.phone1}</span> - <span>${user.phone2}</span> - <span>${user.phone3}</span></td>
		</tr>
		<tr>
			<th>배송지 정보</th>
			<td class="td_addresslist">
				<button type="button" class="btn btn_addressList">주소록</button>
				<div class="modal_order modal_addresslist">
					<h4>주소록</h4>
					<ul class="order_addresslist">
						<c:forEach items="${addressList}" var="address">
							<li data-receiver="${address.receivername}" data-tel="${address.tel}" data-phone="${address.phone}" data-postno="${address.postno}" data-address1="${address.address1}" data-address2="${address.address2}" >
								<span>${address.nickname} (${address.address1})</span>
							</li>
						</c:forEach>
					</ul>
				</div>
				<table class="table_delivery_address">
					<tr>
						<th>받으시는 분</th>
						<td><input type="text" name="receivername" id="delivery_receiver" class="form-control" style="max-width:150px;" required></td>
					</tr>
					<tr>
						<th>휴대폰 번호</th>
						<td colspan="2">
							<input type="text" class="form-control input_num" id="delivery_phone1" maxlength="3" required>
							<input type="text" class="form-control input_num" id="delivery_phone2" maxlength="4" required>
							<input type="text" class="form-control input_num" id="delivery_phone3" maxlength="4" required>
						</td>
					</tr>
					<tr>
						<th>전화 번호</th>
						<td colspan="2">
							<input type="text" class="form-control input_num" id="delivery_tel1" maxlength="3" required>
							<input type="text" class="form-control input_num" id="delivery_tel2" maxlength="4" required>
							<input type="text" class="form-control input_num" id="delivery_tel3" maxlength="4" required>
						</td>
					</tr>
					<tr>
						<th>우편번호</th>
						<td>
							<input type="text" name="postno" class="form-control" id="delivery_postcode" required>
							<button type="button" class="btn btn-info btn_postcode" onclick="daumPostCode();">우편번호 검색</button>
						</td>
					</tr>
					<tr>
						<th>주소</th>
						<td colspan="2"><input type="text" name="address1" class="form-control" id="delivery_address" required></td>
					</tr>
					<tr>
						<th>상세주소</th>
						<td colspan="2"><input type="text" name="address2" class="form-control" id="delivery_address2" required></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
</section>
<section>
	<h3><span>계좌정보</span></h3>
	<table class="table table_delivery table_order_info">
		<colgroup>
			<col style="width:25%;"></col>
			<col style="width:75%;"></col>
		</colgroup>
		<tr class="orderer_info">
			<th>은행 이름</th>
			<td>
				<input type="text" id="returnBank" class="form-control input_bank" value="${user.returnbank}" maxlength="12">
			</td>
		</tr>
		<tr class="orderer_info">
			<th>은행 계좌</th>
			<td>
				<input type="text" id="returnFinance" class="form-control input_bank" value="${user.returnfinance}" maxlength="14">
			</td>
		</tr>
	</table>
</section>

<button type="button" class="btn btn-warning" id="btnGetOrder">결제하기</button>
<hr>

</form>

<div class="background_dark"></div>
</div>
<!-- body container end -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
    function daumPostCode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;

                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if(data.userSelectedType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('delivery_postcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('delivery_address').value = fullAddr;

                // 커서를 상세주소 필드로 이동한다.
                document.getElementById('delivery_address2').focus();
            }
        }).open();
    }
</script>

</body>
</html>