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
	     * [�뷮����] �˸��� ������ ��û�մϴ�.
	     * ������ ���ε� ���ø��� ����� �˸��� ���۳���(content)�� �ٸ� ��� ���۽��� ó���˴ϴ�.
	     * - https://docs.popbill.com/kakao/java/api#SendATS_multi
	     */
	    
	    // �˺�ȸ�� ����ڹ�ȣ
	    String testCorpNum = "";

	    // �˸��� ���ø��ڵ�
	    // ���ε� �˸��� ���ø� �ڵ�� ListATStemplate API, GetATSTemplateMgtURL API, �Ǵ� �˺�����Ʈ���� Ȯ�� �����մϴ�.
	    String templateCode = "";

	  	//�߽Ź�ȣ (�˺��� ��ϵ� �߽Ź�ȣ�� �̿밡��)
	    String senderNum = "010"; 

	    // ��ü���� ���� [����-������, C-�˸��峻��, A-��ü���ڳ���]
	    String altSendType = "C";

	    KakaoReceiver[] receivers = new KakaoReceiver[2]; //�ο������
	    
	 	// �����Ͻ� (�ۼ����� : yyyyMMddHHmmss)
	    String sndDT = "";
	    // ���ۿ�û��ȣ
	    // ��Ʈ�ʰ� ���� �ǿ� ���� ������ȣ�� �����Ͽ� �����ϴ� ��� ���.
	    // 1~36�ڸ��� ����. ����, ����, ������(-), �����(_)�� �����Ͽ� �˺� ȸ������ �ߺ����� �ʵ��� �Ҵ�.
	    String requestNum = "";

	    // �˺�ȸ�� ���̵�
	    String testUserID = "gjbread2";
	     
	    // ������ȣ
	    String receiptNum = null;

	    // �˸��� ��ư������ ���ø� ��û�� ������ ��ư������ �����ϰ� �����ϴ� ��� null ó��.
	    KakaoButton[] btns = null;
	    
	    // �˸��� ���� (�ִ� 1000��)
//    	String sensorName = sensor.getName();
//    	String value = String.valueOf(sensor.getValue());
//    	String minValue = String.valueOf(sensor.getMinValue());
//    	String maxValue = String.valueOf(sensor.getMaxValue());
		
//	    content = " <"+sensorName+">\n";
//	    content += "�Ѱ������Ż\n";
//	    content += "�Ѱ� ���� : "+minValue+" ~ "+maxValue+"\n\n";
//	    content += "���� ������ : "+value+"\n\n";
	    
	    // 1ȸ �ִ� ���� 1,000�� ���� ����
   		// �˸��� ���� �ο� �߰�
        KakaoReceiver message = new KakaoReceiver();
        message.setReceiverNum("010");
        message.setReceiverName("�����ڸ�");
        message.setMessage(content);
        message.setAltMessage("��ü���� ����");
        receivers[0] = message;

 		KakaoReceiver message2 = new KakaoReceiver();
        message2.setReceiverNum("010");
        message2.setReceiverName("�����ڸ�");
        message2.setMessage(content);
        message2.setAltMessage("��ü���� ����");
        receivers[1] = message2;

    	try {
  			// �˶����� �߼��Ѵ�
			receiptNum = kakaoService.sendATS(testCorpNum, templateCode, senderNum, 
					altSendType, receivers, sndDT, testUserID, requestNum, btns);
			
			return true;
        } catch (PopbillException pe) {
        	System.out.println("KAKAO TALK ALARM EXCEPTION_MAX!!");
        	System.out.println(testCorpNum + " ///// " + templateCode + " ///// " + senderNum + " ///// " + altSendType + " ///// " + receivers + " ///// " + sndDT + " ///// " + testUserID + " ///// " + requestNum + " ///// " + btns);
        	System.out.println(receiptNum);
        	System.out.println("[ī�� �˸�] ���� �ڵ�: " + pe.getCode());
        	System.out.println("[ī�� �˸�] ���� �޼���: " + pe.getMessage());
        }
	    	
		return false;
	}
}
