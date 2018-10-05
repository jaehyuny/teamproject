const SHIP_FEE = 2000;	//배송비

/* gnb 설정*/
$(document).ready(function() {
	scrollFixed();
	$(".gnb_bar_category").on("click", function(e) {
		e.stopPropagation();
		$(".gnb_bar_depth2").toggle();
	});
	$(".gnb_bar_depth2").on("click", function(e) {
		e.stopPropagation();
	});
	$(document).on("click", function() {
		$(".gnb_bar_depth2").hide();
	});
	$(window).on("scroll", function() {
		scrollFixed();
	})
	function scrollFixed() {
		var currentScroll = $(this).scrollTop();
		if (currentScroll > 190) {
			$(".gnb_bar").addClass("fixedScroll");
		} else {
			$(".gnb_bar").removeClass("fixedScroll");
		}
	}
	
	$(".btn_gnb_mobile").on("click", function(){
		$(this).find("li").toggleClass("active");
		$(".gnb_bar_depth1").toggle();
		
	});
	
	
});

/*로그인 필요한 페이지에 접근*/
$(document).ready(function(){
	if($(".not_login").attr("data-login") == "notLogin"){
		alert("로그인이 필요합니다.");
	}
	
});


/*member_insert_form*/
$(document).ready(function(){
	/*중복여부 버튼 클릭시 ajax 통신*/
	$('#dup-check').on('click',function(){
		var id= $('#id').val();						
		if(id==""){
			alert("아이디를 입력하세요!");
			return;
		} else{
			$.ajax({
				type : 'POST', //전송방식
				data : "id="+id, //전송 파라미터
				url : "userConfirm", //매핑 값
				success : function(data){ //전송 성공시
					if(data == 0){						
						$('#dup-yn').val("y");
						$('#user-Modal').modal('show');
						$('.modal-title').text("사용 가능");
						$('.modal-body').text("사용 가능한 아이디입니다!");
						$('.modal-positive').text("확인");
					} else{
						$('#dup-yn').val("n");
						$('#user-Modal').modal('show');
						$('.modal-title').text("사용 불가");
						$('.modal-body').text("중복 아이디입니다!");
						$('.modal-positive').text("확인");
					}						
				},
				error : function(xr,status,error){ //전송 실패시
					alert('ajax error');
				}
			});				
		}		
	});	
	/* save 버튼 클릭시 이벤트 */
	$('#user-save').on('click', function() {
		if ($('#dup-yn').val() == "n") {
			$('#user-Modal').modal('show');
			$('.modal-title').text("가입 실패");
			$('.modal-body').text("아이디 중복 체크를 하세요!");
			$('.modal-positive').text("확인");
			return;
		}
		$('#user-insert-form').parsley().validate();
		$('#user-insert-form').submit();
	});
    $('#userupdate-save').on('click', function() {
        $('#user-update-form').parsley().validate();
        $('#user-update-form').submit();
    });
    /* 삭제 버튼 클릭시 이벤트 */
    $('#userdelete').on('click', function() {
        $('#user-Modal').modal('show');
        $('.modal-title').text("회원 삭제");
        $('.modal-body').text("삭제하시겠습니까?");
        $('.modal-positive').text("확인");
        $('.modal-positive').on('click', function() {
            $('#user-update-form').attr('action', 'userdelete');
            $('#user-update-form').submit();
        });
    });
});


/* login */
$(document).ready(function(){
	$('#login').on('click',function(){	
		$('#login-insert-form').parsley().validate();
		/* 로그인 성공여부 확인 */
		var id= $('#id').val();
		var password = $('#password').val();
		if(id==""||password=="") return;
		$.ajax({
			type : 'POST', //전송방식
			data : "id="+id +"&password="+password, //전송 파라미터
			url : "loginCheck", //매핑 값
			success : function(data){ //전송 성공시
				if(data != 1){
					$('.modal').modal('show');
					$('.modal-title').text("로그인 실패");
					$('.modal-body').text("로그인에 실패하였습니다!");
					$('.modal-positive').text("확인");					
				} else{					
					$('#login-insert-form').submit();
				}						
			},
			error : function(xr,status,error){ //전송 실패시
				alert('ajax error');
			}
		});		
	});
	
});

