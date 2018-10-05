<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>중고장터</title>
<style>
		#main{
			font-family:'notosans';
			font-weight: bold;
			color: #3c3c3c;
		}
		.hidden{
			display:none;
		}
		.closed{
			height:0px !important;
		}
		.listcard{
			margin: 10px;
		}
		#addSell-booknameinfo{
			transition: all 500ms cubic-bezier(0.000, 0.575, 0.000, 0.995);
			transform:scale(0.9);
			opacity: 0;
			position: absolute;
			margin-top:45px;
			background-color: #374390cc;
			font-size: 15px;
			padding: 10px;
			color: white;
			z-index: 30;
		}
		#addSell-bookname{
		
		}
		#addSell-bookname:hover+#addSell-booknameinfo{
			transform:scale(1);
			opacity:1;
		}
		
		.addUsedBookSell{
			transition: transform 500ms cubic-bezier(0.000, 0.575, 0.000, 0.995);
			height:0px;
			max-height:0px;
			transform:scaleY(0.8);
		}
		.addUsedBookSell-clicked{
			transform:scaleY(1);
			height:auto;
			max-height:1000px;
			display: block;
		}
		.usedBookSearch{
			transition: transform 500ms cubic-bezier(0.000, 0.575, 0.000, 0.995);
			height:0px;
			max-height:0px;
			transform:scaleX(0.9);
			overflow: hidden;
		}
		.usedBookSearch-clicked{
			transform:scaleX(1);
			height:auto;
			max-height:1000px;
			display: block;
		}

