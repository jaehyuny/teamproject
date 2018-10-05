package com.team.project.websocket;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.team.project.submodule.ChatNicknames;


public class ChatWebSocketHandler_backup extends TextWebSocketHandler {
	
	@Inject
	private ChatNicknames chatNicknames;
	
	
	private List<WebSocketSession> connectedUsers;
	private HashMap<WebSocketSession, String> chatroom;
	private static Logger logger = LoggerFactory.getLogger(ChatWebSocketHandler_backup.class);
	
	JSONArray jsonUsers = new JSONArray();
	HashMap<String, String> roomUsers = new HashMap<>();
	JSONObject jsonRoom = new JSONObject();
	JSONObject jsonObject = new JSONObject();
	
	
	public ChatWebSocketHandler_backup() {
		connectedUsers = new ArrayList<WebSocketSession>();
		chatroom = new HashMap<>();
	}
	

	//접속에 성공했을 때 작동
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		boolean addressCheck = true;
		for(WebSocketSession websession:connectedUsers) {
			//접속한 session의 ip를 확인해서 동일할 시 접속을 해제한다.
			if(websession.getRemoteAddress().getHostName().equals(session.getRemoteAddress().getHostName())) {
				logger.info("동일 ip에서 접속했습니다. 접속을 끊습니다.");
				session.close();
				addressCheck = false;
				break;
			}
		}
		if(addressCheck) {
			connectedUsers.add(session);
			logger.info("입장 : " + session.getId());
			logger.info("웹소켓 LocalAddress : " + session.getLocalAddress());
			logger.info("웹소켓 RemoteAddress HostName : " + session.getRemoteAddress().getHostName());
			logger.info("웹소켓 Uri : " + session.getUri());
			logger.info("웹소켓 Principal : " + session.getPrincipal());
		}
		
		logger.info("얄리얄리얄랑셩 얄라리얄라");
		
//		super.afterConnectionEstablished(session);
	}
	
	//메시지를 전송받았을 때 작동
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

		JSONParser jsonParser = new JSONParser();
		jsonObject = (JSONObject) jsonParser.parse(message.getPayload());
		/* 전송받았을 때 type
		 * system : 입장, 퇴장 메시지
		 * chat : 일반 채팅 메시지*/
		String messageType = (String) jsonObject.get("type");
		/* 전송할 때 type
		 * system : 채팅방과 그 방에 소속된 접속자 목록, 전체 접속자 목록 등 채팅창에 띄우지 않을 정보
		 * chat : 채팅창에 띄울 모든 메시지*/
		JSONObject jsonSystemMessage = handleSystemMessage(session, message);
		JSONObject jsonChatMessage = handleChatMessage(session, message);
		
		/* 전송받은 메시지가 system 타입일 경우 모든 세션에 system 메시지를,
		 * 같은 채팅방의 세션에 chat 메시지를 전송한다. */
		if(messageType.equals("system")) {
			/* type으로 전송할 시스템 메시지와 채팅 메시지를 다시 구분한다.
			 * view로부터 받을 때는 입장·퇴장 메시지가 system에 포함되어 있지만, 
			 * view로 보낼 때는 chat에 포함되기 때문이다. */
			jsonSystemMessage.put("type", "system");
			jsonChatMessage.put("type", "chat");
			//랜덤으로 닉네임을 받았을 경우를 생각해, 시스템메시지에 있는 유저아이디를 가져온다.
			if(jsonSystemMessage.get("user_id") != null) {
				jsonChatMessage.put("user_id", jsonSystemMessage.get("user_id"));
			}
			//connectedUsers에 등록된 모든 세션에게 메시지를 보낸다.
			for(WebSocketSession sess:connectedUsers) {
				sess.sendMessage(new TextMessage(jsonSystemMessage.toString()));
			}
			
			//같은 채팅방에 있는 세션에게만 메시지를 보낸다.
			for(WebSocketSession sess:chatroom.keySet()) {
				if(chatroom.get(sess).equals(jsonChatMessage.get("room").toString())) {
					sess.sendMessage(new TextMessage(jsonChatMessage.toString()));
				}
			}
		} else if (messageType.equals("chat")) {
			//type으로 전송할 시스템 메시지와 채팅 메시지를 다시 구분한다.
			jsonSystemMessage.put("type", "system");
			jsonChatMessage.put("type", "chat");
			//같은 채팅방에 있는 세션에게만 메시지를 보낸다.
			for(WebSocketSession sess:chatroom.keySet()) {
				if(chatroom.get(sess).equals(jsonChatMessage.get("room").toString())) {
					sess.sendMessage(new TextMessage(jsonChatMessage.toString()));
				}
			}
		}
		
		
		
//		super.handleTextMessage(session, message);
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// TODO Auto-generated method stub
//		super.handleTransportError(session, exception);
	}

	//접속을 끊었을 때 작동
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		logger.info("close session : " + session);
		logger.info("close status : " + status);
		
		connectedUsers.remove(session);
		
