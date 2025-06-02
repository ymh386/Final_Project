package com.spring.app.filter;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import jakarta.servlet.Filter;

@Configuration
public class FilterConfig implements WebMvcConfigurer {
	
	@Bean
	FilterRegistrationBean<Filter> filterBean() {
		final FilterRegistrationBean<Filter> ar = new FilterRegistrationBean<>(new TestFilter());
		ar.addUrlPatterns("/notice/*");
		
		return ar;		
	}
}
