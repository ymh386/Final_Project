package com.spring.app.interceptor;

import java.util.Map;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import jakarta.servlet.http.HttpServletRequest;

//웹소켓 통신시 사용하는 인터셉터(WebMvcConfig가 아닌 WebSocketConfig에 등록)
public class WebSocketInterceptor implements HandshakeInterceptor {
	
	@Override
	public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			Map<String, Object> attributes) throws Exception {
		
		//WebSocket 연결 요청이 실제로는 HTTP 요청이기 때문에 이를 ServletServerHttpRequest로 다운캐스팅
		if (request instanceof ServletServerHttpRequest servletRequest) {
			//Servlet API 기반의 HttpServletRequest로 접근
			HttpServletRequest httpServletRequest = servletRequest.getServletRequest();
			
			
			// IP 주소
            String ip = httpServletRequest.getHeader("X-Forwarded-For");
            if (ip == null) {
                ip = httpServletRequest.getRemoteAddr();
            }
            
            // User-Agent
            String userAgent = httpServletRequest.getHeader("User-Agent");
            
            // Spring Security에서 인증된 사용자 이름 가져오기
            String username = httpServletRequest.getUserPrincipal().getName();

            // 세션에 저장
            attributes.put("ip", ip);
            attributes.put("userAgent", userAgent);
            attributes.put("username", username);
		}
		
		return true;
	}
	
	
	//필요 시 후 처리
	@Override
	public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			Exception exception) {
		// TODO Auto-generated method stub
		
	}

}
