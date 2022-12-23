package utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Random;




/*
 * �ۼ��� : ������
 * �ۼ��� : 2022-01-17
 * ���� : ����ǰ/������� ��� ���̺� Ű�� ���� ����ȣ ������ ����
 * �Ķ����: String(�����ȹ��ȣ_������ι�ȣ) or No Parameter
 * ����� : �����ȹ��ȣ_������ι�ȣ_��������4�ڸ� or ���ó�¥_0_��������4�ڸ�
 */
public class StockNoGenerator {
	
	private static int getRandomNumberInRange(int min, int max) {
        
        Random r = new Random();
        return r.ints(min, (max + 1)).limit(1).findFirst().getAsInt();
        
    }
	
	private static String getDate() {
        
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMdd");  
		LocalDateTime now = LocalDateTime.now();  
		return dtf.format(now);  
    }
	
	// �����ȹ��ȣ�� ���� ��
	public static String generate(String preProdStockNo) {
		
	    int randomNum = StockNoGenerator.getRandomNumberInRange(1000, 9999);
	    String randomNumStr = String.valueOf(randomNum);
	    
	    String prodStockNum = preProdStockNo.concat("_").concat(randomNumStr);
		
	    return prodStockNum;
	}
	
	// �����ȹ��ȣ�� ���� ��
	public static String generate() {

	    int randomNum = StockNoGenerator.getRandomNumberInRange(1000, 9999);
	    String randomNumStr = String.valueOf(randomNum);
	    
	    return getDate().concat("_0_").concat(randomNumStr);
	}
	
}