package com.team.project.websocket;

import java.util.HashMap;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.team.project.submodule.ChatNicknames;

public class ConnectProtocol implements Startable {
	
	
	@Override
	public void Start(WebSocketSession session, JSONObject jsonReceive, 
			JSONObject jsonRoom,
			List<WebSocketSession> connectedUsers,
			HashMap<WebSocketSession, String> chatroom, 
			HashMap<WebSocketSession, String> username,
			ChatNicknames chatNicknames) throws Exception {

		
		//jsonObject에서 접속한 user_id를 뽑아내고,
		String user_id = (String) jsonReceive.get("user_id");
		
		//이미 동일한 아이디로 접속했다면, 먼저 접속한 session을 끊는다.
		for(WebSocketSession sess:username.keySet()) {
			if(username.get(sess).equals(user_id)) {
				sess.close();
				break;
			}
		}
		
		//방의 이름은 열자가 넘어가지 않게 잘라낸다.
		String room = jsonReceive.get("room").toString();
		if(room.length() > 10) {
			room = jsonReceive.get("room").toString().substring(0, 10);
		}
		
		//채팅방 이름이 공백이 들어왔을 경우 대기실로 보낸다.
		if(room.equals("")) {
			room = "대기실";
		}
		
		//전달받은 아이디가 익명일 경우, 랜덤한 닉네임을 부여한다.
		if(user_id.equals("익명")) {
			String nickname = chatNicknames.popRandomName();
			user_id = nickname;
			System.out.println("랜덤 닉네임을 줍니다 : " + user_id);
		}
		
		//username을 확인하고 중복되지 않으면 부여받은 아이디를 클라이언트에 전송한다.
		boolean chkId = false;
		for(WebSocketSession key:username.keySet()) {
			if(username.get(key).equals(user_id)) {
				chkId = true;
				break;
			}
		}
		if(!chkId) {
			username.put(session, user_id);
			session.sendMessage(new TextMessage(user_id));
		}
		
		JSONArray jsonUsers = new JSONArray();
		for(WebSocketSession sess:username.keySet()) {
			jsonUsers.add(username.get(sess));
		}
		
		chatroom.put(session, room);

		JSONArray jsonRoomUsers = new JSONArray();
		/* username의 key 목록을 반복해서 돌려서 key의 value가 전달받은 room과 같으면
		 * 지역변수 JSONArray jsonRoomUsers에 해당 key를 추가한다. */
		for(WebSocketSession sess:username.keySet()) {
			if(chatroom.get(sess).equals(room)) {
				jsonRoomUsers.add(username.get(sess));
			}
		}
		
		//전역변수 JSONObject jsonRoom에 key:room, value:jsonRoomUsers를 저장한다.
		jsonRoom.put(room, jsonRoomUsers);

		JSONObject jsonConnectMessage = new JSONObject();
		jsonConnectMessage.put("protocol", ChatWebSocketHandler.CONNECT);
		jsonConnectMessage.put("user_id", user_id);

		JSONObject jsonSystemMessage = new JSONObject();
		jsonSystemMessage.put("protocol", ChatWebSocketHandler.SYSTEM);
		jsonSystemMessage.put("room_users", jsonRoom);
		jsonSystemMessage.put("user_list", jsonUsers);
		
		for(WebSocketSession sess:connectedUsers) {
			sess.sendMessage(new TextMessage(jsonSystemMessage.toString()));
			
			if(chatroom.get(sess).equals(room)) {
				sess.sendMessage(new TextMessage(jsonConnectMessage.toString()));
			}
		}
		
	}

	
}
