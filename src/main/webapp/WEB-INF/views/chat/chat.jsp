<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CHAT</title>
</head>
<body>

<div class="container container_chat justify-content-center align-items-center">
	<ul class="connected_list_area">
		<li class="chat_room_list col-md-3 col-12 mr-md-4">
			<h5>채팅방 목록</h5>
			<div class="chat_room_name"></div>
		</li>
		
		<li class="chat_user_list col-md-3 col-12 mr-md-4">
			<h5>채팅 참여자 목록</h5>
			<div class="chat_user_id"></div>
		</li>
		
		<li class="all_user_list col-md-3 col-12">
			<h5>모든 접속자 목록</h5>
			<div class="all_user_id"></div>
		</li>
	</ul>
	<div class="join_area">
		<input type="text" class="form-control chat_roomName" placeholder="대기실" maxlength="10">
		<button type="button" class="btn btn_makeChatRoom">채팅방 입장</button>
	</div>
<!-- 	<input type="password" class="form-control chat_roomPw" placeholder="채팅방 비밀번호(미구현)"> -->
	<section class="chat_section">
		<div class="myName"></div>
		<div class="chat_header">
			<div class="current_chatRoom"></div>
		</div>
		<!-- 채팅 내용 -->
		<div id="chatArea">
	
			<div id="chatMessageArea"></div>
	
		</div>
	
		<!-- 채팅 입력창 -->
		<div class="chat_input_area">
			<div class="col-12" style="float: left">
				<textarea class="form-control chat_textarea"
					placeholder="내용을 입력해주세요" id = "message" maxlength="5000"></textarea>
				<span style="float: right; text-align: center;">
					<a id="sendBtn" class="chat_sendBtn">전송</a>
				</span>
			</div>
		</div>
	</section>
	<input type="button" class="btn out_chat" value="채팅 나가기">
	<input type="hidden" class="connection" value="n">
</div>
<script type="text/javascript">

var CONNECT = 0;
var CHAT = 1;
var SYSTEM = 2;
var DISCONNECT = 3;

//페이지 로드 후 접속 지연
var sock;
var chatroom;
var userid = "${userid}";


setTimeout(function(){
	sock = new SockJS("<c:url value="/chat"/>");
	chatroom = "대기실";
	$(".connection").val("y");
	connect();
}, 1000);

//수동으로 채팅방을 입장할 때 실행한다.
function handConnect(roomName){
	if($(".connection").val() == "y"){
		sock.close();
		sendMessage(CONNECT);
		outMessage(message.user_id);
		$(".chat_user_list .chat_user_id").html("");
		alert("이전 접속을 끊고 다른 방에 접속합니다.");
	}
	sock = new SockJS("<c:url value="/chat"/>");
	chatroom = roomName;
	connect();
}

var connectedUsers = new Array();

/* 접속 후 실행되는 function */
function connect() {
    sock.onopen = function() {
    	$(".current_chatRoom").removeClass("disconnect");
    	$(".connection").val("y");
    	sendMessage(CONNECT);
        console.log('open');
        
        sendInterval = setInterval(function(){
        	sendMessage(99);
        }, 5000);
        
    };
    sock.onmessage = function(evt) {
		var data = evt.data;
		console.log("data : " + data);
		
		if(data.length < 16){
			console.log("data : " + data + ", " + data.length);
			if(userid == "익명"){
				userid = data;
				$(".myName").text(data);
			}
			return false;
		} 
		
		var obj = JSON.parse(data);
		/* 메시지를 두개로 나눠 보내게 되어, 
		type을 chat과 system으로 구분해서 chat인 것만 화면에 출력한다. */
		if(obj.protocol == CONNECT){
			//입장메시지 전송
			joinMessage(obj.user_id);
		} else if(obj.protocol == DISCONNECT){
			//퇴장메시지 전송
			outMessage(obj.user_id);
		} else if(obj.protocol == CHAT) {
			//일반 채팅메시지 전송
			appendMessage(obj.user_id, obj.message_content);
		}
		console.log("obj.message_content : " + obj.message_content);
		$("#chatMessageArea").scrollTop(99999);
		if (obj.protocol == SYSTEM){
			//같은 채팅방 접속자
			$(".chat_user_list .chat_user_id").html("");
			$.each(obj.room_users, function(idx, val){
				if(idx == chatroom){
					for(var i=0; i<val.length; i++){
						$(".chat_user_list .chat_user_id").append("<p>" + val[i] + "</p>");
					}
				}
			});
			//채팅방 목록
			$(".chat_room_list .chat_room_name").html("");
			$.each(obj.room_users, function(idx, val){
				$(".chat_room_list .chat_room_name").append("<p><strong>" + idx + "</strong>(" + val.length + ")</p>");
				//현재 채팅방 이름과 인원수를 채팅창 헤더에 표시
				$(".current_chatRoom").html("<strong>" + chatroom + "</strong>" + "(" + $('.chat_user_id p').length + ")");
			});
			//모든 접속자
			$(".all_user_list .all_user_id").html("");
			$.each(obj.user_list, function(idx, val){
				$(".all_user_list .all_user_id").append("<p>" + val + "</p>");
			});
		}
		
    };
    sock.onclose = function() {
    	$(".current_chatRoom").addClass("disconnect").html("<strong>접속이 안 되어있습니다</strong>");
		$(".connection").val("n");
        clearInterval(sendInterval);
    	var search = userid.search("@");
    	if(search < 0){
    		userid = "익명";
    	}
		alert("접속이 종료되었습니다...");
        console.log('close');
    };
}
/* 모든 메시지 전송은 1차로 여기서 처리한다. */
function sendMessage(protocol){
	var msg = $("#message").val();
	message = {};
	message.protocol = protocol;
	message.message_content = $("#message").val();
	message.user_id = userid;
	message.room = chatroom;
	sock.send(JSON.stringify(message));
}
/* 입력 시간을 얻는 function */
function getTimeStamp() {
	var d = new Date();
	var s =
		leadingZeros(d.getFullYear(), 4) + '-' +
		leadingZeros(d.getMonth() + 1, 2) + '-' +
		leadingZeros(d.getDate(), 2) + ' ' +
		leadingZeros(d.getHours(), 2) + ':' +
		leadingZeros(d.getMinutes(), 2) + ':' +
		leadingZeros(d.getSeconds(), 2);
   return s;
}
/* 숫자 앞에 0을 붙여주는 function */
function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();

	if (n.length < digits) {
		for (i = 0; i < digits - n.length; i++)
       zero += '0';
	}
	return zero + n;
}