/* 장바구니 및 주문 페이지*/
$(document).ready(function(){
	var orderItem = "";
	var amount = 0;
	var price = 0;
	var discount = 0;
	var couponCount = $(".book_coupon_list").attr("data-couponcount");
	priceCalculate();
	$(document).on("keyup", ".order_amount", function(){
		var regexp = /^[0-9]*$/;
		v = $(this).val();
		if( !regexp.test(v) ) {
			alert("숫자만 입력하세요");
			$(this).val(1);
		}
		if($(this).val() == 0){
			alert("최소 1개의 수량이 필요합니다.");
			$(this).val(1);
		}
		if($(this).val() > 999){
			alert("최대 값 999를 초과했습니다.");
			$(this).val(1);
		}

		priceCalculate();
	});
	
	/* 주문 페이지 전화번호 입력 체크*/
	$(document).on("keyup", ".input_num", function(){
		var regexp = /^[0-9]*$/
		v = $(this).val();
		if( !regexp.test(v) ) {
			alert("숫자만 입력하세요");
			$(this).val("0");
		}
	});
	
	//체크박스
	$(document).on("change", ".order_check_all", function(){
		if($(this).prop("checked") == true){
			$(".order_check").prop("checked", true);
		} else {
			$(".order_check").prop("checked", false);
		}
		priceCalculate();
	})
	
	$(document).on("change", ".order_check", function(){
		if($(this).prop("checked") == false){
			$(".order_check_all").prop("checked", false);
		}
		priceCalculate();
	})
	
	//장바구니 삭제
	$(document).on("click", ".delete_basket", function(){
		var n = 0;
		var del = confirm("정말 삭제하시겠습니까?");
		if(del){
			$.ajax({
				type : "POST",
				data : "bookcode=" + $(this).parents(".basket_item").find(".basket_bookcode").val(),
				url : "deleteBasket",
				success : function(data){
					$(".table_order").parent().load(location.href + " .table_order");
					$(".fa-shopping-cart").load(location.href + " .count_basket");
					setTimeout(function(){
						priceCalculate();
					}, 100);
				},
				error :function(xhr, status, error){
					alert("ajax error");
				}
			});
		}
	});
	
	/* 주소록 버튼 클릭*/
	$(".btn_addressList").on("click", function(e){
		e.stopPropagation();
		$(".modal_addresslist").toggleClass("active");
	});
	$(".modal_order").on("click", function(e){
		e.stopPropagation();
	});
	$(document).on("click", function(){
		$(".modal_order").removeClass("active");
	});
	
	/* 주소록 선택 */
	$(".order_addresslist li").on("click", function(e){
		e.stopPropagation();
		var receiver = $(this).attr("data-receiver");
		var tel = $(this).attr("data-tel");
		var phone = $(this).attr("data-phone");
		
		var telArray = phoneCalculate(tel);
		var phoneArray = phoneCalculate(phone);
		
		var postno = $(this).attr("data-postno");
		var address1 = $(this).attr("data-address1");
		var address2 = $(this).attr("data-address2");
		$("#delivery_tel1").val(telArray[0]);
		$("#delivery_tel2").val(telArray[1]);
		$("#delivery_tel3").val(telArray[2]);
		$("#delivery_phone1").val(phoneArray[0]);
		$("#delivery_phone2").val(phoneArray[1]);
		$("#delivery_phone3").val(phoneArray[2]);
		$("#delivery_receiver").val(receiver);
		$("#delivery_postcode").val(postno);
		$("#delivery_address").val(address1);
		$("#delivery_address2").val(address2);
		
		$(".modal_addresslist").removeClass("active");
	});
	
	/* 쿠폰 선택하기 */
	$(".btn_applyCoupon").on("click", function(e){
		e.stopPropagation();
		$(".box_point").removeClass("on");
		$(".modal_selectCoupon").removeClass("active");
		$(".modal_selectCoupon").addClass("active");
		if($(this).hasClass("btn_discountCoupon")){
			$(".delivery_coupon_list").hide();
			$(".book_coupon_list").show();
		} else {
			$(".delivery_coupon_list").show();
			$(".book_coupon_list").hide();
		}
		orderItem = $(this).parents(".order_item");
		var code = orderItem.attr("data-code");
		var category = orderItem.attr("data-category");
		
		$(".book_coupon_list li").each(function(){
			var $li = $(this);
			var this_category = $(this).attr("data-catcondition");
			var ownercode = $(this).attr("data-ownercode");
			$li.find(".usecoupon_discount").text("사용").removeClass("on");
			
			$(this).find(".usecoupon_discount").show();
			$(this).find(".btn_using").hide();
			if(this_category == category || this_category == ""){
				$(this).show();
			} else {
				$(this).hide();
			}
			
			if(orderItem.attr("data-usingcoupon") == $(this).attr("data-ownercode")){
				$(this).find(".usecoupon_discount").hide();
				$(this).find(".btn_using").show();
			} else {
				$(".order_item").each(function(){
					if($(this).attr("data-usingcoupon") == ownercode){
						$li.find(".usecoupon_discount").text("사용중").addClass("on");
					}
				});
			}
		});
		
		$(".delivery_coupon_list li").each(function(){
			var ownercode = $(this).attr("data-ownercode");
			$(this).find(".usecoupon_delivery").show();
			$(this).find(".btn_using").hide();
			if(orderItem.attr("data-usingcoupon") == ownercode){
				$(this).find(".usecoupon_delivery").hide();
				$(this).find(".btn_using").show();
			}
		});
		
	});
	
	$(".modal_selectCoupon h4").on("click", function(){
		$(".modal_selectCoupon").removeClass("active");
	});
	
	/* 할인가 - 쿠폰 선택 - 쿠폰 리스트에서 사용 버튼 눌렀을 때 */
	$(".usecoupon_discount").add(".usecoupon_delivery").on("click", function(){
		var couponOwnerCode = $(this).parent().attr("data-ownercode");
		var couponFixedsale = $(this).parent().attr("data-fixedsale");
		var couponPercentsale = $(this).parent().attr("data-percentsale");
		var couponPercentmaxsale = $(this).parent().attr("data-percentmaxsale");
		price = Number(orderItem.find(".real_price").attr("data-numeric"));
		amount = Number(orderItem.find(".order_amount").val());
		var chkusing = 0;
		var usedpoint = Number(orderItem.find(".used_point strong").attr("data-numeric"));
		var totalprice = Number(orderItem.find(".total_price").attr("data-numeric"));
		
		if($(this).hasClass("usecoupon_delivery")){
			$(".delivery_price").attr("data-numeric", 0);
			orderItem.attr("data-delivery", 1);
		} else {
			$(".order_item").each(function(){
				if($(this).attr("data-usingcoupon") == couponOwnerCode){
					alert("이미 다른 상품에 적용 중인 쿠폰입니다.");
					chkusing = 1;
					return false;
				}
			});
			
			if(chkusing == 1){
				return false;
			}
		}
		
		if($(this).parent().attr("data-acceptnum") == 1 && orderItem.find(".order_amount").val() != 1){
			alert("구매수량이 1개인 상품에만 적용 가능한 쿠폰입니다.");
			return false;
		}
		
		if(couponFixedsale != 0){
			discount = couponFixedsale;
		} else if (couponPercentsale != 0){
			discount = Number(price) * Number(couponPercentsale) / 100;
		}

		/* 도서정가제 적용 할인 제한 */
		if(Number(totalprice) / amount - Number(discount) < price * 0.85){
			alert("할인은 본래 가격의 15%를 넘을 수 없습니다.");
			return false;
		}
		
		orderItem.find(".max_point strong").attr("data-numeric", price * amount * 0.15 - discount * amount);
		orderItem.find(".discount_price").attr("data-numeric", price - discount);
		orderItem.attr("data-usingcoupon", couponOwnerCode);
		priceCalculate();
		$(".modal_selectCoupon").removeClass("active");
	});
	
	/* 사용 중인 쿠폰 취소를 눌렀을 때 */
	$(".book_coupon_list .btn_using").on("click", function(){
		var price = orderItem.find(".real_price").attr("data-numeric");
		var maxpoint = orderItem.find(".max_point strong").attr("data-maxpoint");
		orderItem.find(".discount_price").attr("data-numeric", price);
		orderItem.attr("data-usingcoupon", 0);
		discount = 0;
		orderItem.find(".max_point strong").attr("data-numeric", maxpoint);
		priceCalculate();
		$(".modal_selectCoupon").removeClass("active");
	});
	
	$(".delivery_coupon_list .btn_using").on("click", function(){
		$(".delivery_price").attr("data-numeric", SHIP_FEE);
		orderItem.attr("data-delivery", 0);
		orderItem.attr("data-usingcoupon", 0);
		priceCalculate();
		$(".modal_selectCoupon").removeClass("active");
	});
	
	/* 주문 시 쿠폰 목록 보기*/
	$(".td_coupon .usable_coupon .btn_confirm_coupon").on("click", function(e){
		e.stopPropagation();
		$(this).parents(".td_coupon").children(".delivery_coupon_list").slideToggle(100);
	});
	$(".delivery_coupon_list").on("click", function(e){
		e.stopPropagation();
	});
	$(document).on("click", function(){
		$(".delivery_coupon_list").slideUp(100);
	})
	
	/* 포인트 사용하기 */
	$(".btn_usePoint").on("click", function(e){
		orderItem = $(this).parents(".order_item");
		$(".background_dark").addClass("on");
		$(".modal_selectCoupon").removeClass("active");
		$(".box_point").not($(this).next(".box_point")).removeClass("on");
		e.stopPropagation();
		$(this).next(".box_point").toggleClass("on").find("input").focus();
	});
	$(document).on("click", function(){
		$(".background_dark").removeClass("on");
		$(".box_point").removeClass("on");
	});
	$(".box_point").on("click", function(e){
		e.stopPropagation();
	});
	
	$(".btn_applyPoint").on("click", function(){
		var max_point = Number($(".usable_point strong").attr("data-maxpoint"));
		var current_point = Number($(".usable_point strong").attr("data-numeric"));
		var use_point = $(this).prev("input").val();
		var use_point_total = 0;
		
		$(this).parent().find(".used_point strong").attr("data-numeric", use_point);
		
		$(".used_point strong").each(function(){
			use_point_total += Number($(this).attr("data-numeric"));
		});
		
		$(".usable_point strong").attr("data-numeric", max_point - use_point_total);
		
		priceCalculate();
	});
	
	/* 포인트 입력제한 */
	$(document).on("keyup keydown change", ".input_usePoint", function(){
		var regexp = /^[0-9]*$/
		v = $(this).val();
		if( !regexp.test(v) ) {
			alert("숫자만 입력하세요");
			$(this).val(0);
		}
		var usablePoint = Number($(".usable_point strong").attr("data-numeric"));
		if(v > usablePoint){
			alert("사용 가능한 포인트를 초과했습니다.");
			$(this).val(0);
		}
		/* 도서정가제 적용 할인 제한 */
		var price = Number(orderItem.find(".real_price").attr("data-numeric"));
		var amount = Number(orderItem.find(".order_amount").val());
		var usedpoint = v;
		
		if(Number(price * amount - usedpoint) / amount - Number(discount) < price * 0.85){
			alert("할인은 본래 가격의 15%를 넘을 수 없습니다.");
			$(this).val(0);
		}
		
		priceCalculate();
	});
	
});

