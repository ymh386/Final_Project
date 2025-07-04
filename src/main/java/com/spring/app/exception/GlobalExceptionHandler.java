package com.spring.app.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

import java.sql.SQLException;

@ControllerAdvice
public class GlobalExceptionHandler {
    
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);
    

    
    /**
     * 데이터베이스 관련 예외 처리
     */
    @ExceptionHandler(SQLException.class)
    public ModelAndView handleSQLException(SQLException e, HttpServletRequest request) {
        logger.error("SQL Exception occurred: {}", e.getMessage(), e);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("error/database-error");
        mav.addObject("errorMessage", "데이터베이스 처리 중 오류가 발생했습니다.");
        mav.addObject("requestUrl", request.getRequestURL().toString());
        
        return mav;
    }
    
    /**
     * NullPointerException 처리
     */
    @ExceptionHandler(NullPointerException.class)
    public ModelAndView handleNullPointerException(NullPointerException e, HttpServletRequest request) {
        logger.error("NullPointer Exception occurred: {}", e.getMessage(), e);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("error/null-pointer-error");
        mav.addObject("errorMessage", "시스템 오류가 발생했습니다. 관리자에게 문의해주세요.");
        mav.addObject("requestUrl", request.getRequestURL().toString());
        
        return mav;
    }
    
    /**
     * IllegalArgumentException 처리
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ModelAndView handleIllegalArgumentException(IllegalArgumentException e, HttpServletRequest request) {
        logger.error("IllegalArgument Exception occurred: {}", e.getMessage(), e);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("error/invalid-parameter-error");
        mav.addObject("errorMessage", "잘못된 요청입니다. 입력값을 확인해주세요.");
        mav.addObject("requestUrl", request.getRequestURL().toString());
        
        return mav;
    }
    
    /**
     * 모든 예외를 처리하는 최종 핸들러
     */
    @ExceptionHandler(Exception.class)
    public ModelAndView handleGenericException(Exception e, HttpServletRequest request) {
        logger.error("Unexpected Exception occurred: {}", e.getMessage(), e);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("error/general-error");
        mav.addObject("errorMessage", "시스템 오류가 발생했습니다.");
        mav.addObject("requestUrl", request.getRequestURL().toString());
        mav.addObject("timestamp", System.currentTimeMillis());
        
        return mav;
    }
}