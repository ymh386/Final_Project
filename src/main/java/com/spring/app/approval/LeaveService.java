package com.spring.app.approval;



import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class LeaveService {
	
	@Autowired
	private ApprovalDAO approvalDAO;
	
	public LeaveVO useLeave(String contentHtml) {
		LeaveVO leaveVO = new LeaveVO();
		//html형식 파싱해서 가져오기
		Document doc = Jsoup.parse(contentHtml);
		
		//제목부분 텍스트 꺼내오기
		Element title = doc.getElementById("title");
		String titleText = "";
		if (title != null) {
		    Element span = title.selectFirst("span");
		    if (span != null) {
		        titleText = span.text().trim();
		    }
		}
		//꺼내온 제목이 "휴가신청서"가 아닐 때 null return
		if(!"휴가신청서".equals(titleText)) {
			return null;
		}
		
		for(int i=1; i>0; i++) {
			Element leaveTypeDiv = doc.getElementById("aa"+i); // 휴가 종류 부분
			//휴가 종류부분 값(innerText와 같음)
			String leaveTypeText = leaveTypeDiv != null ? leaveTypeDiv.text() : "";
			
			//해당 정규식의 패턴 생성(체크 여부)
			Pattern pattern = Pattern.compile("\\((.*?)\\)");
			//만든 정규식패턴으로 해당 문자열을 파싱
			Matcher matcher = pattern.matcher(leaveTypeText);
			//파싱이 완료되면 공백제거해서 ( )안 문자열만 남게함
			String insideBracket = "";
			if (matcher.find()) {
			    insideBracket = matcher.group(1).trim(); // "O" 또는 "" (공백)
			}
			
			// 체크 여부 판단
			boolean isChecked = "O".equalsIgnoreCase(insideBracket);
			if(isChecked) {
				// leaveTypeText 예: "연차( )" → 정규식으로 '연차' 추출
				String leaveType = leaveTypeText.replaceAll("\\(.*\\)", "").trim();
				if("연차".equals(leaveType)) {
					leaveVO.setTypeId(1L);
					break;
				}else if("훈련".equals(leaveType)) {
					leaveVO.setTypeId(2L);
					break;
				}else if("병가".equals(leaveType)) {
					leaveVO.setTypeId(3L);
					break;
				}else {
					leaveVO.setTypeId(4L);
					break;
				}
			}
		}
		
		//휴가 일수 부분
		Element totalDaysDiv = doc.getElementById("h_caldate");
		//휴가 일수부분 값
		String totalDaysText = totalDaysDiv != null ? totalDaysDiv.text() : "";
		
		Long totalDays = 0L;
		//위와 같음( ( )안 숫자 파싱)
		Pattern p = Pattern.compile("(\\d+)");
		Matcher m = p.matcher(totalDaysText);
		//파싱이 완료되면 안에 숫자를 Long 타입으로 파싱해서 가져옴
		if (m.find()) {
		    totalDays = Long.parseLong(m.group(1));
		}
		
		leaveVO.setUsedDays(totalDays);
		
		return leaveVO;
	}
	
	public int updateLeave(LeaveVO leaveVO) throws Exception {
		return approvalDAO.updateLeave(leaveVO);
	}

}