/* 전화번호 계산 */
function phoneCalculate(num){
	var phoneArray = new Array();
	
	if(num.length == 10){
		if(num.substring(0,2) == "02"){
			phoneArray[0] = num.substring(0,2);
			phoneArray[1] = num.substring(2,6);
			phoneArray[2] = num.substring(6,10);
		} else {
			phoneArray[0] = num.substring(0,3);
			phoneArray[1] = num.substring(3,6);
			phoneArray[2] = num.substring(6,10);
		}
	} else if(num.length == 11){
		phoneArray[0] = num.substring(0,3);
		phoneArray[1] = num.substring(3,7);
		phoneArray[2] = num.substring(7,11);
	} else if(num.length == 9) {
		phoneArray[0] = num.substring(0,2);
		phoneArray[1] = num.substring(2,5);
		phoneArray[2] = num.substring(5,9);
	}
	
	return phoneArray;
}

/* 주문, 장바구니에서 가격을 계산하는 function */
function priceCalculate(){
	var total = 0;
	var price = 0;
	var total_notpoint = 0;
	
	$(".total_price").each(function(){
		if($(this).parents("tr").find(".order_check").prop("checked") == true){
			amount = $(this).parents("tr").find(".order_amount").val();
			price = $(this).parents("tr").find(".real_price").attr("data-numeric");
			$(this).attr("data-numeric", amount * price);
			total += Number($(this).attr("data-numeric"));
			total_notpoint += Number($(this).attr("data-numeric"));
		} else if($(this).parents("tr").hasClass("order_item")) {
			amount = $(this).parents("tr").find(".order_amount").val();
			price = $(this).parents("tr").find(".discount_price").attr("data-numeric");
			point = $(this).parents("tr").find(".used_point strong").attr("data-numeric");
			$(this).attr("data-numeric", amount * price - point);
			total += Number($(this).attr("data-numeric"));
			total_notpoint += Number($(this).attr("data-numeric")) + Number(point);
		}
	});
	
	$(".sum_total").attr("data-numeric", total);
	var lastPrice = total + Number($(".delivery_price").attr("data-numeric"));
	$(".last_price").attr("data-numeric", lastPrice);
	$(".final_price").attr("data-numeric", lastPrice);
	
	var pointPercent = $(".savePoint").attr("data-point") / 100;
	$(".savePoint").attr("data-numeric", total_notpoint * pointPercent);
	
	numericAddComma();
	
	$(".savePoint").text($(".savePoint").text() + "P");
	
	

}

