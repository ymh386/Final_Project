package com.spring.app.home;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	
	@GetMapping("/")
	public String home() throws Exception {
		System.out.println("Home");
		
		return "index";
	}
}
