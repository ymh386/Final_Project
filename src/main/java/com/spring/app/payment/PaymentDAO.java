package com.spring.app.payment;

import java.time.LocalDateTime;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PaymentDAO {
	
	public int newPayment(PaymentVO paymentVO) throws Exception;
	
	public int newBilling(BillingVO billingVO) throws Exception;
	
	public int updateBilling(@Param("billingId") Long billingId,
							 @Param("billingKey") String billingKey,
							 @Param("createdAt") LocalDateTime createdAt) throws Exception;
	
	public BillingVO getBilling(String username) throws Exception;
	
	public BillingVO getBillingByCard(@Param("username") String username,
									  @Param("cardNumberMasked") String cardNumberMasked) throws Exception;
	
	

}