/* 천단위로 콤마를 추가하는 function. 
 * 최종 결제금액의 경우엔 10원 단위 이하로 절사한다.*/
function numericAddComma(){
	$(".numeric").each(function(){
		if($(this).hasClass("final_price")){
			var floor10 = Math.floor(Number($(this).attr("data-numeric")) / 10)*10;
			$(this).attr("data-numeric", floor10);
		}
		var addComma = Number($(this).attr("data-numeric")).toLocaleString('en');
		$(this).text(addComma);
    });
}

/*장바구니 -> 주문페이지 이동 시*/
$(document).ready(function(){
	var checkCount = 0;
	var checkedNum = 0;
	$(".btn_order").on("click", function(){
		$(".order_check").each(function(){
			if($(this).prop("checked") == true){
				checkCount += 1;
				$(this).parent().find(".checkedNum").val(1);
			} else {
				$(this).parent().find(".checkedNum").val(0);
			}
		});

		if(checkCount == 0){
			alert("선택된 상품이 없습니다.");
		} else {
			$(".basket_form").submit();
		}
	});
});

/* 결제 시 submit 이전 처리*/
$(document).ready(function(){
	$("#btnGetOrder").on("click", function(){
		var inputChk = 0;
		var tel = "";
		var phone = "";
		tel = $("#delivery_tel1").val() + $("#delivery_tel2").val() + $("#delivery_tel3").val();
		phone = $("#delivery_phone1").val() + $("#delivery_phone2").val() + $("#delivery_phone3").val();
		$("input[name='receivertell']").val(tel);
		$("input[name='receiverphone']").val(phone);
		
		$("input").not("input[type='search']").each(function(){
			if($(this).val() == ""){
				inputChk += 1;
			}
		});

		if(inputChk > 0){
			alert("빈 값을 채워주세요.");
		} else {
			getOrder();
		}
	});
	
	function getOrder(){
		
		var tel = "";
		var phone = "";
		tel = $("#delivery_tel1").val() + $("#delivery_tel2").val() + $("#delivery_tel3").val();
		phone = $("#delivery_phone1").val() + $("#delivery_phone2").val() + $("#delivery_phone3").val();
		var itemsLength = $(".order_product").length;
		var receiverInfo = new Array();
		receiverInfo[0] = new Array();
		var bookCode = new Array();
		var bookCoupon = new Array();
		var bookPoint = new Array();
		receiverInfo[0] = $(".order_delivery").attr("data-usingcoupon");
		receiverInfo[1] = $("#delivery_receiver").val();
		receiverInfo[2] = tel;
		receiverInfo[3] = phone;
		receiverInfo[4] = $("#delivery_postcode").val();
		receiverInfo[5] = $("#delivery_address").val();
		receiverInfo[6] = $("#delivery_address2").val();
		receiverInfo[7] = $("#returnBank").val();
		receiverInfo[8] = $("#returnFinance").val();
		
//		console.log("before : " + receiverInfo[5]);
		var regExp = /,/;
		receiverInfo[5] = receiverInfo[5].replace(regExp, "，");
//		console.log("after : " + receiverInfo[5]);
		
//		console.log(receiverInfo);
		for(var i = 0; i < itemsLength; i++){
			bookCode[i] = $(".order_product:eq(" + i + ")").attr("data-code");
			bookCoupon[i] = $(".order_product:eq(" + i + ")").attr("data-usingcoupon");
			bookPoint[i] = $(".order_product:eq(" + i + ") .used_point strong").attr("data-numeric");
		}

		$.ajax({
			type : "POST",
			data : "receiverInfo=" + receiverInfo + "&bookCode=" + bookCode + "&bookCoupon=" + bookCoupon + "&bookPoint=" + bookPoint,
			url : "orderResult",
			success : function(data){
				if(data > 0){
					alert("주문이 완료되었습니다.");
					location.href="orderResultPage";
				} else {
					alert(data);
				}
			},
			error : function(xhr, status, error){
				alert("ajax error : " + error);
			}
			
		});
	}
	
});


