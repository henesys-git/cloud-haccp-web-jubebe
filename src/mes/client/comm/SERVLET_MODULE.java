package mes.client.comm;
import java.text.DecimalFormat;

import org.json.simple.JSONObject;

import mes.frame.common.HashObject;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.serviceinterface.ServiceDelegator;
public class SERVLET_MODULE {

	public SERVLET_MODULE() {
		// TODO Auto-generated constructor stub
	}

	public String performTask(String pid, String myParameters) throws Exception {

		// 보내온 전문 데이터를 분해해서 ... 
		String[] rcvStringParams = myParameters.split("\t");

		// 써비스 객체 생성
		ServiceDelegator serviceDelegator = ServiceDelegator.getInstance();

		// 파라미터 객체 생성
		InoutParameter ioParam = new InoutParameter();
		
		// 해쉬테이블
		HashObject hashObject = new HashObject();
		
		// 클라이언트로 내려보낼 전문 버퍼
		StringBuffer returnStringBuffer = new StringBuffer();

		try {
			// 실제 적용할 파라미터들은 해쉬테이블에 저장한다.
			hashObject.put("rcvData", rcvStringParams[3]);
			hashObject.put("pid", pid);

			// 해쉬테이블에 담긴 파라미터들을 뿌려본다.
			hashObject.print();
			// 해쉬테이블에서 프로그램 ID를 구한다.
			pid = String.valueOf(hashObject.get("pid", HashObject.YES));
			
			// 파라미터 객체에 프로그램 ID를 세팅한다.
			ioParam.setEventID(pid);
			
			ioParam.setActionCommand(rcvStringParams[1]);

			// 파라미터 객체에 파라미터가 담긴 해쉬테이블을 세팅한다.
			ioParam.setInputParam(hashObject);
			
			// 써비스를 요청한다.
			int resultValue = serviceDelegator.doService(ioParam);
			
			// 써비스 결과
			if (resultValue < 0) {
				LoggingWriter.setLogDebug("___HenesysMesServletWeb","실패");
			}
			
			// 클라이언트로 내려보낼 전문을 만들자 
			// [Length \t Head \t responseInt \t columnCount \t Data]

			// 헤드
			returnStringBuffer.append(rcvStringParams[1] + "\t");
			// responseInt
			returnStringBuffer.append("" + resultValue + "\t");
			// columnCount
			returnStringBuffer.append("" + ioParam.getColumnCount() + "\t");
			// 결과데이터
			returnStringBuffer.append(ioParam.getResultString() + "\t");
			
			// 전체 보낼전문 길이
			try {
				int dataLength = ((returnStringBuffer.toString()).getBytes()).length;
			    DecimalFormat df7 = new DecimalFormat("0000000");
				returnStringBuffer.insert(0, "" + df7.format(dataLength+8) + "\t");
			} catch (Exception e) {
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return returnStringBuffer.toString();
	}
	

	public String performTask(String pid, JSONObject myParameters, boolean continueYN, String QueryString) throws Exception {
		// 써비스 객체 생성
		ServiceDelegator serviceDelegator = ServiceDelegator.getInstance();
		// 파라미터 객체 생성
		InoutParameter ioParam = new InoutParameter();
		// 해쉬테이블
		HashObject hashObject = new HashObject();
		// 클라이언트로 내려보낼 전문 버퍼
		StringBuffer returnStringBuffer = new StringBuffer();

		try {
			// 실제 적용할 파라미터들은 해쉬테이블에 저장한다.
			hashObject.put("rcvData", myParameters);
			//---2018-12-26
			hashObject.put("pid", pid);			

			// 해쉬테이블에 담긴 파라미터들을 뿌려본다.
			hashObject.print();
			// 해쉬테이블에서 프로그램 ID를 구한다.
			pid = String.valueOf(hashObject.get("pid", HashObject.YES));
			
			// 파라미터 객체에 프로그램 ID를 세팅한다.
			ioParam.setEventID(pid);
			// actionCommand = ""; // doQuery 등 ... 이번에 doQueryTableFieldName을 EDMS에 사용할라꼬 이넘을 추가한다. 2018.06.26 지노가...ㅎㅎ
			ioParam.setActionCommand(QueryString);

			// 파라미터 객체에 파라미터가 담긴 해쉬테이블을 세팅한다.
			ioParam.setInputParam(hashObject);
			// 써비스를 요청한다.
			int resultValue = serviceDelegator.doService(ioParam);
			// 써비스 결과
			if (resultValue < 0) {
				LoggingWriter.setLogDebug("___HenesysMesServletWeb","실패");
			}
			
			// 클라이언트로 내려보낼 전문을 만들자 [Length \t Head \t responseInt \t columnCount \t Data]
			
			// 헤드
			returnStringBuffer.append(QueryString + "\t");
			// responseInt
			returnStringBuffer.append("" + resultValue + "\t");
			// columnCount
			returnStringBuffer.append("" + ioParam.getColumnCount() + "\t");
			// 결과데이터
			returnStringBuffer.append(ioParam.getResultString() + "\t");
			
			// 전체 보낼전문 길이
			try {
				int dataLength = ((returnStringBuffer.toString()).getBytes()).length;
			    DecimalFormat df7 = new DecimalFormat("0000000");
				returnStringBuffer.insert(0, "" + df7.format(dataLength+8) + "\t");
			} catch (Exception e) {
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return returnStringBuffer.toString();
	}
}