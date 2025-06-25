package com.spring.app.chat;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;

@Service
public class ConnectService {
	
	private final SimpMessagingTemplate message;
	
	private ConcurrentMap<String, Set<String>> online = new ConcurrentHashMap<>();
	
	private ConcurrentMap<String, String> session = new ConcurrentHashMap<>();
	
	public ConnectService(SimpMessagingTemplate message) {
		// TODO Auto-generated constructor stub
		this.message = message;
	}
	
	@EventListener
	public void onConnection(SessionSubscribeEvent e) throws Exception {
		
		StompHeaderAccessor access = StompHeaderAccessor.wrap(e.getMessage());
		String user = access.getDestination();
		
		if (user!=null && user.startsWith("/topic/chat/")) {
			String roomId = user.substring(user.lastIndexOf("/")+1);
			String username = access.getUser().getName();
			String sessionId = access.getSessionId();
			
			online.computeIfAbsent(roomId, r -> ConcurrentHashMap.newKeySet()).add(username);
			
			session.put(sessionId, roomId);
			
			System.out.println(online);
			
			message.convertAndSend("/topic/chat/"+roomId+"/presence", online.get(roomId));
		};
		
	}
	
	@EventListener
	public void onDisconnection(SessionDisconnectEvent e) throws Exception {
		
		String sessionId = e.getSessionId();
		String roomId = session.remove(sessionId);
		if (roomId!=null) {
			StompHeaderAccessor access = StompHeaderAccessor.wrap(e.getMessage());
			String user = (access.getUser()!=null ? access.getUser().getName() : null);
			if (user!=null) {
				Set<String> users = online.get(roomId);
				if (users!=null) {
					users.remove(user);
					message.convertAndSend("/topic/chat/"+roomId+"/presence", users);
				}
			}
		}
		
	}

}
