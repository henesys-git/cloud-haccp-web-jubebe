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

		// ������ ���� �����͸� �����ؼ� ... 
		String[] rcvStringParams = myParameters.split("\t");

		// ��� ��ü ����
		ServiceDelegator serviceDelegator = ServiceDelegator.getInstance();

		// �Ķ���� ��ü ����
		InoutParameter ioParam = new InoutParameter();
		
		// �ؽ����̺�
		HashObject hashObject = new HashObject();
		
		// Ŭ���̾�Ʈ�� �������� ���� ����
		StringBuffer returnStringBuffer = new StringBuffer();

		try {
			// ���� ������ �Ķ���͵��� �ؽ����̺� �����Ѵ�.
			hashObject.put("rcvData", rcvStringParams[3]);
			hashObject.put("pid", pid);

			// �ؽ����̺� ��� �Ķ���͵��� �ѷ�����.
			hashObject.print();
			// �ؽ����̺��� ���α׷� ID�� ���Ѵ�.
			pid = String.valueOf(hashObject.get("pid", HashObject.YES));
			
			// �Ķ���� ��ü�� ���α׷� ID�� �����Ѵ�.
			ioParam.setEventID(pid);
			
			ioParam.setActionCommand(rcvStringParams[1]);

			// �Ķ���� ��ü�� �Ķ���Ͱ� ��� �ؽ����̺��� �����Ѵ�.
			ioParam.setInputParam(hashObject);
			
			// ��񽺸� ��û�Ѵ�.
			int resultValue = serviceDelegator.doService(ioParam);
			
			// ��� ���
			if (resultValue < 0) {
				LoggingWriter.setLogDebug("___HenesysMesServletWeb","����");
			}
			
			// Ŭ���̾�Ʈ�� �������� ������ ������ 
			// [Length \t Head \t responseInt \t columnCount \t Data]

			// ���
			returnStringBuffer.append(rcvStringParams[1] + "\t");
			// responseInt
			returnStringBuffer.append("" + resultValue + "\t");
			// columnCount
			returnStringBuffer.append("" + ioParam.getColumnCount() + "\t");
			// ���������
			returnStringBuffer.append(ioParam.getResultString() + "\t");
			
			// ��ü �������� ����
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
		// ��� ��ü ����
		ServiceDelegator serviceDelegator = ServiceDelegator.getInstance();
		// �Ķ���� ��ü ����
		InoutParameter ioParam = new InoutParameter();
		// �ؽ����̺�
		HashObject hashObject = new HashObject();
		// Ŭ���̾�Ʈ�� �������� ���� ����
		StringBuffer returnStringBuffer = new StringBuffer();

		try {
			// ���� ������ �Ķ���͵��� �ؽ����̺� �����Ѵ�.
			hashObject.put("rcvData", myParameters);
			//---2018-12-26
			hashObject.put("pid", pid);			

			// �ؽ����̺� ��� �Ķ���͵��� �ѷ�����.
			hashObject.print();
			// �ؽ����̺��� ���α׷� ID�� ���Ѵ�.
			pid = String.valueOf(hashObject.get("pid", HashObject.YES));
			
			// �Ķ���� ��ü�� ���α׷� ID�� �����Ѵ�.
			ioParam.setEventID(pid);
			// actionCommand = ""; // doQuery �� ... �̹��� doQueryTableFieldName�� EDMS�� ����Ҷ� �̳��� �߰��Ѵ�. 2018.06.26 ���밡...����
			ioParam.setActionCommand(QueryString);

			// �Ķ���� ��ü�� �Ķ���Ͱ� ��� �ؽ����̺��� �����Ѵ�.
			ioParam.setInputParam(hashObject);
			// ��񽺸� ��û�Ѵ�.
			int resultValue = serviceDelegator.doService(ioParam);
			// ��� ���
			if (resultValue < 0) {
				LoggingWriter.setLogDebug("___HenesysMesServletWeb","����");
			}
			
			// Ŭ���̾�Ʈ�� �������� ������ ������ [Length \t Head \t responseInt \t columnCount \t Data]
			
			// ���
			returnStringBuffer.append(QueryString + "\t");
			// responseInt
			returnStringBuffer.append("" + resultValue + "\t");
			// columnCount
			returnStringBuffer.append("" + ioParam.getColumnCount() + "\t");
			// ���������
			returnStringBuffer.append(ioParam.getResultString() + "\t");
			
			// ��ü �������� ����
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