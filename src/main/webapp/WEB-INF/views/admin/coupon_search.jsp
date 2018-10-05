<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form id="coupon_search_form" name="coupon_search_form">
		<div class="container" style="text-align: center">
			<button type="button" style="margin-top: 30px" class="btn btn-info btn-block" onclick="location.href='couponinsertform'">쿠폰등록</button>
			<div class="row" style="margin-top: 30px">
				<c:forEach var="coupons" items="${coupons}" varStatus="status">
				<div class="col-md-3 mb-4">
					<div class="card h-100">
						<a href="couponupdateform?code=${coupons.code}"><img src="resources/images/coupon/${coupons.code}.png" width="100%" height="150px"></a>
						<div class="card-footer" style="text-align: center; height: 100%">
						${coupons.name}<p></p>
						<a href="couponupdateform?code=${coupons.code}" class="btn btn-info">수정</a> <a href="coupondelete?code=${coupons.code}"
							class="btn btn-info" id="coupondelete">삭제</a>
						</div>
					</div>
				</div>
				</c:forEach>
			</div>
			<c:if test="${pagemax != 0}">
			<nav aria-label="Page navigation example" style="margin-top:30px; margin-bottom:30px">
				<ul class="pagination justify-content-center">
					<c:choose>
						<c:when test="${pagenum != 1}">
							<li class="page-item"><a class="page-link" href="couponpageselected?page=${pagenum-1}"
								><span aria-hidden="true">&laquo;</span></a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item disabled"><a class="page-link" href="#"
								><span aria-hidden="true">&laquo;</span></a></li>
						</c:otherwise>
					</c:choose>
					<c:forEach var="page" items="${pages}">
					<c:choose>
						<c:when test="${page == pagenum}">
							<li class="page-item active"><a class="page-link" href="couponpageselected?page=${page}">${page}<span class="sr-only">(current)</span></a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item"><a class="page-link" href="couponpageselected?page=${page}">${page}</a></li>
						</c:otherwise>
					</c:choose>
					</c:forEach>
					<c:choose>
						<c:when test="${pagenum != pagemax}">
							<li class="page-item"><a class="page-link" href="couponpageselected?page=${pagenum+1}"
								><span aria-hidden="true">&raquo;</span></a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item disabled"><a class="page-link" href="#"><span aria-hidden="true">&raquo;</span></a></li>
						</c:otherwise>
					</c:choose>
				</ul>
			</nav>
			</c:if>
			<!-- Modal -->
			<div id="coupon_searchmyModal" class="modal fade" role="dialog">
				<div class="modal-dialog">

					<!-- Modal content-->
					<div class="modal-content">
						<div class="modal-header" style="background-color: #9999cc">
							쿠폰 삭제
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h4 class="modal-title"></h4>
						</div>
						<div class="coupon-search-modal-body">
						</div>
						<div class="modal-footer">
							<button type="button"
								class="btn btn-success coupon_search_modal_btn1"
								data-dismiss="modal">확인</button>
							<button type="button"
								class="btn btn-success coupon_search_modal_btn2"
								data-dismiss="modal">취소</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>