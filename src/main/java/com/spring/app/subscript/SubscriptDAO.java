package com.spring.app.subscript;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SubscriptDAO {
	
	List<SubscriptionVO> getPlans() throws Exception;
	
	SubscriptionVO getPlansDetail(Long id) throws Exception;
	
	SubscriptVO getSubscriptById(@Param("subscriptionId") Long subscriptionId,
								 @Param("username") String username) throws Exception;
	
	List<SubscriptVO> getSubscriptByUser(@Param("username") String username) throws Exception;
	
	int newSubscript(SubscriptVO subscriptVO) throws Exception;
	
	int updateSubscript(@Param("subscriptionId") Long subscriptionId,
						@Param("status") String newStatus) throws Exception;
	
	Long getNextId() throws Exception;
	
	public int getRemainDays(@Param("username") String username) throws Exception;
	
}
