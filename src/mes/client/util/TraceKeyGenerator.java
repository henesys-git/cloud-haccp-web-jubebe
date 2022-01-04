package mes.client.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/*
 * �ۼ��� : ������
 * �ۼ��� : 2020-12-04
 * ���� : ������ �������縦 â�� �԰� �� ����� '�̷� ���� Ű'�� �����ϱ� ����
 */
public class TraceKeyGenerator {
	
	public static String generateTraceKey() {
		
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");  
		LocalDateTime now = LocalDateTime.now();  
		String trace_key = dtf.format(now);
			
		return trace_key;
	}
	
}