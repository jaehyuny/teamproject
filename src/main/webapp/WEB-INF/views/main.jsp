<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main body</title>
</head>
<body>
	<div style="display: none;" data-login="${notLogin}" class="not_login"></div>
	<div class="container">
		<section class="row event_area">

			<div class="swiper-container main_slider col-md-6 col-12">
				<!-- Additional required wrapper -->
				<div class="swiper-wrapper">
					<!-- Slides -->
					<div class="swiper-slide">
						<a href="eventContent?code=7&boardname=event"><img src="resources/images/event/main_event1.png"></a>
					</div>
					<div class="swiper-slide">
						<a href="eventContent?code=6&boardname=event"><img src="resources/images/event/main_event2.png"></a>
					</div>
					<div class="swiper-slide">
						<a href="eventContent?code=5&boardname=event"><img src="resources/images/event/main_event3.png"></a>
					</div>
				</div>
				<!-- If we need pagination -->
				<div class="swiper-pagination"></div>

				<!-- If we need navigation buttons -->
				<div class="swiper-button-prev"></div>
				<div class="swiper-button-next"></div>

			</div>
			<div class="event_list col-md-5 col-12">
				<c:forEach items="${boards}" var="board">
					<li><a href="reviewDetailForm?code=${board.code}&boardname=reviewboard">${board.title}</a></li>
				</c:forEach>
			</div>

		</section>

		<section class="row main_book_area best_book_area">
			<h4>베스트셀러</h4>
			<ul>
				</li>
				<c:forEach items="${bestsellers}" var="bestseller">
					<li class="col-md-2 col-5 ml-4"><a href="#"
						class="bestseller-pick"><input type="hidden"
							value="${bestseller.code}"><img
							src="resources/images/books/${bestseller.code}.jpg"></a>
						<ul class="prev_info">
							<li><b>${bestseller.bookname}</b></li>
							<li><span class="prev_writer">${bestseller.authorname}</span><span
								class="prev_publish">${bestseller.publisher}</span></li>
							<li class="price_color">${bestseller.realprice}원</li>
						</ul></li>
				</c:forEach>
			</ul>
		</section>

		<section class="row main_book_area new_book_area">
			<h4>신간</h4>
			<ul>
				<c:forEach items="${newbooks}" var="newbook">
					<li class="col-md-2 col-5 ml-4"><a href="#"
						class="newbook-pick"><input type="hidden"
							value="${newbook.code}"><img
							src="resources/images/books/${newbook.code}.jpg"></a>
						<ul class="prev_info">
							<li><b>${newbook.name}</b></li>
							<li><span class="prev_writer">${newbook.authorname}</span><span
								class="prev_publish">${newbook.publisher}</span></li>
							<li class="price_color">${newbook.realprice}원</li>
						</ul></li>
				</c:forEach>
			</ul>
		</section>

	</div>



	<script>
		var mySwiper = new Swiper('.swiper-container', {
			// Optional parameters
			direction : 'horizontal',
			loop : true,

			// If we need pagination
			pagination : {
				el : '.swiper-pagination',
			},

			// Navigation arrows
			navigation : {
				nextEl : '.swiper-button-next',
				prevEl : '.swiper-button-prev',
			},

			// And if we need scrollbar
			scrollbar : {},

			autoplay : {
				delay : 2000,
			}
		})
	</script>

</body>
</html>