</style>
<script>
		var usedBookSearchState=0;
		var addusedbooksellstate=0;
		var addUsedBookSellState=0;

			$(document).ready(function(){

				$('#book-sell-openformbutton').on('click',function(){
					if(addUsedBookSellState==0){
						$('.addUsedBookSell').addClass('addUsedBookSell-clicked')
						addUsedBookSellState=1;
					}else{
						$('.addUsedBookSell').removeClass('addUsedBookSell-clicked')
						addUsedBookSellState=0;
					}
				});

				$('#book-sell-checkbutton').on('click',function(){
						if($('#addSell-bookname').val()==""){
						alert("이름을 입력해야합니다!");
						return;
					}
					$('#book-sell-checked').val("y");
					$('#addSell-bookname').prop("readonly","true");
				});

				$('#book-sell-searchbutton').on('click',function(){
					if($('#addSell-bookname').val()==""){
						alert("검색어를 입력해야합니다!");
						return;
					}
					if(usedBookSearchState==0 && $('#book-sell-checked').val()=='n'){
					$('.usedBookSearch').addClass('usedBookSearch-clicked')
					usedBookSearchState=1;
					}
					//ajax 검색코드
					$.ajax({
						type : 'POST',
						data : "name="+$('#addSell-bookname').val(),
						datatype : 'json',
						url : "searchByBookName",
						success : function(data){
							//통신 성공시 실행할 내용
							var selectHtmlText = "";
							for(var i=0; i<data.length; i++){
								selectHtmlText += "<option value='"+data[i].name+"' code='"+data[i].code+"'>"+data[i].name+" "+data[i].publisher+"</option>";
							}
								$('#search-select').html(selectHtmlText);
						},
						error : function(xr,status,error){
							//통신 실패시 실행할 내용
						}
					});
				});


				$('#search-select').on('change',function(){
					if($('#book-sell-checked').val()=='y'){
						return;
					}
					var selectedBookCode = $("#search-select option:selected").attr("code");				
					var selectedBookName = $('#search-select option:selected').val();
					$('#book-sell-bookcode').val(selectedBookCode);
					$('#addSell-bookname').val(selectedBookName);
					$('#addSell-bookname').css("color","#399fff");
				});
				
				$('#addSell-bookname').on('keydown',function(){
					if($('#book-sell-checked').val()=='y'){
						return;
					}
					$('#book-sell-bookcode').val(999999999);
					$('#addSell-bookname').css("color","#000000");
				})
				
				$('#book-sell-submitbutton').on('click',function(){
					if($('#book-sell-checked').val()=='n'){
						alert("책 이름 옆에 체크표시를 눌러주세요!");
						return;
					}
					if(${sessionid==null}){
						alert("로그인 해야 합니다!");
						return;
					}
					document.getElementById('submit-add-used-sell').click();
				});
			});
			function buyImmediate(usedsellcode){
				var amount = $('#usedsell-buyamount-'+usedsellcode+' option:selected').val();
				if(${sessionid==null}){
					alert('로그인을 해야합니다.');
					return;
				}
				location.href="buyUsedBookImmediate?usedsellcode="+usedsellcode+"&amount="+amount;
			}
			
			function generateAdditionalBookTag(code, name,price){
				var htmltext = "";
				htmltext += "<div class=\"otherbooklistelement\" style=\"padding:5px\">";
				htmltext += "<button class=\"btn btn-primary btn-sm\" onclick=\"addUsedBasket("+code+",0)\">+</button>"
				htmltext += "<span style=\"font: 10px\"> "+name+" / "+price+"원</span>"
				htmltext += "</div>"
				return htmltext;
			}
	
			function toggleRelatedSell(sellerid,code){
				if($('.otherbookform'+code).attr('toggled')==0){
					var htmltext = "";
					$.ajax({
						type : 'POST',
						data : "sellerid="+sellerid,
						datatype : 'json',
						url : "usedSellRelatedSeller",
						success : function(data){
							//통신 성공시 실행할 내용
							for(var i=0; i<data.length; i++){
								htmltext += generateAdditionalBookTag(data[i].code,data[i].bookname,data[i].price);
							}
							$(".otherbook"+code).html(htmltext);
						},
						error : function(xr,status,error){
							//통신 실패시 실행할 내용
							alert('ajax error');
						}
					});
					$('.otherbookform'+code).removeClass('closed');
					$('.otherbookform'+code).attr('toggled',1);
				}else{
					$('.otherbookform'+code).addClass('closed');
					$('.otherbookform'+code).attr('toggled',0);
				}
			}
			
			
			function addUsedBasket(usedsellcode){
				var amount = $('#usedsell-buyamount-'+usedsellcode+' option:selected').val();
				if(${sessionid==null}){
					alert('로그인을 해야합니다.');
					return;
				}

				$.ajax({
					type : 'POST',
					data : 'usedsellcode='+usedsellcode+'&amount='+amount,
					datatype : 'json',
					url : "addUsedBasket",
					success : function(data){
						if(data=='duplicate'){
							alert('이미 장바구니에 등록되어있습니다.');
						}else if(data=='selfbuy'){
							alert('자신의 책을 구입할 수 없습니다.');
						}else{
							alert('중고 장바구니에 등록되었습니다.');
						}
					},
					error : function(xr,status,error){
						//통신 실패시 실행할 내용
						alert('ajax error');
					}
				});
			}
