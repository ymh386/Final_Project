package com.spring.app.subscript;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SubscriptDAO {
	
	List<SubscriptionVO> getPlans() throws Exception;
	
	SubscriptionVO getPlansDetail(Long id) throws Exception;
	
	List<SubscriptVO> getEndingPlan() throws Exception;
	
	LocalDate getEndDate(@Param("username") String username) throws Exception;
	
	SubscriptVO getSubscriptById(@Param("subscriptionId") Long subscriptionId,
								 @Param("username") String username) throws Exception;
	
	List<SubscriptVO> getSubscriptByUser(@Param("username") String username) throws Exception;
	
	int newSubscript(SubscriptVO subscriptVO) throws Exception;
	
	int updateSubscript(SubscriptVO subscriptVO) throws Exception;
	
	int deleteSubscript(SubscriptVO subscriptVO) throws Exception;
	
	Long getNextId() throws Exception;
	
	public int getRemainDays(@Param("username") String username) throws Exception;
	
}
