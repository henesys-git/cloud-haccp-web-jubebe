package service;

import com.popbill.api.PopbillException;
import com.popbill.api.kakao.KakaoButton;
import com.popbill.api.kakao.KakaoReceiver;
import com.popbill.api.kakao.KakaoServiceImp;

import model.Sensor;

public class AlarmServiceKakao implements AlarmService {
	
	private KakaoServiceImp kakaoService = new KakaoServiceImp();
	
	@Override
	public boolean alert(String content) {
		
	    /*
	     * [대량전송] 알림톡 전송을 요청합니다.
	     * 사전에 승인된 템플릿의 내용과 알림톡 전송내용(content)이 다를 경우 전송실패 처리됩니다.
	     * - https://docs.popbill.com/kakao/java/api#SendATS_multi
	     */
	    
	    // 팝빌회원 사업자번호
	    String testCorpNum = "";

	    // 알림톡 템플릿코드
	    // 승인된 알림톡 템플릿 코드는 ListATStemplate API, GetATSTemplateMgtURL API, 또는 팝빌사이트에서 확인 가능합니다.
	    String templateCode = "";

	  	//발신번호 (팝빌에 등록된 발신번호만 이용가능)
	    String senderNum = "010"; 

	    // 대체문자 유형 [공백-미전송, C-알림톡내용, A-대체문자내용]
	    String altSendType = "C";

	    KakaoReceiver[] receivers = new KakaoReceiver[2]; //인원수대로
	    
	 	// 예약일시 (작성형식 : yyyyMMddHHmmss)
	    String sndDT = "";
	    // 전송요청번호
	    // 파트너가 전송 건에 대해 관리번호를 구성하여 관리하는 경우 사용.
	    // 1~36자리로 구성. 영문, 숫자, 하이픈(-), 언더바(_)를 조합하여 팝빌 회원별로 중복되지 않도록 할당.
	    String requestNum = "";

	    // 팝빌회원 아이디
	    String testUserID = "gjbread2";
	     
	    // 접수번호
	    String receiptNum = null;

	    // 알림톡 버튼정보를 템플릿 신청시 기재한 버튼정보와 동일하게 전송하는 경우 null 처리.
	    KakaoButton[] btns = null;
	    
	    // 알림톡 내용 (최대 1000자)
//    	String sensorName = sensor.getName();
//    	String value = String.valueOf(sensor.getValue());
//    	String minValue = String.valueOf(sensor.getMinValue());
//    	String maxValue = String.valueOf(sensor.getMaxValue());
		
//	    content = " <"+sensorName+">\n";
//	    content += "한계기준이탈\n";
//	    content += "한계 기준 : "+minValue+" ~ "+maxValue+"\n\n";
//	    content += "센서 데이터 : "+value+"\n\n";
	    
	    // 1회 최대 전송 1,000건 전송 가능
   		// 알림톡 받을 인원 추가
        KakaoReceiver message = new KakaoReceiver();
        message.setReceiverNum("010");
        message.setReceiverName("수신자명");
        message.setMessage(content);
        message.setAltMessage("대체문자 내용");
        receivers[0] = message;

 		KakaoReceiver message2 = new KakaoReceiver();
        message2.setReceiverNum("010");
        message2.setReceiverName("수신자명");
        message2.setMessage(content);
        message2.setAltMessage("대체문자 내용");
        receivers[1] = message2;

    	try {
  			// 알람톡을 발송한다
			receiptNum = kakaoService.sendATS(testCorpNum, templateCode, senderNum, 
					altSendType, receivers, sndDT, testUserID, requestNum, btns);
			
			return true;
        } catch (PopbillException pe) {
        	System.out.println("KAKAO TALK ALARM EXCEPTION_MAX!!");
        	System.out.println(testCorpNum + " ///// " + templateCode + " ///// " + senderNum + " ///// " + altSendType + " ///// " + receivers + " ///// " + sndDT + " ///// " + testUserID + " ///// " + requestNum + " ///// " + btns);
        	System.out.println(receiptNum);
        	System.out.println("[카톡 알림] 에러 코드: " + pe.getCode());
        	System.out.println("[카톡 알림] 에러 메세지: " + pe.getMessage());
        }
	    	
		return false;
	}
}