</script>
</head>
<body>
	<!-- body container -->
	<div class="container">
		<h1>중고장터</h1>
		<button class="btn btn-primary" id="book-sell-openformbutton" style="margin-bottom: 10px">나의 책 등록하기</button>
	</div>
	<!-- 중고책 등록 폼 -->
	<div class="container addUsedBookSell">
		<hr>
		<input type="hidden"  id="book-sell-checked" value="n"/>
		<form action="addUsedBookSell" method="post">
		<input type="hidden"  name="bookcode" id="book-sell-bookcode" value="${book.code }"/>
		 <div class="form-group">
			<label>책 이름</label>
			<div style="display: flex;">
			<input style="flex: auto;" required type="text" name="bookname"  id="addSell-bookname" class="form-control" value="${book.name }" placeholder="판매할 책의 이름을 작성해주세요.">
			<div id="addSell-booknameinfo">
				책 이름을 검색해서 선택할 수 있고, 책이 없으면 그냥 등록할 수 있습니다.
				<br>주의 : 그냥 등록하면 해당 책의 중고거래 페이지에서 판매 게시글이 노출되지 않게됩니다!
			</div>
			<button class="btn btn-secondary" id="book-sell-searchbutton" style="margin-left: 10px;" type="button">
				<img src="resources/images/icons/search.png" width="25px" height="25px">
			</button>
			<button class="btn btn-primary" id="book-sell-checkbutton" style="margin-left: 10px;" type="button">
				<img src="resources/images/icons/check.png" width="25px" height="25px">
			</button>
			</div>
		  </div>
		  <div class="form-group usedBookSearch">
			<label >검색</label>
			<select multiple class="form-control" id="search-select">
			</select>
		  </div>
		  <div class="form-group">
			<label>설명</label>
			<textarea required name="discription" class="form-control" rows="5" placeholder="책의 상태 및 거래가능 시간 등을 기재해주세요."></textarea>	
		</div>
		 <div class="form-group">
			<label>1권당 가격</label>
			<input maxlength="7" oninput="maxLengthCheck(this)" name="price" class="form-control" type="number" value="10000" required />
			<label>수량</label>
			<input maxlength="2" oninput="maxLengthCheck(this)" name="stock" class="form-control" type="number" value="1" required />
		</div>
		<div style="text-align: right">
			<button class="btn btn-primary" id="book-sell-submitbutton" type="button" style="margin-bottom: 10px">등록</button>
			<button type="submit" id="submit-add-used-sell" width="0px" height="0px"></button>
		</div>
		</form>
		<hr>
	</div>
			<!--  네비게이션 -->
		<div class="container">
			<h4>구매하기</h4>
			<ul class="nav nav-tabs">
				<li class="nav-item"><a class="nav-link ${mode==0?"active":"" }" href="usedMainPage">구매가능</a></li>
				<li class="nav-item"><a class="nav-link ${mode==1?"active":"" }" href="usedMainPage?mode=전체보기">전체보기
						</a></li>
			</ul>
		</div>
		
		<!-- 게시글 리스트 -->
		<div class="container">
			<!-- 게시글 -->
			<c:forEach items="${usedsell }" var="one">
			<div class="listcard">
				<img src="resources/images/bono.jpg" class="rounded-circle"
					style="float: left;" width="55px" height="55px"> <span
					style="font-size: 20px; float: right;">${one.state }</span> <span
					style="font-size: 20px">${one.sellerid }</span> <span style="font-size: 15px">${one.time }
					</span>
				<div>구매자 평점 :${one.averagescore }점, 구매 : ${one.buycount }회, 판매 : ${one.sellcount }회</div>
				<div style="clear: both; padding: 10px;">
				<div style="font-size: 20px">
				<c:if test="${one.bookcode != 0}"><a href="bookDetailPage?bookcode=${one.bookcode}"></c:if>
				${one.bookname }
				<c:if test="${one.bookcode != 0}"></a></c:if>
				</div>
				${one.discription }
				</div>
				<span style="font-size: 15px; float: right;">재고: ${one.stock }권, 
				 <span style="font-size: 25px"><span class="numeric" data-numeric="${one.price }"></span>원</span>
				</span>
				<div style="clear: both;">
					<span style="float: left">
						<button class="btn btn-secondary" onclick="toggleRelatedSell('${one.sellerid}',${one.code})">이 판매자의 다른 책 보기</button>
						<button class="btn btn-secondary">판매자 상세보기</button>
					</span> 
					<span style="float: right">
						<c:if test="${one.state =='판매중'}">
						<select class="form-control" style="display: inline-block; width:auto; vertical-align: middle;" id="usedsell-buyamount-${one.code }">
							<c:forEach var="two" begin="1" end="${one.stock }" step="1">
							<option value="${two }">${two}</option>
							</c:forEach>
						</select>
						<button class="btn btn-primary" onclick="buyImmediate(${one.code})">구매하기</button>
						<button class="btn btn-primary" onclick="addUsedBasket(${one.code},1)">장바구니</button>
						</c:if>
					</span>
				</div>
			</div>
			<hr style="clear: both; margin-top: 46px">
			<!-- 이 구매자의 다른 책 보기 -->
			<div class="otherbookform${one.code } closed" toggled="0" style="
			overflow:hidden;
			transition: all 500ms cubic-bezier(0.000, 0.575, 0.000, 0.995);
			height:280px;
			">
				<h4>이 판매자가 판매중인 책</h4>
				<h6>같은 판매자의 상품을 주문하면 배송비를 절약할 수 있습니다.</h6>
				<div class="otherbook${one.code}" style="height:200px; overflow-y: scroll;">
				</div>
			</div>
			</c:forEach>
		</div>
</body>
</html>