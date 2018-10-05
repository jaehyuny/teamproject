<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div style="margin-top: 50px"></div>	
	<form style="width: 70%; margin: 0 auto;">
		<div>
			<c:if test="${flag==1}">
				<div style="text-align: center;">
					<h4>회원 탈퇴하였습니다.</h4>
					<h6 style="margin-bottom: 30px">* 그 동안 사용하여 주셔서 감사합니다.</h6>
					<button type="button" class="btn btn-danger" id="return-home"
						style="margin-bottom: 30px"
						onclick="location.href='mainPage'">홈으로</button>
				</div>
			</c:if>
			<c:if test="${flag==0}">
				<div style="text-align: center;">
					<h4>회원 탈퇴 실패하였습니다.</h4>
					<h6 style="margin-bottom: 30px">* 아이디와 패스워드가 일치하지 않습니다.</h6>
					<button type="button" class="btn btn-danger" id="return-delete"
						style="margin-bottom: 30px"
						onclick="location.href='userInfoDelForm'">돌아가기</button>
				</div>
			</c:if>
		</div>
	</form>
</body>
</html>