//		super.afterConnectionClosed(session, status);
	}
	
	/** 시스템 메시지 및 채팅방, 유저 목록 등을 설정하는 메소드
	 */
	public JSONObject handleSystemMessage(WebSocketSession session, TextMessage message) throws Exception {
		JSONParser jsonParser = new JSONParser();
		//JSONParser로 message를 파싱해서 json객체를 만든다.
		jsonObject = (JSONObject) jsonParser.parse(message.getPayload());
		JSONObject jsonSystemMessage = new JSONObject();
		
		//jsonObject에서 접속한 user_id를 뽑아내고,
		String user_id = (String) jsonObject.get("user_id");
		String join = jsonObject.get("join").toString();
		String room = jsonObject.get("room").toString();
		if(room.length() > 10) {
			room = jsonObject.get("room").toString().substring(0, 10);
		}
		
		//채팅방 이름이 공백이 들어왔을 경우 대기실로 보낸다.
		if(room.equals("")) {
			room = "대기실";
		}

		JSONArray jsonRoomUsers = new JSONArray();
		//접속 시
		if(join.equals("y")) {
			//전달받은 아이디가 익명일 경우, 랜덤한 닉네임을 부여한다.
			if(user_id.equals("익명")) {
				String nickname = chatNicknames.popRandomName();
				session.sendMessage(new TextMessage(nickname));
				user_id = nickname;
				jsonSystemMessage.put("user_id", user_id);
			}
			
			boolean chkId = false;
			//jsonUser 배열의 요소와 비교한 뒤, 
			for(Object item:jsonUsers) {
				if(item.equals(user_id)) {
					chkId = true;
					break;
				}
			}
			//중복이 되지 않으면 추가한다.
			if(!chkId) {
				jsonUsers.add(user_id);
			}
			
			//전역변수 HashMap roomUsers에 key:아이디, value:채팅방을 저장한다.
			roomUsers.put(user_id, room);
			/* roomUsers의 key 목록을 반복해서 돌려서 key의 value가 전달받은 room과 같으면
			 * 지역변수 JSONArray jsonRoomUsers에 해당 key를 추가한다. */
			for(String key:roomUsers.keySet()) {
				if(roomUsers.get(key).equals(room)) {
					jsonRoomUsers.add(key);
				}
			}
			//전역변수 JSONObject jsonRoom에 key:room, value:jsonRoomUsers를 저장한다.
			jsonRoom.put(room, jsonRoomUsers);
			//chatroom에 room과 session을 저장한다.
			chatroom.put(session, room);
			logger.info("제이슨 어레이 : " + jsonRoom);
		//접속 해제 시	
		} else if(join.equals("n")) {
			
			if(!user_id.contains("@")) {
				chatNicknames.returnName(user_id);
			}
			
			for(Object item:jsonUsers) {
				if(item.equals(user_id)) {
					logger.info("접속 해제, 리스트 삭제 : " + item);
					jsonUsers.remove(item);
					roomUsers.remove(item);
					break;
				}
			}
			
			for(String key:roomUsers.keySet()) {
				//접속 해제이므로 jsonRoomUsers에 key가 자신의 아이디와 다른 것만 추가시킨다.
				if(roomUsers.get(key).equals(room) && !key.equals(user_id)) {
					jsonRoomUsers.add(key);
				}
			}
			//chatroom에 저장했던 room과 session을 삭제한다.
			chatroom.remove(session);
			jsonRoom.put(room, jsonRoomUsers);
		}
		
		//빈 채팅방을 삭제한다. 빈 방은 string으로 변환한 length가 2가 나온다.
		for(Object key:jsonRoom.keySet()) {
			if(jsonRoom.get(key).toString().length() == 2) {
				jsonRoom.remove(key);
			}
		}
		
		//jsonObject에 각 채팅방의 접속자목록을 추가한다.
		jsonSystemMessage.put("room_users", jsonRoom);
		//전체 접속자목록을 추가한다.
		jsonSystemMessage.put("user_list", jsonUsers);
		
		logger.info("제이슨 파서 : " + jsonSystemMessage);
		
		return jsonSystemMessage;
		
	}
	
	/** 같은 채팅방 유저에게 보낼 메시지를 다루는 메소드
	 */
	public JSONObject handleChatMessage(WebSocketSession session, TextMessage message) throws Exception {
		JSONParser jsonParser = new JSONParser();
		//JSONParser로 message를 파싱해서 json객체를 만든다.
		jsonObject = (JSONObject) jsonParser.parse(message.getPayload());
		String room = jsonObject.get("room").toString();
		if(room.equals("")) {
			room = "대기실";
		}
		jsonObject.put("room", room);
		logger.info("제이슨 파서 : " + jsonObject);
		String message_content = (String) jsonObject.get("message_content");
		//메시지 길이가 5천자를 넘어갈 경우, 5천자까지만 잘라낸다.
		if(message_content.length() > 5000) {
			message_content = message_content.substring(0, 5000);
		}
		logger.info("message_content : " + message_content);
		
		//메시지에 태그나 스크립트를 삽입하는 것을 막는다.
		jsonObject.put("message_content", message_content.replaceAll("<", "&lt;"));
		
		return jsonObject;
		
	}
	
	
}