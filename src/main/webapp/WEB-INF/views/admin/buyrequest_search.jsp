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
	<form id="buyrequest_search" name="buyrequest_search" method="post" action="buyrequestsearch">
		<div class="container">
			<div class="row" style="margin-top: 30px">
				<div class="col-md-4"></div>
				<div class="col-md-4" style="text-align: center">
					<h1>주문확인</h1>
				</div>
				<div class="col-md-2"></div>
				<div class="col-md-2">
					<select id="selectbuyrequest" class="form-control">
						<option <c:if test="${state == ''}">selected</c:if>>목록</option>
						<option <c:if test="${state == '입금대기'}">selected</c:if>>입금대기</option>
						<option <c:if test="${state == '입금확인'}">selected</c:if>>입금확인</option>
						<option <c:if test="${state == '배송중'}">selected</c:if>>배송중</option>
					</select>
				</div>
			</div>
			<div class="accordion" id="accordionExample" style="margin-top: 30px; margin-bottom: 30px">
			<c:forEach var="buyrequest" items="${buyrequest}" varStatus="status">
				<div class="card">
				    <div class="card-header" id="headingOne">
				      <h5 class="mb-0 row">
				        <div class="col-md-10">
					        <button class="btn btn-link buyrqbtn" type="button" value="${buyrequest.code}" style="color: #292929" data-toggle="collapse" data-target="#collapse${status.count}" aria-expanded="true" aria-controls="collapseOne">
					          ${buyrequest.receivername}
					        </button>
				        </div>
				        <div class="col-md-2">
				        	<c:choose>
								<c:when test="${buyrequest.state == '배송완료'}">
									<td><button type="button" class="badge badge-pill" value="${buyrequest.buyerid}">${buyrequest.state}</button></td>
								</c:when>
								<c:otherwise>
									<td><button type="button" class="badge badge-pill pri-back requeststate" id="requeststate" value="${buyrequest.buyerid}">${buyrequest.state}</button></td>
								</c:otherwise>
							</c:choose>
				      	</div>
				      </h5>
				    </div>
				
				    <div id="collapse${status.count}" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
				      <div class="card-body">
				      	<table class="table table-bordered">
							<thead class="thead-light" style="text-align: center">
								<tr>
									<th>ID</th>
									<th>받는분</th>
									<th>연락처</th>
									<th>주문날짜</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>${buyrequest.buyerid}</td>
									<td>${buyrequest.receivername}</td>
									<td>${buyrequest.receiverphone}</td>
									<td>${buyrequest.time}</td>
								</tr>
							</tbody>
							<thead class="thead-light" style="text-align: center">
								<tr>
									<th colspan="2">제품 (수량)</th>
									<th>최종금액</th>
									<th>배송상태</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="brqbookname" colspan="2"></td>
									<td>${buyrequest.finalprice} 원</td>
									<td>${buyrequest.state}</td>
								</tr>
							</tbody>
							<thead class="thead-light" style="text-align: center">
								<tr>
									<th colspan="2">주소</th>
									<th>우편번호</th>
									<th>배송완료일</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td colspan="2">${buyrequest.address1} ${buyrequest.address2}</td>
									<td>${buyrequest.postno}</td>
									<td>${buyrequest.completeday}</td>
								</tr>
							</tbody>
						</table>
					  </div>
				    </div>
				</div>
			</c:forEach>
			</div>
			<c:if test="${pagemax != 0}">
			<nav aria-label="Page navigation example" style="margin-bottom:30px">
				<ul class="pagination justify-content-center">
					<c:choose>
						<c:when test="${pagenum != 1}">
							<li class="page-item"><a class="page-link" href="buyrequestpageselected?page=${pagenum-1}&state=${state}"
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
							<li class="page-item active"><a class="page-link" href="buyrequestpageselected?page=${page}&state=${state}">${page}<span class="sr-only">(current)</span></a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item"><a class="page-link" href="buyrequestpageselected?page=${page}&state=${state}">${page}</a></li>
						</c:otherwise>
					</c:choose>
					</c:forEach>
					<c:choose>
						<c:when test="${pagenum != pagemax}">
							<li class="page-item"><a class="page-link" href="buyrequestpageselected?page=${pagenum+1}&state=${state}"
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
							<button type="button" class="btn btn-success modal_btn1" id="stateupdate" data-dismiss="modal">확인</button>
							<button type="button" class="btn btn-success modal_btn2" data-dismiss="modal">취소</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>