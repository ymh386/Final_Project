package com.spring.app.subscript;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;

@Service
public class SubscriptService {
	
	@Autowired
	private SubscriptDAO subscriptDAO;
	
	public List<SubscriptionVO> getPlans() throws Exception {
		List<SubscriptionVO> list = subscriptDAO.getPlans();
		
		return list;
	}
	
	public SubscriptionVO getPlansDetail(Long id) throws Exception {
		SubscriptionVO subscriptionVO = subscriptDAO.getPlansDetail(id);
		
		return subscriptionVO;
	}
	
	public List<SubscriptVO> getSubscriptByUser(String username) throws Exception {
		List<SubscriptVO> list = subscriptDAO.getSubscriptByUser(username);
		
		return list;
	}
	
	public int getRemainDays(String username) throws Exception {
		int result = subscriptDAO.getRemainDays(username);
		
		return result;
	}
	
	@Transactional
	public SubscriptVO createSubscription(SubscriptVO subscriptVO) throws Exception {
		subscriptVO.setCreatedAt(LocalDateTime.now());
		subscriptDAO.newSubscript(subscriptVO);
		
		return subscriptVO;
	}
	
	@Transactional
	public void cancelSubscript(Long subscriptId, String newStatus) throws Exception {
		subscriptDAO.updateSubscript(subscriptId, newStatus);
	}
	
}
