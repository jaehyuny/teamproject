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


public class ChatWebSocketHandler extends TextWebSocketHandler {
	
	static final int CONNECT = 0;
	static final int CHAT = 1;
	static final int SYSTEM = 2;
	static final int DISCONNECT = 3;
	
	Startable protocols[] = new Startable[4];
	WebSocketSession session;
	
	
	@Inject
	private ChatNicknames chatNicknames;
	
	/*접속 중인 모든 session을 저장하는 List*/
	private List<WebSocketSession> connectedUsers;
	/*각 채팅방에 입장 중인 session을 저장하는 HashMap*/
	private HashMap<WebSocketSession, String> chatroom;
	/*접속한 session의 닉네임(혹은 id)를 저장하는 HashMap*/
	private HashMap<WebSocketSession, String> username;
	public static HashMap<WebSocketSession, Integer> intervalMap = new HashMap<>();
	private static Logger logger = LoggerFactory.getLogger(ChatWebSocketHandler.class);
	
	HashMap<String, String> roomUsers = new HashMap<>();
	JSONObject jsonRoom = new JSONObject();
	JSONObject jsonReceive = new JSONObject();
	
	
	public ChatWebSocketHandler() {
		connectedUsers = new ArrayList<WebSocketSession>();
		username = new HashMap<>();
		chatroom = new HashMap<>();

		protocols[0] = new ConnectProtocol();
		protocols[1] = new ChatProtocol();
		
	}
	

	//접속에 성공했을 때 작동
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		this.session = session;
		for(WebSocketSession websession:connectedUsers) {
			//접속한 session의 ip를 확인해서 동일할 시 접속을 해제한다.
			if(websession.getRemoteAddress().getHostName().equals(session.getRemoteAddress().getHostName())) {
				logger.info("동일 ip에서 접속했습니다. 이전 접속자의 연결을 끊습니다.");
				websession.close();
				break;
			}
		}
		
		connectedUsers.add(session);
		
		intervalMap.put(session, 0);
		
		ChatIntervalThread r1 = new ChatIntervalThread(session);
		Thread t1 = new Thread(r1);
		t1.start();
		
		logger.debug("입장 : " + session.getId());
		logger.debug("웹소켓 LocalAddress : " + session.getLocalAddress());
		logger.debug("웹소켓 RemoteAddress HostName : " + session.getRemoteAddress().getHostName());
		logger.debug("웹소켓 Uri : " + session.getUri());
		logger.debug("웹소켓 Principal : " + session.getPrincipal());
		logger.info("=====접속에 성공했습니다=====");
//		super.afterConnectionEstablished(session);
	}
	
	//메시지를 전송받았을 때 작동
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

		JSONParser jsonParser = new JSONParser();
		jsonReceive = (JSONObject) jsonParser.parse(message.getPayload());
		logger.info("받은 메시지 : " + jsonReceive);
		int protocol = Integer.parseInt(jsonReceive.get("protocol").toString());
		if(protocol == 99) {
			long beforeTime = System.currentTimeMillis();
			logger.info("주기적인 신호 받았음..." + beforeTime);
			intervalMap.merge(session, 1, Integer::sum);
//			intervalMap.replace(session, intervalMap.get(session)+1);
		} else {
			protocols[protocol].Start(session, jsonReceive, jsonRoom, connectedUsers, chatroom, username, chatNicknames);
		}
		
		
//		super.handleTextMessage(session, message);
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// TODO Auto-generated method stub
		
		session.close();
		System.err.println("뭔가 에러가 났음 session : " + session);
		System.err.println("뭔가 에러가 났음 exception: " + exception);
		
//		super.handleTransportError(session, exception);
	}

	//접속을 끊었을 때 작동
	@SuppressWarnings("unchecked")
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		logger.info("close session : " + session);
		logger.info("close status : " + status);

		String user_id = username.get(session);
		String room = chatroom.get(session);
		
		if(user_id != null) {
			if(!user_id.contains("@")) {
				chatNicknames.returnName(user_id);
			}
		} else {
			System.err.println("user_id가 null입니다");
		}
		
		
		connectedUsers.remove(session);
		username.remove(session);
		chatroom.remove(session);
		
		
		JSONArray jsonRoomUsers = new JSONArray();
		for(WebSocketSession sess:username.keySet()) {
			if(chatroom.get(sess).equals(room)) {
				jsonRoomUsers.add(username.get(sess));
			}
		}
		JSONArray jsonUsers = new JSONArray();
		for(WebSocketSession sess:username.keySet()) {
			jsonUsers.add(username.get(sess));
		}
		jsonRoom.put(room, jsonRoomUsers);

		//빈 채팅방을 삭제한다. 빈 방은 string으로 변환한 length가 2가 나온다.
		for(Object key:jsonRoom.keySet()) {
			if(jsonRoom.get(key).toString().length() == 2) {
				jsonRoom.remove(key);
			}
		}
		
		JSONObject jsonDisconnectMessage = new JSONObject();
		jsonDisconnectMessage.put("protocol", ChatWebSocketHandler.DISCONNECT);
		jsonDisconnectMessage.put("user_id", user_id);

		JSONObject jsonSystemMessage = new JSONObject();
		jsonSystemMessage.put("protocol", ChatWebSocketHandler.SYSTEM);
		jsonSystemMessage.put("room_users", jsonRoom);
		jsonSystemMessage.put("user_list", jsonUsers);
		
		for(WebSocketSession sess:connectedUsers) {
			sess.sendMessage(new TextMessage(jsonSystemMessage.toString()));
			
			if(chatroom.get(sess).equals(room)) {
				sess.sendMessage(new TextMessage(jsonDisconnectMessage.toString()));
			}
			
		}
		logger.info("=====접속이 종료되었습니다=====");
//		super.afterConnectionClosed(session, status);
	}
	

	
}