package com.team.project.websocket;

import java.util.HashMap;
import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.web.socket.WebSocketSession;

import com.team.project.submodule.ChatNicknames;

public interface Startable {
	
	public void Start(WebSocketSession session, JSONObject jsonReceive, JSONObject jsonRoom,
			List<WebSocketSession> connectedUsers, HashMap<WebSocketSession, String> chatroom,
			HashMap<WebSocketSession, String> username, ChatNicknames chatNicknames) throws Exception;
}
