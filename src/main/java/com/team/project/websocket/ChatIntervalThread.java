package com.team.project.websocket;

import java.io.IOException;

import org.springframework.web.socket.WebSocketSession;

public class ChatIntervalThread implements Runnable {

	WebSocketSession session;
	int threadCheck = 0;
	
	public ChatIntervalThread(WebSocketSession session) {
		this.session = session;
	}
	
	@Override
	public void run() {
		try {
			
			while(true) {
				System.out.println(session + " 쓰레드 실행");
				System.out.println("threadCheck : " + threadCheck + "/ intervalCheck : " + ChatWebSocketHandler.intervalMap.get(session));
				if(Math.abs(threadCheck - ChatWebSocketHandler.intervalMap.get(session)) > 2) {
					System.err.println("뭔가 잘못됨");
					session.close();
					ChatWebSocketHandler.intervalMap.remove(session);
					break;
				}
				if(!session.isOpen()) {
					ChatWebSocketHandler.intervalMap.remove(session);
					System.out.println("session이 닫혀서 쓰레드 종료함...");
					break;
				}
				
				Thread.sleep(5000);
				threadCheck += 1;
			}
			
			
		} catch (InterruptedException | IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
