package com.spring.app.security;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DeniedController {
	
	@GetMapping("/denied/subscription")
	public String subscription() { 
		
		return "error/subscription";
	}
	
	@GetMapping("/denied/trainer")
	public String trainer() { 
		
		return "error/trainer";
	}

}
