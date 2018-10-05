<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>중고거래 주문</title>
<script>
	function clickSubmit(){
		$('#receivertell').val($('#delivery_tel1').val()+$('#delivery_tel2').val()+$('#delivery_tel3').val());
		$('#receiverphone').val($('#delivery_phone1').val()+$('#delivery_phone2').val()+$('#delivery_phone3').val());
		document.getElementById('submit-button').click();
	}

</script>
<style>

</style>
</head>
<body>
<!-- body container -->
<div class="container basket_container">
<h1>중고거래 주문</h1>

<c:if test="${fn:length(usedbasket)!=0 }">
<form method="POST" action="buyUsedBook">
<input type="hidden" name="receivertell" id="receivertell">
<input type="hidden" name="receiverphone" id="receiverphone">
<section class="section_table_order">
	<h3><span>주문상품 목록</span></h3>
	<!-- 상품목록 테이블 -->
	<table class="table table_order">
		<colgroup>
			<col style="width:50%;">
			<col style="width:14%;">
			<col style="width:14%;">
			<col style="width:14%;">
			<col style="width:7%;">
			<col style="width:15%;">
		</colgroup>
		<thead>
			<tr>
				<th>상품정보</th>
				<th>판매자</th>
				<th>가격</th>
				<th>개수</th>
				<th>합계</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="basket" items="${usedbasket}">
				<c:if test="${basket != null}">
					<tr class="order_item">
						<td>
						<button type="button" class="btn btn-danger btn-sm" onclick="location.href='removeUsedBasket?usedSellCode=${basket.usedsellcode}'">X</button>
						<c:choose>
						<c:when test="${basket.bookcode != null }">
							<a href="bookDetailPage?bookcode=${basket.bookcode }">
							${basket.bookname}
							</a>
						</c:when>
						<c:otherwise>
							${basket.bookname}
						</c:otherwise>
						</c:choose>
						</td>
						<td>
							${basket.sellerid }
						</td>
						<td><span class="numeric" data-numeric="${basket.price }"></span>원</td>
						<td><input type="text" style="width:50px; display: inline-block;"  value="${basket.amount}" class="form-control order_amount" data-parsley-type="digits" readonly></td>
						<td><span class="numeric" data-numeric="${basket.amount*basket.price }"></span>원</td>
					</tr>
				</c:if>
			</c:forEach>
		</tbody>
	</table>
	<!-- 최종결제금액 테이블 -->
	<table class="table table_total">
		<colgroup>
			<col style="width:33%;">
			<col style="width:33%;">
			<col style="width:33%;">
		</colgroup>
		<thead>
			<tr>
				<th>상품금액</th>
				<th class="order_item">배송비</th>
				<th>결제 예정금액</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><span class="numeric" data-numeric="${booktotalprice }"></span>원<div class="cal_icon">+</div></td>
				<td><span class="numeric" data-numeric="${shippingprice }"></span>원<div class="cal_icon">=</div></td>
				<td><span class="numeric" data-numeric="${finalprice}"></span>원</td>
			</tr>
		</tbody>
	</table>
</section>

<!-- 배송지모듈 -->
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


<button type="button" class="btn btn-warning" onClick="clickSubmit()">결제하기</button>
<button type="submit" id="submit-button" style="width:0px; height:0px" ></button>
<hr>

</form>
</c:if>
<c:if test="${fn:length(usedbasket)==0 }">
<div style="text-align: center;">
	<h2>현재 장바구니에 담은 상품이 없습니다.</h2>
	<button class="btn btn-primary" onclick="location.href='usedMainPage'">중고장터 보러가기</button>
</div>
</c:if>
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