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
	<form id="author_search" name="author_search" method="get" action="authorsearch">
		<div class="container">
			<button type="button" style="margin-top: 30px; margin-bottom: 30px" class="btn btn-info btn-block" onclick="location.href='authorinsertform'">저자등록</button>
			<div class="accordion" id="accordionExample">
			<c:forEach var="authors" items="${authors}" varStatus="status">
				<div class="card">
				    <div class="card-header" id="headingOne">
				      <h5 class="mb-0 row">
				        <div class="col-md-10">
					        <button class="btn btn-link" type="button" style="color: #292929" data-toggle="collapse" data-target="#collapse${status.count}" aria-expanded="true" aria-controls="collapseOne">
					          ${authors.name}
					        </button>
				        </div>
				        <div class="col-md-1">
				        	<a href="authorupdateform?code=${authors.code}"
								class="btn btn-info" id="authorupdate">수정</a>
				      	</div>
				      	<div class="col-md-1">
				        	<a href="authordelete?code=${authors.code}"
								class="btn btn-info" id="authordelete">삭제</a>
				      	</div>
				      </h5>
				    </div>
				
				    <div id="collapse${status.count}" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
				      <div class="card-body row">
					      <div class="col-md-2">
						      <img src="resources/images/author/${authors.code}.jpg" width="120px" height="160px">
					      </div>
					      <div class="col-md-10">
					      	${authors.discription}
					      </div>
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
							<li class="page-item"><a class="page-link" href="authorpageselected?page=${pagenum-1}"
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
							<li class="page-item active"><a class="page-link" href="authorpageselected?page=${page}">${page}<span class="sr-only">(current)</span></a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item"><a class="page-link" href="authorpageselected?page=${page}">${page}</a></li>
						</c:otherwise>
					</c:choose>
					</c:forEach>
					<c:choose>
						<c:when test="${pagenum != pagemax}">
							<li class="page-item"><a class="page-link" href="authorpageselected?page=${pagenum+1}"
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
					<input type="text" id="search" name="find" class="form-control" placeholder="이름 or 코드 입력">
					<button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> 검색</button>
				</div>
				<div class="col-md-3"></div>
			</div>
		</div>
	</form>
</body>
</html>