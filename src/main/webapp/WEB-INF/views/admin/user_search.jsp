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
	<form id="user_search" name="user_search" method="get" action="usersearch">
		<div class="container">
			<div class="row" style="margin-top: 30px">
				<div class="col-md-4"></div>
				<div class="col-md-4" style="text-align: center">
					<h1>회원목록</h1>
				</div>
				<div class="col-md-4"></div>
			</div>
			<div class="accordion" id="accordionExample" style="margin-top: 30px">
			<c:forEach var="user" items="${users}" varStatus="status">
				<div class="card">
				    <div class="card-header" id="headingOne">
				      <h5 class="mb-0 row">
				        <div class="col-md-11">
				        <button class="btn btn-link" type="button" style="color: #292929" data-toggle="collapse" data-target="#collapse${status.count}" aria-expanded="true" aria-controls="collapseOne">
				          ${user.id}
				        </button>
				        </div>
				        <div class="col-md-1">
				        <a href="userupdateform?id=${user.id}"
								class="btn btn-info" id="userupdate">수정</a>
				      	</div>
				      </h5>
				    </div>
				
				    <div id="collapse${status.count}" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
				      <div class="card-body">
				      <table class="table table-bordered">
							<thead class="thead-light" style="text-align: center">
								<tr>
									<th>ID</th>
									<th>이름</th>
									<th>닉네임</th>
									<th>연락처</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>${user.id}</td>
									<td>${user.name}</td>
									<td>${user.nickname}</td>
									<td>${user.phone1}-${user.phone2}-${user.phone3}</td>
								</tr>
							</tbody>
							<thead class="thead-light" style="text-align: center">
								<tr>
									<th>환불계좌</th>
									<th>환불은행</th>
									<th>등급</th>
									<th>포인트</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>${user.returnfinance}</td>
									<td>${user.returnbank}</td>
									<td>${user.grade}</td>
									<td>${user.point}</td>
								</tr>
							</tbody>
							<thead class="thead-light" style="text-align: center">
								<tr>
									<th colspan="2">가입날짜</th>
									<th colspan="2">접속날짜</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td colspan="2">${user.jointime}</td>
									<td colspan="2">${user.connecttime}</td>
								</tr>
							</tbody>
						</table>
				      </div>
				    </div>
				</div>
			</c:forEach>
			</div>
			<c:if test="${pagemax != 0}">
			<nav aria-label="Page navigation example" style="margin-top:30px">
				<ul class="pagination justify-content-center">
					<c:choose>
						<c:when test="${pagenum != 1}">
							<li class="page-item"><a class="page-link" href="userpageselected?page=${pagenum-1}"
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
							<li class="page-item active"><a class="page-link" href="userpageselected?page=${page}">${page}<span class="sr-only">(current)</span></a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item"><a class="page-link" href="userpageselected?page=${page}">${page}</a></li>
						</c:otherwise>
					</c:choose>
					</c:forEach>
					<c:choose>
						<c:when test="${pagenum != pagemax}">
							<li class="page-item"><a class="page-link" href="userpageselected?page=${pagenum+1}"
								><span aria-hidden="true">&raquo;</span></a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item disabled"><a class="page-link" href="#"><span aria-hidden="true">&raquo;</span></a></li>
						</c:otherwise>
					</c:choose>
				</ul>
			</nav>
			</c:if>
			<div class="row" style="margin-top:30px; margin-bottom:30px; text-align: center">
				<div class="col-md-3"></div>
				<div class="col-md-6 input-group">
					<input type="text" id="search" name="find" class="form-control" placeholder="아이디 or 이름 or 닉네임 입력">
					<button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> 검색</button>
				</div>
				<div class="col-md-3"></div>
			</div>
		</div>
	</form>
</body>
</html>