/*쿠폰 이미지 삽입, 쿠폰 수정,삭제*/
$(document).ready(function(){
	$('#insertimage').on('click', function() {
		$('input[type=file]').click();
		return false
	});
	$('#insertphoto').change(function(event) {
		var tmppath = URL.createObjectURL(event.target.files[0]);
		$('#insertimage').attr('src', tmppath);
	});
	$('#couponupdatedelete').on('click', function() {
        $('#coupon_updatemyModal').modal('show');
        $('.coupon-update-modal-body').text("삭제하시겠습니까?");
        $('.coupon_update_modal_btn1').on('click', function() {
            $('#coupon_update_form').attr('action', 'coupondelete');
            $('#coupon_update_form').submit();
        });
    });
});

/* menu_user */
$(document).ready(function(){
	$('.dropdown-item').css("color","#fff");
	/* 버튼이 아이템 위에 있을 때 색 변화 */
	$('.dropdown-item').on('mouseenter', function() {        
	    $(this).css("color","#5861a7");
	});
	$('.dropdown-item').on('mouseleave', function() {        
	    $(this).css("color","#fff");
	});
});	

/* user_info */
/* 게시판 기능 */
$(document).ready( function () {
    $('#table_id').DataTable({
    	responsive: true,
    	searching: false,
    	ordering: false,
    	"pagingType": "simple",
    	"pageLength": 10,
    	"info": false,
    	lengthChange : false,
    	"autoWidth": false,
    });
    $('#row').css( 'display', 'block' );
    $('#btn-user-grade').on('click',function(){    	
    	if($('#user-grade').css('display')=="none") $('#user-grade').css('display','block');
    	else $('#user-grade').css('display','none');
    });
    $('#btn-grade-form').on('click',function(){    	
    	if($('#grade-form').css('display')=="none") $('#grade-form').css('display','block');
    	else $('#grade-form').css('display','none');
    });
    $('#btn-next-grade').on('click',function(){    	
    	if($('#next-grade').css('display')=="none") $('#next-grade').css('display','block');
    	else $('#next-grade').css('display','none');
    });
});

