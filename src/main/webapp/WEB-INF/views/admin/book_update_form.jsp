<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style>
	.noresize {
	  resize: none; /* 사용자 임의 변경 불가 */
	}
</style>
</head>
<body>
	<form id="book_update_form" name="book_update_form" method="post" action="bookupdate" data-parsley-validate="true" enctype="multipart/form-data">
		<input type="hidden" id="confirm_yn" value="n">
		<input type="hidden" id="code" name="code" value="${books.code}" class="form-control">
		<div class="container">
			<div class="row" style="margin-top: 30px">
				<div class="col-md-4"></div>
				<div class="col-md-4" style="text-align: center">
				<a href=#><img id="insertimage" src="resources/images/books/${books.code}.jpg" title="클릭 후 이미지 변경" alt="클릭 후 이미지 변경" width="150px" height="200px"></a>
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
			<div class="row" style="margin-top: 30px">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 저자</span>
					</div>
					<select id="authorcode" name="authorcode" class="form-control">
						<c:forEach var="authors" items="${authors}">
							<option value="${authors.code}" <c:if test="${authors.code == books.authorcode}">selected</c:if>>${authors.name}</option>
						</c:forEach>
					</select>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 이름</span>
					</div>
					<input type="text" id="name" name="name" value="${books.name}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 정가</span>
					</div>
					<input type="text" id="price" name="price" value="${books.price}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 판매가</span>
					</div>
					<input type="text" id="realprice" name="realprice" value="${books.realprice}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 재고</span>
					</div>
					<input type="text" id="stock" name="stock" value="${books.stock}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 출판사</span>
					</div>
					<input type="text" id="publisher" name="publisher" value="${books.publisher}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 분류</span>
					</div>
					<select id="cat1" name="cat1" class="form-control">
						<c:forEach var="categorys" items="${categorys}" varStatus="status">
							<option value="${categorys.name}" <c:if test="${categorys.name == books.cat1}">selected</c:if>>${categorys.name}</option>
						</c:forEach>
					</select>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 출간년월일</span>
					</div>
					<input type="text" id="publishyear" name="publishyear" value="${books.publishyear}" class="form-control">
					<input type="text" id="publishmonth" name="publishmonth" value="${books.publishmonth}" class="form-control">
					<input type="text" id="publishday" name="publishday" value="${books.publishday}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 판본</span>
					</div>
					<input type="text" id="booktype" name="booktype" value="${books.booktype}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 페이지수</span>
					</div>
					<input type="text" id="pagenumber" name="pagenumber" value="${books.pagenumber}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 크기</span>
					</div>
					<input type="text" id="scale" name="scale" value="${books.scale}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> isbn</span>
					</div>
					<input type="text" id="isbn" name="isbn" value="${books.isbn}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px; height: 200px"> 소개</span>
					</div>
					<textarea class="form-control noresize" id="discription" name="discription">${books.discription}</textarea>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px; height: 200px"> 목차</span>
					</div>
					<textarea class="form-control noresize" id="contentlist" name="contentlist">${books.contentlist}</textarea>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px; height: 200px"> 출판사서평</span>
					</div>
					<textarea class="form-control noresize" id="sellerdiscription" name="sellerdiscription">${books.sellerdiscription}</textarea>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px; height: 200px"> 맛보기텍스트</span>
					</div>
					<textarea class="form-control noresize" id="splashtext" name="splashtext">${books.splashtext}</textarea>
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 트레일러</span>
					</div>
					<input type="text" id="trailer" name="trailer" value="${books.trailer}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 평균점수</span>
					</div>
					<input type="text" id="averagescore" name="averagescore" value="${books.averagescore}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row">
				<div class="col-md-3"></div>
				<div class="input-group mb-3 col-md-6 ">
					<div class="input-group-prepend">
						<span class="input-group-text" style="width: 150px"> 평가자수</span>
					</div>
					<input type="text" id="evaluaternum" name="evaluaternum" value="${books.evaluaternum}" class="form-control">
				</div>
				<div class="col-md-3"></div>
			</div>
			<div class="row" style="margin-top: 30px; margin-bottom:30px">
				<div class="col-md-4"></div>
				<div class="col-md-2" style="text-align: center">
					<button type="submit" id="booksave" class="btn pri-back btn-block save">확인</button>
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