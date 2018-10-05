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
	<form id="admin_form" name="admin_form" action="admin" method="post">
		<div class="container" style="text-align: center">
			<div id="adtest" style="margin-top: 30px">
				<h1>직원 관리</h1>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<button type="button" class="btn btn-block pri-back"
						onclick="location.href='staffInfoOn'">출퇴근
						정보 입력</button>

				</div>
				<div class="col-sm-6">
					<button type="button" class="btn btn-block pri-back"
						onclick="location.href='staffInfoOff'">출퇴근
						정보 입력 해제</button>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="pri-col">
						<small>출퇴근 RFID 시스템에 정보를 저장합니다.</small>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="pri-col">
						<small>출퇴근 RFID 시스템을 해제합니다.</small>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>