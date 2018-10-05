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
	<form id="faq_form" name="faq_form" action="faqAll" method="get">
		<div class="container">
			<div id="adtest" style="margin-top: 30px">
				<div class="row" style="margin-top:30px; margin-bottom:30px; text-align: center">
					<div class="col-md-2"></div>
					<div class="col-md-8 input-group">
					</div>
					<div class="col-md-2">
						<button type="submit" id="faqall" class="btn btn-primary"><i class="fas fa-search"></i> 전체보기</button>
					</div>
				</div>
			</div>
			<div id="faqhead" style="text-align: center">
				<h3>자주묻는질문</h3>
			</div>
			<div class="accordion" id="accordionExample" style="margin-top: 30px; margin-bottom: 30px">
				<c:forEach var="faq" items="${faqs}" varStatus="status">
					<div class="card">
						<div class="card-header" id="headingOne">
							<h5 class="mb-0 row">
								<div>
									<button class="btn btn-link" type="button"
										style="color: #292929" data-toggle="collapse"
										data-target="#collapse${status.count}" aria-expanded="true"
										aria-controls="collapseOne">Q. ${faq.title}</button>
								</div>
							</h5>
						</div>

						<div id="collapse${status.count}" class="collapse"
							aria-labelledby="headingOne" data-parent="#accordionExample">
							<div class="card-body">A. ${faq.content}</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</form>
</body>
</html>