/* user_update_form */
$(document).ready(function(){
	/* 회원 정보 수정시 */
	$('#userinfo-update').on('click',function(){
		if(!$('#user-update-form').parsley().validate()) return;				
		var id= $('#id').val();
		var password = $('#password').val();		
		$.ajax({
			type : 'POST', //전송방식
			data : "id="+id +"&password="+password, //전송 파라미터
			url : "loginCheck", //매핑 값
			success : function(data){ //전송 성공시
				if(data != 1){
					$('.modal').modal('show');
					$('.modal-title').text("수정 실패");
					$('.modal-body').text("비밀번호가 정확하지 않습니다!");
					$('.modal-positive').text("확인");					
				} else{					
					$.ajax({
						type : 'POST', //전송방식
						data : $('#user-update-form').serialize(),
						url : "userInfoUpdate",
						success : function(data){							
							$('.modal').modal('show');
							$('.modal-title').text("수정 성공");
							$('.modal-body').text("회원정보가 수정되었습니다!");
							$('.modal-positive').text("확인");
							$('.modal-positive').on('click',function(){
								$(location).attr('href', "userInfo");
							});							
						},
						error : function(xr,status,error){ //전송 실패시
							alert('ajax error');
						}
					});
				}						
			},
			error : function(xr,status,error){ //전송 실패시
				alert('ajax error');
			}
		});				
	});
});

/* 주문확인 */
$(document).ready(function(){
	$('.requeststate').on('click', function(){
		var state = $(this).text();
		var id = $(this).val();
		$('#myModal').modal('show');
		$('.modal-body').text("배송상태를 변경하시겠습니까?");
		$('#stateupdate').on('click', function() {
			if(state == "입금대기"){
				state = "입금확인";
			}else if(state == "입금확인"){
				state = "배송중";
			}else if(state == "배송중"){
				state = "배송완료";
			}
			var url = "requeststateupdate?state=" + state + "&id=" + id;
			$(location).attr('href', url);
		});
	});
	$('.buyrqbtn').on('click', function(){
		var code = $(this).val();
		$.ajax({
			type : 'POST', //전송방식
			data : "code="+code, //전송 파라미터
			url : "productinfoinsert", //매핑 값
			success : function(data){ //전송 성공시
				$('.brqbookname').html("");
				for(var i=0; i<data.length; i++){
					$('.brqbookname').append("<p>" + data[i].bookname + " (" + data[i].amount + ")" + "</p>");
				}
			},
			error : function(xr,status,error){ //전송 실패시
				alert('ajax error');
			}
		});
	});
	$('#selectbuyrequest').change(function(){
		var select = $("#selectbuyrequest option:selected").val();
		var url = "buyrequestsearch?state=" + select;
		if(select == "목록"){
			url = "buyrequestsearch?state=''"
			$(location).attr('href', 'buyrequestsearch');
		}else if(select == '입금대기'){
			$(location).attr('href', url);
		}else if(select == '입금확인'){
			$(location).attr('href', url);
		}else if(select == '배송중'){
			$(location).attr('href', url);
		}
		
	});
});

/* user_delete_form */
$(document).ready(function(){
	$('#userinfo-delete').on('click',function(){
		$('.modal-positive').show();		
		if(!$('#user-delete-form').parsley().validate()) return;
		if($('#password-confirm').val()!=$('#password').val()){			
			$('.modal').modal('show');
			$('.modal-title').text("비밀번호 확인");
			$('.modal-body').text("비밀번호와 비밀번호 확인이 맞지 않습니다!");
			$('.modal-positive').hide();
			$('.modal-negative').text("확인");			
		} else {
			$('.modal').modal('show');
			$('.modal-title').text("회원 탈퇴");
			$('.modal-body').text("회원탈퇴를 하시겠습니까?");
			$('.modal-positive').text("탈퇴");			
			$('.modal-positive').on('click',function(){
				$('#user-delete-form').submit();			
			});
			$('.modal-negative').text("취소");
			$('.modal-negative').on('click',function(){
				$('input').val("");
				return;
			});
		}		
	});
});


