package com.spring.app.websocket;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

@Component
public class StompSessionEventListener {
	
	// username 기준으로 ip, agent 저장
    private final Map<String, String> userIpMap  = new ConcurrentHashMap<>();
    private final Map<String, String> userAgentMap = new ConcurrentHashMap<>();

    //getter(IP)
    public String getUserIp(String username) {
        return userIpMap .get(username);
    }
    
    //getter(Agent)
    public String getUserAgent(String username) {
        return userAgentMap.get(username);
    }

    //웹소켓 접속시 이벤트 발생
    @EventListener
    public void handleConnect(SessionConnectEvent event) {
    	//인터셉터에서 저장한 세션 가져오기
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        
        //가져온 세션의 Map에서 필요한 정보들 하나씩 꺼내서 담기
        String username = (String) accessor.getSessionAttributes().get("username");
        String ip = (String) accessor.getSessionAttributes().get("ip");
        String userAgent = (String) accessor.getSessionAttributes().get("userAgent");

        //웹소켓채널에 접속중인 유저일 경우 실행
        if (username != null) {
        	
        	//해당 유저의 username을 Key로 하고 IP, Agent별로 맴에 저장
            userIpMap.put(username, ip);
            userAgentMap.put(username, userAgent);

            System.out.println("웹소켓 연결 - 사용자: " + username + ", IP: " + ip + ", UA: " + userAgent);
        }

    }

    @EventListener
    public void handleDisconnect(SessionDisconnectEvent event) {
    	StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String username = (String) accessor.getSessionAttributes().get("username");

        if (username != null) {
        	
        	//해당 유저의 username을 Key로 하고 IP, Agent별로 맴에서 제거
            userIpMap.remove(username);
            userAgentMap.remove(username);

            System.out.println("웹소켓 연결 해제 - 사용자: " + username);
        }
    }
}