/* 접속했을 때 전용 메시지 */
function joinMessage(id){
	$("#chatMessageArea").append("<div class='chat_join_message'><b>" + id + "</b>님께서 입장하셨습니다.</div>");
}

/* 퇴장했을 때 전용 메시지 */
function outMessage(id){
	$("#chatMessageArea").append("<div class='chat_join_message'><b>" + id + "</b>님께서 퇴장하셨습니다.</div>");
}

/* 화면에 메시지를 출력 */
function appendMessage(id, msg) {
	if(msg == ''){
		return false;
	} else {
		var t = getTimeStamp();
		if(id == userid){
			$("#chatMessageArea").append("<div class='chat_message_box oneself'><div class='chat_right_box'><div class = 'chat_message_bg'><span class='chat_message'>"+msg+"</span></div><span class='chat_time' >"+t+"</span></div></div>");		 
		} else {
			if(id.indexOf("개구리") > 1){
				$("#chatMessageArea").append("<div class='chat_message_box'><div class='chat_user_profile'><img id='profileImg' class='img-fluid chat_user_image' src='resources/images/sadfrog.jpg'></div><div class='chat_right_box'><div class='chat_user_id special'>" + id + "</div><div class = 'chat_message_bg'><span class='chat_message'>"+msg+"</span></div><span class='chat_time' >"+t+"</span></div></div>");
			} else {
				$("#chatMessageArea").append("<div class='chat_message_box'><div class='chat_user_profile'><img id='profileImg' class='img-fluid chat_user_image' src='resources/images/bono.jpg'></div><div class='chat_right_box'><div class='chat_user_id'>" + id + "</div><div class = 'chat_message_bg'><span class='chat_message'>"+msg+"</span></div><span class='chat_time' >"+t+"</span></div></div>");
			}
			
		}
	}
}

$(document).ready(function() {
	//채팅방 입장 클릭 시
	$(".btn_makeChatRoom").on("click", function(){
		var roomName = $(".chat_roomName").val();
		if($(".connection").val() == "y"){
			if(roomName == "" && $(".current_chatRoom strong").text() == "대기실"){
				alert("이미 참여 중인 방입니다.");
				return false;
			} else if(roomName == $(".current_chatRoom strong").text()){
				alert("이미 참여 중인 방입니다.");
				return false;
			}
		}
		if(roomName == ""){
			roomName = "대기실";
		}
		handConnect(roomName);
	})
	
	//채팅방 목록 클릭 시
	$(".connected_list_area li h5").on("click", function(e){
		e.stopPropagation();
		$(".connected_list_area li h5").not(this).parent().children("div").hide();
		$(this).parent().children("div").toggle();
	});
	
	$(window).on("click", function(){
		$(".connected_list_area li div").hide();
	});
	
	//목록의 채팅방 클릭 시
	$(document).on("click", ".chat_room_name p", function(){
		var roomName = $(this).children("strong").text();
		if(roomName == $(".current_chatRoom strong").text()){
			alert("이미 참여 중인 방입니다.");
			return false;
		}
		handConnect(roomName);
	});
	
	$('#message').keypress(function(event) {
		//입력한 키를 가져온다. ie,chrome에서는 keycode를, firefox에서는 which를 사용한다.
		var keycode = (event.keyCode ? event.keyCode : event.which);
		if (keycode == '13' && $("#message").val() != "") {
			sendMessage(CHAT);
		}
		event.stopPropagation();
	});
	$('#message').on("keyup", function(e){
		var keycode = (e.keyCode ? e.keyCode : e.which);
		if (keycode == '13') {
			$("#message").val("");
		}
		e.stopPropagation();
	})

	$('#sendBtn').click(function() {
		sendMessage(CHAT);
		$("#message").val("");
	});
	
	//채팅 나가기 클릭 시
	$(".out_chat").on("click", function(){
		outMessage(message.user_id);
		$(".connection").val("n");
		sock.close();
		$(".chat_user_list .chat_user_id").html("");
		$(".chat_room_list .chat_room_name").html("");
		$(".all_user_list .all_user_id").html("");
		alert("채팅 서버와 접속이 해제되었습니다.");
	});
	
});

//모바일일 때 채팅 높이 변경
$(document).ready(function(){
	setChatAreaHeight();
	$(window).on("resize", function(){
		setChatAreaHeight();
	});
	
	function setChatAreaHeight(){
		var windowWidth = $(window).outerWidth();
		var windowHeight = $(window).height();
		var headerHeight = $(".chat_header").outerHeight();
		var inputHeight = $(".chat_input_area").outerHeight();
		var gnbHeight = $(".gnb_bar.fixedScroll").outerHeight();
		
		var mobileHeight = windowHeight - headerHeight - inputHeight - gnbHeight;
		
		if(windowWidth < 500){
			$("#chatMessageArea").css("max-height", mobileHeight);
		} else {
			$("#chatMessageArea").css("max-height", 400);
		}
	}
	
});


</script>

</body>
</html>