/* user_password_form */
$(document).ready(function(){
	$('#userinfo-password').on('click',function(){
		if(!$('#user-password-form').parsley().validate()) return;
		if($('#password-confirm').val()!=$('#password').val()){			
			$('.modal').modal('show');
			$('.modal-title').text("비밀번호 확인");
			$('.modal-body').text("비밀번호와 비밀번호 확인이 맞지 않습니다!");
			$('.modal-positive').hide();
			$('.modal-negative').text("확인");
			$('input:password').val("");
			return;
		} else if($('#password').val()==$('#new-password').val()){
			$('.modal').modal('show');
			$('.modal-title').text("새 비밀번호 확인");
			$('.modal-body').text("비밀번호와 새 비밀번호가 동일합니다!");
			$('.modal-positive').hide();
			$('.modal-negative').text("확인");
			$('input:password').val("");
			return;
		} else {
			$.ajax({
				type : 'POST', //전송방식
				data : $('#user-password-form').serialize(),
				url : "passwordUpdate",
				success : function(data){
					if(data==1){
						$('.modal').modal('show');
						$('.modal-title').text("비밀번호 변경 성공");
						$('.modal-body').text("비밀번호가 변경되었습니다!");
						$('.modal-positive').hide();
						$('.modal-negative').text("확인");
						$('.modal-negative').on('click',function(){
							$(location).attr('href', "userInfo");
						});
					} else {
						$('.modal').modal('show');
						$('.modal-title').text("비밀번호 변경 실패");
						$('.modal-body').text("아이디와 비밀번호가 맞지 않습니다!");
						$('.modal-positive').hide();
						$('.modal-negative').text("확인");
					}					
				},
				error : function(xr,status,error){ //전송 실패시
					alert('ajax error');
				}
			});
		}
	});
});

/* my_comment_form */
/* 게시판 기능 */
$(document).ready( function () {
    $('#table-id-comment').DataTable({
    	responsive: true,
    	searching: false,  
    	ordering: false,
    	"pagingType": "simple",
    	"pageLength": 10,
    	"info": false,
    	lengthChange : false,    	    	
    	"columns": [
    	    { "width": "30%" },
    	    { "width": "55%" },    	    
    	    { "width": "5%" },
    	    { "width": "5%" },
    	    { "width": "5%" }    	        	    
    	  ],
    });        
});

/* my_review_form */
/* 게시판 기능 */
$(document).ready( function () {
    $('#table-id-review').DataTable({
    	responsive: true,
    	searching: false,
    	ordering: false,
    	"pagingType": "simple",
    	"pageLength": 10,
    	"info": false,
    	lengthChange : false,
    	"columns": [
    	    { "width": "15%" },
    	    { "width": "30%" },    	    
    	    { "width": "30%" },
    	    { "width": "10%" },
    	    { "width": "5%" },    	        	    
    	    { "width": "5%" },    	        	    
    	    { "width": "5%" }    	        	    
    	  ],
    });
    $('.btn-review').on('click',function(){
    	var code= $(this).next().val();
    	$(location).attr('href', "reviewDetailForm?code="+code+"&boardname=reviewboard");
    });
});

/* my_coupon_form */
/* 게시판 기능 */
$(document).ready( function () {
    $('#table-id-coupon-normal').DataTable({
    	responsive: true,
    	searching: false,
    	ordering: false,
    	"pagingType": "simple",
    	"pageLength": 10,
    	"info": false,
    	lengthChange : false,
    	"columns": [
    	    { "width": "20%" },
    	    { "width": "20%" },    	    
    	    { "width": "20%" },
    	    { "width": "20%" },    	     	        	    
    	    { "width": "20%" }    	     	        	    
    	  ],
    }); 
    $('#row-coupon').css( 'display', 'block' );
    $('#table-id-coupon-delivery').DataTable({
    	responsive: true,
    	searching: false,
    	ordering: false,
    	"pagingType": "simple",
    	"pageLength": 10,
    	"info": false,
    	lengthChange : false,
    	"columns": [
    	    { "width": "20%" },
    	    { "width": "20%" },    	    
    	    { "width": "20%" },
    	    { "width": "20%" },	        	    
    	    { "width": "20%" }	        	    
    	  ],
    });    
});

/* my_point_form */
/* 게시판 기능 */
$(document).ready( function () {
    $('#table-id-point').DataTable({
    	responsive: true,
    	searching: false,
    	ordering: false,
    	"pagingType": "simple",
    	"pageLength": 10,
    	"info": false,
    	lengthChange : false,
    	"columns": [
    	    { "width": "20%" },
    	    { "width": "20%" },    	    
    	    { "width": "20%" },
    	    { "width": "20%" },
    	    { "width": "20%" }    	        	    
    	  ],
    });        
});

