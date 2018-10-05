package com.team.project.websocket;

import java.util.HashMap;
import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.team.project.submodule.ChatNicknames;

public class ChatProtocol implements Startable{

	@SuppressWarnings("unchecked")
	@Override
	public void Start(WebSocketSession session, JSONObject jsonReceive, 
			JSONObject jsonRoom, List<WebSocketSession> connectedUsers,
			HashMap<WebSocketSession, String> chatroom, HashMap<WebSocketSession, String> username,
			ChatNicknames chatNicknames) throws Exception {

		String user_id = (String) jsonReceive.get("user_id");
		String room = jsonReceive.get("room").toString();
		String message_content = jsonReceive.get("message_content").toString();

		//메시지 길이가 5천자를 넘어갈 경우, 5천자까지만 잘라낸다.
		if(message_content.length() > 5000) {
			message_content = message_content.substring(0, 5000);
		}
		
		JSONObject jsonSend = new JSONObject();
		
		jsonSend.put("protocol", ChatWebSocketHandler.CHAT);
		jsonSend.put("user_id", user_id);
		jsonSend.put("room", room);
		//메시지에 태그나 스크립트를 삽입하는 것을 막는다.
		jsonSend.put("message_content", message_content.replaceAll("<", "&lt;"));
		for(WebSocketSession sess:chatroom.keySet()) {
			if(chatroom.get(sess).equals(room)) {
				sess.sendMessage(new TextMessage(jsonSend.toString()));
			}
			
		}
		
	}

	
}