/*my_used_buy*/
$(document).ready( function () {
	/*게시판 기능*/
    $('#table-id-usedbuy').DataTable({
    	responsive: true,
    	searching: false,
    	ordering: false,
    	"pagingType": "simple",
    	"pageLength": 10,
    	"info": false,
    	lengthChange : false,
    	"columns": [
    	    { "width": "10%" },
    	    { "width": "15%" },    	    
    	    { "width": "30%" },
    	    { "width": "15%" },    	        	        	    
    	    { "width": "15%" },    	        	        	    
    	    { "width": "15%" }    	        	        	    
    	  ],
    });
    /*거래 완료하기*/
    $('.btn-trade-complete').on('click',function(){
    	var code= $(this).next().val();
    	$('.modal').modal('show');
		$('.modal-title').text("거래완료 요청");
		$('.modal-body').text("거래를 완료하시겠습니까?");
		$('.modal-positive').text("확인");
		$('.modal-positive').on('click',function(){
			$(location).attr('href', "myUsedComplete?code="+code);
		});
		$('.modal-negative').text("취소");
		$('.modal-negative').on('click',function(){
			return;
		});    	
    });
    $('#btn-eval').on('click',function(){
    	$(this).parent().parent().next().toggleClass('noneclass');    	
    });
    $('#btn-eval-see').on('click',function(){
    	$(this).parent().parent().next().next().toggleClass('noneclass');;
    });    
});

/*my_used_sell*/
/*게시판 기능*/
$(document).ready( function () {
    $('#table-id-usedsell').DataTable({
    	responsive: true,
    	searching: false,
    	ordering: false,
    	"pagingType": "simple",
    	"pageLength": 10,
    	"info": false,
    	lengthChange : false,
    	"columns": [
    	    { "width": "25%" },
    	    { "width": "25%" },    	    
    	    { "width": "25%" },
    	    { "width": "25%" }    	        	        	    
    	  ],
    });
    $('#btn-used-sell').on('click',function(){
    	$(this).parent().parent().next().toggleClass('noneclass');
    });
});

//숫자 최대길이 체크 함수. 
//input type=number의 onInput 이벤트에 maxLengthCheck(this)로 maxLength 속성과 와 함께 넣어주세요~!
function maxLengthCheck(object){
	   if (object.value.length > object.maxLength){
	    object.value = object.value.slice(0, object.maxLength);
	   }    
  }

//유닉스시간을 일반 날짜로 변환해줍니다
function getTimestamp() {
    var date = new Date();
    var year = date.getFullYear();
    var month = ("0"+(date.getMonth()+1)).substr(-2);
    var day = ("0"+date.getDate()).substr(-2);
    var hour = ("0"+date.getHours()).substr(-2);
    var minutes = ("0"+date.getMinutes()).substr(-2);
    var seconds = ("0"+date.getSeconds()).substr(-2);

    return year+"-"+month+"-"+day+" "+hour+":"+minutes+":"+seconds;
  }

/* my_order_detail */
$(document).ready( function () {
    $('.table_id_orderdetail').DataTable({
    	responsive: true,
    	searching: false,
    	ordering: false,
    	paging: false,
    	"pagingType": "simple",
    	"pageLength": 10,
    	"info": false,
    	lengthChange : false,
    	"autoWidth": false,
    });
    $('#btn-booknames').on('click',function(){
    	$('#booknames-form').toggleClass('noneclass');
    });
    $('#btn-receiver').on('click',function(){
    	$('#receiver-form').toggleClass('noneclass');
    });
    
    $(".btn_orderCancel").on("click", function(){
    	var buyerid = $(this).attr("data-id");
    	var code = $(this).attr("data-code");
    	var del = confirm("주문취소하시겠습니까?");
    	if(del){
        	location.href = "orderCancel?buyerid=" + buyerid + "&code=" + code;
    	}
    });
});

/* main : 베스트셀러 및 신간 선택시 이동 */
$(document).ready( function () { 
	$('.bestseller-pick').on('click', function(){
		var code = $(this).children().first().val();
		$(location).attr('href', "bookDetailPage?bookcode="+code);		
	});
	$('.newbook-pick').on('click', function(){
		var code = $(this).children().first().val();
		$(location).attr('href', "bookDetailPage?bookcode="+code);		
	});
});

/* footer */
$(document).ready( function () { 
	$('#company-inform').on('click', function(){
				
	});	
});

/* 근태관리 실시간 새로고침 */
function autoRefresh_div() {
	var currentLocation = window.location;
	$("#att").load(currentLocation + ' #att');
}
setInterval('autoRefresh_div()', 1000);

